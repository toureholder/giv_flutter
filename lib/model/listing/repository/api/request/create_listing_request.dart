import 'dart:convert';
import 'package:meta/meta.dart';

import 'package:giv_flutter/model/listing/listing_image.dart';
import 'package:giv_flutter/model/listing/listing_type.dart';

class CreateListingRequest {
  final int id;
  final String title;
  final String description;
  final String geoNamesCityId;
  final String geoNamesStateId;
  final String geoNamesCountryId;
  final List<ListingImage> images;
  final List<int> categoryIds;
  final List<int> groupIds;
  final bool isActive;
  final bool isPrivate;
  final ListingType listingType;

  CreateListingRequest({
    this.id,
    @required this.title,
    @required this.description,
    @required this.geoNamesCityId,
    @required this.geoNamesStateId,
    @required this.geoNamesCountryId,
    @required this.images,
    @required this.categoryIds,
    @required this.groupIds,
    @required this.listingType,
    this.isActive = true,
    this.isPrivate = false,
  });

  Map<String, dynamic> toHttpRequestBody() {
    final listingImages =
        images.map((image) => image.toHttpRequestBody()).toList();

    return {
      'title': title,
      'description': description,
      'geonames_city_id': geoNamesCityId,
      'geonames_state_id': geoNamesStateId,
      'geonames_country_id': geoNamesCountryId,
      'listing_images': listingImages,
      'category_ids': categoryIds,
      'group_ids': groupIds,
      'is_active': isActive,
      'is_private': isPrivate,
      'listing_type': listingTypeToStringMap[listingType],
    };
  }

  String toEncodedString() {
    return json.encode(toHttpRequestBody());
  }

  factory CreateListingRequest.fake() => CreateListingRequest(
        title: 'Testing?',
        description: 'lorem ipsum dolor',
        geoNamesCityId: '123',
        geoNamesStateId: '456',
        geoNamesCountryId: '789',
        categoryIds: <int>[1, 2],
        groupIds: <int>[1, 2],
        isActive: true,
        isPrivate: true,
        listingType: ListingType.donation,
        images: <ListingImage>[
          ListingImage(
            url: 'https://picsum.photos/500/500/?image=336',
            position: 0,
          )
        ],
      );
}

class UpdateListingActiveStatusRequest {
  final int id;
  final bool isActive;

  UpdateListingActiveStatusRequest(
    this.id,
    this.isActive,
  );

  Map<String, dynamic> toHttpRequestBody() => {'is_active': isActive};

  factory UpdateListingActiveStatusRequest.fake() =>
      UpdateListingActiveStatusRequest(1, true);
}
