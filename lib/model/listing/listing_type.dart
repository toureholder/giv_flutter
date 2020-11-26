enum ListingType { donation, donationRequest }

final listingTypeToStringMap = <ListingType, String>{
  ListingType.donation: 'donation',
  ListingType.donationRequest: 'donation_request',
};

ListingType getListingTypeByString(String value) {
  final map = listingTypeToStringMap;

  return map.keys.firstWhere(
    (key) => map[key] == value,
    orElse: () => null,
  );
}
