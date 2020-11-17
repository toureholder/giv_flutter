import 'dart:convert';

import 'package:flutter_test/flutter_test.dart' as flutter_test;
import 'package:giv_flutter/config/config.dart';
import 'package:giv_flutter/model/group/group.dart';
import 'package:giv_flutter/model/group/repository/api/group_api.dart';
import 'package:giv_flutter/model/group/repository/api/request/add_many_listings_to_group_request.dart';
import 'package:giv_flutter/model/group/repository/api/request/create_group_request.dart';
import 'package:giv_flutter/model/product/product.dart';
import 'package:giv_flutter/util/network/http_client_wrapper.dart';
import 'package:giv_flutter/util/network/http_response.dart';
import 'package:http/http.dart';
import 'package:mockito/mockito.dart';
import 'package:test/test.dart';

import 'test_util/mocks.dart';

main() {
  flutter_test.TestWidgetsFlutterBinding.ensureInitialized();
  GroupApi api;
  HttpClientWrapper httpClientWrapper;
  MockHttp mockHttp;

  group('GroupApi', () {
    setUp(() {
      mockHttp = MockHttp();
      httpClientWrapper =
          HttpClientWrapper(mockHttp, MockDiskStorageProvider());
      api = GroupApi(clientWrapper: httpClientWrapper);
    });

    group('#createGroup', () {
      test('sends create group request', () async {
        // Given
        final request = CreateGroupRequest.fake();

        // When
        await api.createGroup(request);

        // Expect
        final captured = verify(mockHttp.post(captureAny,
                body: captureAnyNamed('body'), headers: anyNamed('headers')))
            .captured;

        final capturedUrl = captured[0];
        final capturedBody = jsonDecode(captured[1]);
        expect(
          capturedUrl,
          '${api.baseUrl}/${GroupApi.GROUPS_ENDPOINT}',
        );
        expect(capturedBody['name'], equals(request.name));
        expect(capturedBody['description'], equals(request.description));
      });

      test('returns a group http response with data when api request succeeds',
          () async {
        // Given
        final groupId = 26;
        final responseBody =
            '{"id":$groupId,"name":"New group","description":"Lorem ipsum dolor sit amet consectetur adipiscing elit sed do eiusmod tempo incididunt ut labore et dolore magna aliqua","image_url":"https://picsum.photos/200","created_at":"2020-08-13T09:03:06.422Z"}';

        when(mockHttp.post('${api.baseUrl}/${GroupApi.GROUPS_ENDPOINT}',
                body: anyNamed('body'), headers: anyNamed('headers')))
            .thenAnswer((_) async => Response(responseBody, 201));

        // When
        final response = await api.createGroup(CreateGroupRequest.fake());

        // Then
        expect(response.data, isA<Group>());
        expect(response.data.id, equals(groupId));
      });

      test('returns a group http response without data when api request throws',
          () async {
        // Given
        final errorMessage = 'some error';
        when(mockHttp.post(any,
                body: anyNamed('body'), headers: anyNamed('headers')))
            .thenThrow(errorMessage);

        // When
        final response = await api.createGroup(CreateGroupRequest.fake());

        // Then
        expect(response.data, isNull);
        expect(response.message, equals(errorMessage));
      });
    });

    group('#editGroup', () {
      int groupId;
      Map<String, dynamic> request;

      setUp(() {
        request = <String, dynamic>{
          'name': 'Wiz Trocas e Gifts',
          'description': 'Lorem ipsum dolor sit amet',
          'image_url': 'https://picsum.photos/200'
        };

        groupId = 18;
      });

      test('sends edit group request', () async {
        // Given

        // When
        await api.editGroup(groupId, request);

        // Then
        final captured = verify(mockHttp.put(captureAny,
                body: captureAnyNamed('body'), headers: anyNamed('headers')))
            .captured;

        final capturedUrl = captured[0];
        final capturedBody = jsonDecode(captured[1]);
        expect(
          capturedUrl,
          '${api.baseUrl}/${GroupApi.GROUPS_ENDPOINT}/$groupId',
        );

        expect(capturedBody['name'], equals(request['name']));
        expect(capturedBody['description'], equals(request['description']));
        expect(capturedBody['image_url'], equals(request['image_url']));
      });

      test('returns a group http response with data when api request succeeds',
          () async {
        // Given
        final responseBody =
            '{"id":$groupId,"name":"New group","description":"Lorem ipsum dolor sit amet consectetur adipiscing elit sed do eiusmod tempo incididunt ut labore et dolore magna aliqua","image_url":"https://picsum.photos/200","created_at":"2020-08-13T09:03:06.422Z"}';

        when(mockHttp.put(captureAny,
                body: captureAnyNamed('body'), headers: anyNamed('headers')))
            .thenAnswer((_) async => Response(responseBody, 201));

        // When
        final response = await api.editGroup(groupId, request);

        // Then
        expect(response.data, isA<Group>());
        expect(response.data.id, equals(groupId));
      });

      test('returns a group http response with data when api request fails',
          () async {
        // Given
        when(mockHttp.put(captureAny,
                body: captureAnyNamed('body'), headers: anyNamed('headers')))
            .thenAnswer((_) async =>
                Response('Tunnel 0e6c7a642f4c.ngrok.io not found', 404));

        // When
        final response = await api.editGroup(groupId, request);

        // Then
        expect(response, isA<HttpResponse>());
        expect(response.data, isNull);
        expect(response.status, HttpStatus.notFound);
      });

      test('returns a group http response without data when api request throws',
          () async {
        // Given
        final errorMessage = 'some error';
        when(mockHttp.put(captureAny,
                body: captureAnyNamed('body'), headers: anyNamed('headers')))
            .thenThrow(errorMessage);

        // When
        final response = await api.editGroup(groupId, request);

        // Then
        expect(response.data, isNull);
        expect(response.message, equals(errorMessage));
      });
    });

    group('#fetchGroupListings', () {
      test('sends get group listings request', () async {
        // Given
        final groupId = 3;
        final page = 1;

        // When
        await api.fetchGroupListings(groupId: groupId, page: page);

        // Then
        final captured =
            verify(mockHttp.get(captureAny, headers: anyNamed('headers')))
                .captured;

        final capturedUrl = captured[0];

        expect(
          capturedUrl,
          startsWith(
            '${api.baseUrl}/${GroupApi.GROUPS_ENDPOINT}/$groupId/${GroupApi.LISTINGS_PATH}',
          ),
        );

        // Adds pararms to request url
        expect(capturedUrl, contains('?'));
        expect(capturedUrl, contains('page=$page'));
        expect(capturedUrl,
            contains('per_page=${Config.paginationDefaultPerPage}'));
      });

      test('returns list of products http response when api call succeeds',
          () async {
        // Given
        final groupOneId = 407;
        final responseBody =
            '[{"id":$groupOneId,"title":"Testing Edited again","description":"lorem ipsum dolor edited","geonames_city_id":"6324222","geonames_state_id":"3463504","geonames_country_id":"3469034","is_active":true,"updated_at":"2020-08-02T02:10:36.479Z","user":{"id":3,"name":"Test User 2","country_calling_code":null,"phone_number":null,"image_url":null,"bio":null,"created_at":"2020-02-21T09:07:55.969Z"},"categories":[{"id":19,"simple_name":"Tamanho GG","canonical_name":"Roupa feminina tamanho GG"},{"id":26,"simple_name":"Infantojuvenil","canonical_name":"Livros infantojuvenis"}],"groups":[{"id":9,"name":"My group","description":"Lorem ipsum dolor sit amet consectetur adipiscing elit sed do eiusmod tempo incididunt ut labore et dolore magna aliqua","image_url":null,"created_at":"2020-08-01T12:25:16.009Z"}],"listing_images":[{"id":1233,"url":"https://picsum.photos/500/500/?image=68","position":1},{"id":1232,"url":"https://picsum.photos/500/500/?image=336","position":0}]}]';
        when(mockHttp.get(any, headers: anyNamed('headers')))
            .thenAnswer((_) async => Response(responseBody, 200));

        // When
        final response = await api.fetchGroupListings(groupId: 1, page: 1);

        // Then
        expect(response, isA<HttpResponse<List<Product>>>());
        expect(response.data[0].id, groupOneId);
        expect(response.status, HttpStatus.ok);
      });

      test('returns a group http response without data when api request throws',
          () async {
        // Given
        final errorMessage = 'some error';
        when(mockHttp.get(any, headers: anyNamed('headers')))
            .thenThrow(errorMessage);

        // When
        final response = await api.fetchGroupListings(groupId: 1, page: 1);

        // Then
        expect(response.data, isNull);
        expect(response.message, equals(errorMessage));
      });
    });

    group('#addManyListingsToGroup', () {
      int groupId;
      AddManyListingsToGroupRequest request;

      setUp(() {
        groupId = 18;
        request = AddManyListingsToGroupRequest(groupId: groupId, ids: [1, 2]);
      });

      test('sends add many listings to group request', () async {
        // When
        await api.addManyListingsToGroup(request);

        // Then
        final captured = verify(
          mockHttp.post(
            captureAny,
            body: captureAnyNamed('body'),
            headers: anyNamed('headers'),
          ),
        ).captured;

        final capturedUrl = captured[0];
        final capturedBody = jsonDecode(captured[1]);
        expect(
          capturedUrl,
          '${api.baseUrl}/${GroupApi.GROUPS_ENDPOINT}/$groupId/${GroupApi.LISTINGS_PATH}/${GroupApi.MANY_PATH}',
        );

        expect(capturedBody['ids'], equals(request.ids));
      });

      test('returns http response', () async {
        when(
          mockHttp.post(
            captureAny,
            body: captureAnyNamed('body'),
            headers: anyNamed('headers'),
          ),
        ).thenAnswer((_) async => Response('', 201));

        // When
        final response = await api.addManyListingsToGroup(request);

        // Then
        expect(response.status, HttpStatus.created);
      });

      test('returns http response when api request throws', () async {
        // Given
        final errorMessage = 'some error';
        when(
          mockHttp.post(
            captureAny,
            body: captureAnyNamed('body'),
            headers: anyNamed('headers'),
          ),
        ).thenThrow(errorMessage);

        // When
        final response = await api.addManyListingsToGroup(request);

        // Then
        expect(response.message, equals(errorMessage));
      });
    });
  });
}
