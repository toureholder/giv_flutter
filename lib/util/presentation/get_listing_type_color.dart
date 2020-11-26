import 'package:flutter/material.dart';
import 'package:giv_flutter/model/listing/listing_type.dart';

Color getListingTypeColor(ThemeData themeData, ListingType type) {
  final listingTypeColorMap = <ListingType, Color>{
    ListingType.donation: themeData.primaryColor,
    ListingType.donationRequest: themeData.accentColor,
  };

  return listingTypeColorMap[type];
}
