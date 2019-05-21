import 'dart:convert';

import 'package:giv_flutter/model/listing/listing_image.dart';

class CreateListingRequest {
  final int id;
  final String title;
  final String description;
  final String geoNamesCityId;
  final String geoNamesStateId;
  final String geoNamesCountryId;
  final List<ListingImage> images;
  final List<int> categoryIds;
  final bool isActive;

  CreateListingRequest(
      {this.id,
      this.title,
      this.description,
      this.geoNamesCityId,
      this.geoNamesStateId,
      this.geoNamesCountryId,
      this.images,
      this.categoryIds,
      this.isActive = true});

  Map<String, dynamic> toHttpRequestBody() {
    final listingImages =
        images.map((image) => image.toHttpRequestBody()).toList();
    final listingCategoryIds = categoryIds;

    return {
      'title': title,
      'description': description,
      'geonames_city_id': geoNamesCityId,
      'geonames_state_id': geoNamesStateId,
      'geonames_country_id': geoNamesCountryId,
      'listing_images': listingImages,
      'category_ids': listingCategoryIds,
      'is_active': isActive,
    };
  }

  String toEncodedString() {
    return json.encode(toHttpRequestBody());
  }
}

class UpdateListingActiveStatusRequest {
  final int id;
  final bool isActive;

  UpdateListingActiveStatusRequest(this.id, this.isActive);

  Map<String, dynamic> toHttpRequestBody() => {'is_active': isActive};
}
