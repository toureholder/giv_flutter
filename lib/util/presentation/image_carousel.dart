import 'dart:async';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:giv_flutter/util/presentation/dots_indicator.dart';

class ImageCarousel extends StatefulWidget {
  final List<String> imageUrls;
  final double height;
  final PageController pageController;
  final Function onTap;
  final Color backgroundColor;
  final bool withIndicator;
  final bool autoAdvance;
  final bool loop;

  ImageCarousel(
      {Key key,
        this.imageUrls,
        this.height,
        this.pageController,
        this.onTap,
        this.backgroundColor,
        this.withIndicator,
        this.autoAdvance,
        this.loop
      }) : super(key: key);

  @override
  _ImageCarouselState createState() => _ImageCarouselState();
}

class _ImageCarouselState extends State<ImageCarousel> {

  Timer _autoAdvanceTimer;
  final _kDuration = const Duration(milliseconds: 300);
  final _kCurve = Curves.ease;

  @override
  Widget build(BuildContext context) {
    List<Widget> widgets = [
      Container(
          height: widget.height,
          color: (widget.backgroundColor == null) ? Colors.grey[100] : widget.backgroundColor,
          child: _buildPageView(context),
      ),
    ];

    if (widget.withIndicator != null && widget.withIndicator) {
      widgets.add(_dotIndicator(widget.imageUrls.length));
    }

    return Stack(children: widgets);
  }

  @override
  void dispose() {
    _cancelAutoAdvanceTimer();
    super.dispose();
  }

  PageView _buildPageView(BuildContext context) {
    final configuration = createLocalImageConfiguration(context);
    _handlePageChange(configuration, 0);

    return PageView(
          controller: widget.pageController,
          children: _buildImageList(widget.imageUrls),
          onPageChanged: (int page) {
            _handlePageChange(configuration, page);
          },
        );
  }

  List<Widget> _buildImageList(List<String> imgList) =>
      imgList.map((url) => _buildFadeInImage(url)).toList();

  Widget _buildFadeInImage(String url) {
    return GestureDetector(
      onTap: () { widget.onTap(); },
      child: CachedNetworkImage(
          fit: BoxFit.cover,
          imageUrl: url),
    );
  }

  Positioned _dotIndicator(int length) {
    return new Positioned(
        bottom: 0.0,
        left: 0.0,
        right: 0.0,
        child: new Container(
          color: Colors.grey[800].withOpacity(0.25),
          padding: const EdgeInsets.all(10.0),
          child: new Center(
            child: new DotsIndicator(
              controller: widget.pageController,
              itemCount: length,
              onPageSelected: (int page) {
                widget.pageController.animateToPage(
                  page,
                  duration: _kDuration,
                  curve: _kCurve,
                );
              },
            ),
          ),
        ));
  }

  // Auto advance methods

  void _advanceToNextPage() {
    final pageCount = widget.imageUrls.length;
    if (pageCount == 1) return;

    var controller =  widget.pageController;
    final nextPage = controller.page.toInt() + 1;

    if (nextPage < pageCount) {
      controller.animateToPage(
          nextPage,
          duration: _kDuration,
          curve: _kCurve);
      return;
    }

    if (widget.loop ?? false) controller.jumpToPage(0);
  }

  void _initAutoAdvanceTimer() {
    _cancelAutoAdvanceTimer();
    _autoAdvanceTimer = Timer(Duration(seconds: 6), _advanceToNextPage);
  }

  void _cancelAutoAdvanceTimer() {
    if (_autoAdvanceTimer?.isActive ?? false) _autoAdvanceTimer.cancel();
  }

  // Page change methods

  void _handlePageChange(ImageConfiguration configuration, int page) {
    _preLoadNextImage(configuration, page);
    if (widget.autoAdvance ?? false) _initAutoAdvanceTimer();
  }

  void _preLoadNextImage(ImageConfiguration configuration, int page) {
    final nextPage = page + 1;
    if (nextPage < widget.imageUrls.length) {
      CachedNetworkImageProvider(widget.imageUrls[nextPage])..resolve(configuration);
    }
  }
}
