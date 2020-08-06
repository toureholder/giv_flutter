import 'dart:async';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:giv_flutter/model/carousel/carousel_item.dart';
import 'package:giv_flutter/util/presentation/dots_indicator.dart';
import 'package:giv_flutter/util/presentation/gradients.dart';
import 'package:giv_flutter/util/presentation/shadows.dart';
import 'package:giv_flutter/util/presentation/typography.dart';
import 'package:giv_flutter/values/dimens.dart';

class HomeCarousel extends StatefulWidget {
  final List<CarouselItem> items;
  final double height;
  final PageController pageController;
  final Function onTap;
  final Color backgroundColor;
  final bool withIndicator;
  final bool autoAdvance;
  final bool loop;
  final Duration autoAdvanceDelay;

  HomeCarousel({
    Key key,
    this.items,
    this.height,
    this.pageController,
    this.onTap,
    this.backgroundColor,
    this.withIndicator,
    this.autoAdvance,
    this.loop,
    this.autoAdvanceDelay,
  }) : super(key: key);

  @override
  _HomeCarouselState createState() => _HomeCarouselState();
}

class _HomeCarouselState extends State<HomeCarousel> {
  Timer _autoAdvanceTimer;
  final _kDuration = const Duration(milliseconds: 300);
  final _kCurve = Curves.ease;
  Duration _autoAdvanceDelay;

  @override
  void initState() {
    super.initState();
    _autoAdvanceDelay = widget.autoAdvanceDelay ?? Duration(seconds: 5);
  }

  @override
  Widget build(BuildContext context) {
    List<Widget> widgets = [
      Container(
        height: widget.height,
        color: (widget.backgroundColor == null)
            ? Colors.grey[100]
            : widget.backgroundColor,
        child: _buildPageView(context),
      ),
    ];

    if (widget.withIndicator != null && widget.withIndicator) {
      widgets.add(_dotIndicator(widget.items.length));
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
      children: _buildItemList(widget.items),
      onPageChanged: (int page) {
        _handlePageChange(configuration, page);
      },
    );
  }

  List<Widget> _buildItemList(List<CarouselItem> imgList) =>
      imgList.map((item) => _buildItem(item)).toList();

  Widget _buildItem(CarouselItem item) {
    final backgroundArt = Row(
      children: <Widget>[
        Expanded(
            child:
                CachedNetworkImage(fit: BoxFit.cover, imageUrl: item.imageUrl)),
      ],
    );

    return GestureDetector(
      onTap: () {
        widget.onTap(item);
      },
      child: item.hasText ? stackWithText(item, backgroundArt) : backgroundArt,
    );
  }

  Stack stackWithText(CarouselItem item, Widget backgroundArt) {
    return Stack(children: <Widget>[
      backgroundArt,
      Container(
        decoration: BoxDecoration(
          gradient: Gradients.carouselBottomLeft(),
        ),
      ),
      Positioned(
        bottom: Dimens.default_vertical_margin,
        left: Dimens.default_horizontal_margin,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            H6Text(
              item.title,
              color: Colors.white,
              shadows: <Shadow>[
                Shadows.text(),
              ],
            ),
            Body2Text(
              item.caption,
              color: Colors.white,
              shadows: <Shadow>[
                Shadows.text(),
              ],
            )
          ],
        ),
      )
    ]);
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
    final pageCount = widget.items.length;
    if (pageCount == 1) return;

    var controller = widget.pageController;
    final nextPage = controller.page.toInt() + 1;

    if (nextPage < pageCount) {
      controller.animateToPage(nextPage, duration: _kDuration, curve: _kCurve);
      return;
    }

    if (widget.loop ?? false) controller.jumpToPage(0);
  }

  void _initAutoAdvanceTimer() {
    _cancelAutoAdvanceTimer();
    _autoAdvanceTimer = Timer(_autoAdvanceDelay, _advanceToNextPage);
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
    if (nextPage < widget.items.length) {
      CachedNetworkImageProvider(widget.items[nextPage].imageUrl)
        ..resolve(configuration);
    }
  }
}
