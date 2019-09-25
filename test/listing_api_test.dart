import 'package:giv_flutter/model/api_response/api_response.dart';
import 'package:giv_flutter/model/listing/repository/api/listing_api.dart';
import 'package:giv_flutter/model/listing/repository/api/request/create_listing_request.dart';
import 'package:giv_flutter/model/product/product.dart';
import 'package:giv_flutter/util/network/http_client_wrapper.dart';
import 'package:giv_flutter/util/network/http_response.dart';
import 'package:http/http.dart';
import 'package:mockito/mockito.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:test/test.dart';

import 'test_util/mocks.dart';

void main() {
  SharedPreferences.setMockInitialValues({});
  HttpClientWrapper client;
  MockHttp mockHttp;
  ListingApi listingApi;
  final listingResponseBody =
      '{"id":55,"title":"Testing","description":"lorem ipsum dolor","geonames_city_id":"123","geonames_state_id":"456","geonames_country_id":"789","is_active":true,"updated_at":"2019-09-26T15:48:54.532Z","user":{"id":1,"name":"Test User","country_calling_code":"55","phone_number":"61981178515","image_url":"https://firebasestorage.googleapis.com/v0/b/givapp-938de.appspot.com/o/dev%2Fusers%2F1%2Fphotos%2F1569400230645.jpg?alt=media&token=5f7cdb23-1f6d-4e10-bd30-9df04265522e","bio":null,"created_at":"2019-03-25T02:39:26.452Z"},"categories":[{"id":19,"simple_name":"Tamanho GG","canonical_name":"Roupa feminina tamanho GG"},{"id":26,"simple_name":"Infantojuvenil","canonical_name":"Livros infantojuvenis"}],"listing_images":[{"id":228,"url":"https://picsum.photos/500/500/?image=336","position":0},{"id":229,"url":"https://picsum.photos/500/500/?image=68","position":1},{"id":230,"url":"https://picsum.photos/500/500/?image=175","position":2}]}';

  final createListingRequest = CreateListingRequest.fake();
  final updateListingActiveStatusRequest = UpdateListingActiveStatusRequest(
    1,
    true,
  );

  setUp(() {
    mockHttp = MockHttp();
    client = HttpClientWrapper(mockHttp, MockDiskStorageProvider());
    listingApi = ListingApi(client: client);
  });

  tearDown(() {
    reset(mockHttp);
  });

  test('returns Product data if the create request succeeds', () async {
    when(client.http
            .post(any, body: anyNamed('body'), headers: anyNamed('headers')))
        .thenAnswer((_) async => Response(listingResponseBody, 201));

    final response = await listingApi.create(createListingRequest);

    expect(response.data, isA<Product>());
    expect(response.status, HttpStatus.created);
  });

  test('returns null data if create request fails', () async {
    final responseBody =
        '{"message":"Validation failed: Title can\'t be blank"}';

    when(client.http
            .post(any, body: anyNamed('body'), headers: anyNamed('headers')))
        .thenAnswer((_) async => Response(responseBody, 422));

    final response = await listingApi.create(createListingRequest);

    expect(response.data, isA<void>());
    expect(response.status, HttpStatus.unprocessableEntity);
  });

  test('returns Product data if the update request succeeds', () async {
    when(client.http
            .put(any, body: anyNamed('body'), headers: anyNamed('headers')))
        .thenAnswer((_) async => Response(listingResponseBody, 200));

    final response = await listingApi.update(createListingRequest);

    expect(response.data, isA<Product>());
    expect(response.status, HttpStatus.ok);
  });

  test('returns null data if update request fails', () async {
    final responseBody = '{"message":"Listing not found"}';

    when(client.http
            .put(any, body: anyNamed('body'), headers: anyNamed('headers')))
        .thenAnswer((_) async => Response(responseBody, 404));

    final response = await listingApi.update(createListingRequest);

    expect(response.data, isA<void>());
    expect(response.status, HttpStatus.notFound);
  });

  test('returns Product data if the update active status request succeeds',
      () async {
    when(client.http
            .put(any, body: anyNamed('body'), headers: anyNamed('headers')))
        .thenAnswer((_) async => Response(listingResponseBody, 200));

    final response =
        await listingApi.updateActiveStatus(updateListingActiveStatusRequest);

    expect(response.data, isA<Product>());
    expect(response.status, HttpStatus.ok);
  });

  test('returns null data if update active status equest fails', () async {
    final responseBody = '{"message":"Couldn\'t find Listing"}';

    when(client.http
            .put(any, body: anyNamed('body'), headers: anyNamed('headers')))
        .thenAnswer((_) async => Response(responseBody, 404));

    final response =
        await listingApi.updateActiveStatus(updateListingActiveStatusRequest);

    expect(response.data, isA<void>());
    expect(response.status, HttpStatus.notFound);
  });

  test('returns ApiModelResponse data if the delete request succeeds', () async {
    when(client.http.delete(any, headers: anyNamed('headers')))
        .thenAnswer((_) async => Response(listingResponseBody, 200));

    final response = await listingApi.destroy(1);

    expect(response.data, isA<ApiModelResponse>());
    expect(response.status, HttpStatus.ok);
  });

  test('returns null data if delete fails', () async {
    final responseBody = '{"message":"Couldn\'t find Listing"}';

    when(client.http.delete(any, headers: anyNamed('headers')))
        .thenAnswer((_) async => Response(responseBody, 404));

    final response = await listingApi.destroy(1);

    expect(response.data, isA<void>());
    expect(response.status, HttpStatus.notFound);
  });
}
