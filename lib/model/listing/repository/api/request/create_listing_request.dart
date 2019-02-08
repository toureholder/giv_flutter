import 'dart:convert';

import 'package:giv_flutter/model/listing/listing_image.dart';

class CreateListingRequest {
  final String title;
  final String description;
  final String geoNamesCityId;
  final String geoNamesStateId;
  final String geoNamesCountryId;
  final List<ListingImage> images;
  final List<int> categoryIds;

  CreateListingRequest(
      {this.title,
      this.description,
      this.geoNamesCityId,
      this.geoNamesStateId,
      this.geoNamesCountryId,
      this.images,
      this.categoryIds});

  Map<String, dynamic> toHttpRequestBody() {
    final listingImages = images.map((image) => image.toHttpRequestBody()).toList();
    final listingCategoryIds = categoryIds;

    return {
      'title': title,
      'description': description,
      'geonames_city_id': geoNamesCityId,
      'geonames_state_id': geoNamesStateId,
      'geonames_country_id': geoNamesCountryId,
      'listing_images': listingImages,
      'category_ids': listingCategoryIds
    };
  }

  String toEncodedString() {
    return json.encode(toHttpRequestBody());
  }
}
