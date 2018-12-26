import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:giv_flutter/util/presentation/dots_indicator.dart';

class ImageCarousel extends StatelessWidget {
  final List<String> imageUrls;
  final double height;
  final PageController pageController;
  final Function onTap;
  final Color backgroundColor;
  final bool withIndicator;

  ImageCarousel({
    Key key,
    this.imageUrls,
    this.height,
    this.pageController,
    this.onTap,
    this.backgroundColor,
    this.withIndicator,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    List<Widget> widgets = [
      Container(
          height: height,
          color: (backgroundColor == null) ? Colors.grey[100] : backgroundColor,
          child: _buildPageView(context),
      ),
    ];

    if (withIndicator != null && withIndicator) {
      widgets.add(_dotIndicator(pageController, imageUrls.length));
    }

    return Stack(children: widgets);
  }

  PageView _buildPageView(BuildContext context) {
    var configuration = createLocalImageConfiguration(context);
    _preLoadNextImage(configuration, 0);

    return PageView(
          controller: pageController,
          children: _buildImageList(imageUrls),
          onPageChanged: (int page) {
            _preLoadNextImage(configuration, page);
          },
        );
  }

  List<Widget> _buildImageList(List<String> imgList) =>
      imgList.map((url) => _buildFadeInImage(url)).toList();

  Widget _buildFadeInImage(String url) {
    return GestureDetector(
      onTap: () { onTap(); },
      child: CachedNetworkImage(
          fit: BoxFit.cover,
          imageUrl: url),
    );
  }

  Positioned _dotIndicator(PageController _pageController, int length) {
    final _kDuration = const Duration(milliseconds: 300);
    final _kCurve = Curves.ease;

    return new Positioned(
        bottom: 0.0,
        left: 0.0,
        right: 0.0,
        child: new Container(
          color: Colors.grey[800].withOpacity(0.25),
          padding: const EdgeInsets.all(10.0),
          child: new Center(
            child: new DotsIndicator(
              controller: _pageController,
              itemCount: length,
              onPageSelected: (int page) {
                _pageController.animateToPage(
                  page,
                  duration: _kDuration,
                  curve: _kCurve,
                );
              },
            ),
          ),
        ));
  }

  void _preLoadNextImage(ImageConfiguration configuration, int page) {
    final nextPage = page + 1;
    if (nextPage < imageUrls.length) {
      CachedNetworkImageProvider(imageUrls[nextPage])..resolve(configuration);
    }
  }
}
