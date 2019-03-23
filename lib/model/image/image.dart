import 'dart:io';

import 'package:giv_flutter/model/listing/listing_image.dart';

class Image {
  final String url;
  final File file;

  Image({this.url, this.file});

  Image.fromListingImage(ListingImage listingImage)
      : url = listingImage.url,
        file = null;

  bool get hasUrl => url != null;
  bool get hasFile => file != null;
  bool get isEmpty => (url == null && file == null);

  static List<Image> fromListingImageList(List<ListingImage> list) {
    list.sort((a, b) => a.position.compareTo(b.position));
    return list
        .map((listingImage) => Image.fromListingImage(listingImage))
        .toList();
  }
}
