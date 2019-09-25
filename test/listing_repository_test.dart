import 'package:giv_flutter/model/listing/repository/api/request/create_listing_request.dart';
import 'package:giv_flutter/model/listing/repository/listing_repository.dart';
import 'package:mockito/mockito.dart';
import 'package:test/test.dart';

import 'test_util/mocks.dart';

void main() {
  ListingRepository listingRepository;
  MockListingApi mockListingApi;
  final createRequest = CreateListingRequest.fake();
  final updateActiveStatusRequest = UpdateListingActiveStatusRequest(1, true);

  setUp(() {
    mockListingApi = MockListingApi();
    listingRepository = ListingRepository(listingApi: mockListingApi);
  });

  tearDown(() {
    reset(mockListingApi);
  });

  test('calls api create', () async {
    await listingRepository.create(createRequest);
    verify(mockListingApi.create(createRequest));
  });

  test('calls api update', () async {
    await listingRepository.update(createRequest);
    verify(mockListingApi.update(createRequest));
  });

  test('calls api update active status', () async {
    await listingRepository.updateActiveStatus(updateActiveStatusRequest);
    verify(mockListingApi.updateActiveStatus(updateActiveStatusRequest));
  });

  test('calls api destroy', () async {
    await listingRepository.destroy(1);
    verify(mockListingApi.destroy(1));
  });
}
