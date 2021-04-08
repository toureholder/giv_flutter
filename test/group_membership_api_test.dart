import 'dart:convert';
import 'package:flutter_test/flutter_test.dart' as flutter_test;
import 'package:giv_flutter/config/config.dart';
import 'package:giv_flutter/model/group/repository/api/group_api.dart';
import 'package:giv_flutter/model/group_membership/group_membership.dart';
import 'package:giv_flutter/model/group_membership/repository/api/group_membership_api.dart';
import 'package:giv_flutter/model/group_membership/repository/api/request/join_group_request.dart';
import 'package:giv_flutter/util/network/http_client_wrapper.dart';
import 'package:giv_flutter/util/network/http_response.dart';
import 'package:http/http.dart';
import 'package:mockito/mockito.dart';
import 'package:test/test.dart';

import 'test_util/mocks.dart';

main() {
  flutter_test.TestWidgetsFlutterBinding.ensureInitialized();
  GroupMembershipApi api;
  HttpClientWrapper httpClientWrapper;
  MockHttp mockHttp;

  group('GroupMembershipApi', () {
    setUp(() {
      mockHttp = MockHttp();
      httpClientWrapper =
          HttpClientWrapper(mockHttp, MockDiskStorageProvider());
      api = GroupMembershipApi(clientWrapper: httpClientWrapper);
    });

    group('#joinGroup', () {
      test('sends join group request', () async {
        // Given
        final request = JoinGroupRequest.fake();

        // When
        await api.joinGroup(request);

        // Expect
        final captured = verify(mockHttp.post(captureAny,
                body: captureAnyNamed('body'), headers: anyNamed('headers')))
            .captured;

        final Uri capturedUri = captured[0];
        final capturedBody = jsonDecode(captured[1]);
        expect(
          capturedUri.path,
          '/${GroupMembershipApi.MEMBERSHIPS_ENDPOINT}',
        );
        expect(capturedBody['access_token'], equals(request.accessToken));
      });

      test('returns a group membership http response', () async {
        // Given
        final groupId = 1;
        final responseBody =
            '{"id":29,"is_admin":false,"created_at":"2020-08-08T12:13:31.461Z","user":{"id":2,"name":"Test User 1","country_calling_code":null,"phone_number":null,"image_url":null,"bio":null,"created_at":"2020-02-21T09:07:55.911Z"},"group":{"id":$groupId,"name":"New group","description":"Lorem ipsum dolor sit amet consectetur adipiscing elit sed do eiusmod tempo incididunt ut labore et dolore magna aliqua","image_url":"https://picsum.photos/200","access_token":"9C43","created_at":"2020-08-08T12:11:57.658Z"}}';

        when(mockHttp.post(any,
                body: anyNamed('body'), headers: anyNamed('headers')))
            .thenAnswer((_) async => Response(responseBody, 201));

        // When
        final response = await api.joinGroup(JoinGroupRequest.fake());

        // Then
        expect(response.data, isA<GroupMembership>());
        expect(response.data.group.id, flutter_test.equals(groupId));
      });

      test('returns a group http response without data when api request throws',
          () async {
        // Given
        final errorMessage = 'some error';
        when(mockHttp.post(any,
                body: anyNamed('body'), headers: anyNamed('headers')))
            .thenThrow(errorMessage);

        // When
        final response = await api.joinGroup(JoinGroupRequest.fake());

        // Then
        expect(response.data, isNull);
        expect(response.message, equals(errorMessage));
      });
    });

    group('#getMyMemberships', () {
      test('sends get my memberships request', () async {
        // When
        await api.getMyMemberships();

        // Then
        final captured = verify(
          mockHttp.get(
            captureAny,
            headers: anyNamed('headers'),
          ),
        ).captured;

        final Uri capturedUri = captured[0];
        expect(
          capturedUri.path,
          '/${GroupMembershipApi.MY_MEMBERSHIPS_ENDPOINT}',
        );
      });

      test('returns http response with data when api request succeeds',
          () async {
        // Given
        final membershipOneId = 1;
        final membershipTwoId = 2;
        final groupOneId = 3;
        final groupTwoId = 4;
        final userOneId = 5;
        final userTwoId = 6;
        final responseBody =
            '[{"id":$membershipOneId,"is_admin":true,"created_at":"2020-08-14T09:40:45.056Z","user":{"id":$userOneId,"name":"Test User 1","country_calling_code":null,"phone_number":null,"image_url":null,"bio":null,"created_at":"2020-02-21T09:07:55.911Z"},"group":{"id":$groupOneId,"name":"Wat","description":null,"image_url":null,"access_token":"B935","created_at":"2020-08-14T09:40:45.044Z"}},{"id":$membershipTwoId,"is_admin":true,"created_at":"2020-08-14T09:39:18.428Z","user":{"id":$userTwoId,"name":"Test User 1","country_calling_code":null,"phone_number":null,"image_url":null,"bio":null,"created_at":"2020-02-21T09:07:55.911Z"},"group":{"id":$groupTwoId,"name":"Wat","description":null,"image_url":null,"access_token":"7EE7","created_at":"2020-08-14T09:39:18.375Z"}}]';

        when(mockHttp.get(
          captureAny,
          headers: anyNamed('headers'),
        )).thenAnswer((_) async => Response(responseBody, 200));

        // When
        final response = await api.getMyMemberships();

        // Then
        final memberships = response.data;
        expect(memberships[0].id, membershipOneId);
        expect(memberships[0].group.id, groupOneId);
        expect(memberships[0].user.id, userOneId);
        expect(memberships[1].id, membershipTwoId);
        expect(memberships[1].group.id, groupTwoId);
        expect(memberships[1].user.id, userTwoId);
        expect(response.status, HttpStatus.ok);
      });

      test(
          'returns http response without data when api response with error code',
          () async {
        // Given
        when(mockHttp.get(
          captureAny,
          headers: anyNamed('headers'),
        )).thenAnswer((_) async =>
            Response('Tunnel 0e6c7a642f4c.ngrok.io not found', 404));

        // When
        final response = await api.getMyMemberships();

        // Then
        expect(response.status, HttpStatus.notFound);
      });

      test('returns http response without data when api request throws',
          () async {
        // Given

        final errorMessage = 'some error';
        when(mockHttp.get(
          captureAny,
          headers: anyNamed('headers'),
        )).thenThrow(errorMessage);

        // When
        final response = await api.getMyMemberships();

        // Then
        expect(response.data, isNull);
        expect(response.message, equals(errorMessage));
      });
    });

    group('#getGroupMemberships', () {
      int groupId;

      setUp(() {
        groupId = 1;
      });

      test('sends get group memberships request', () async {
        // Given
        final page = 1;

        // When
        await api.fetchGroupMemberships(groupId: groupId, page: page);

        // Then
        final captured = verify(
          mockHttp.get(
            captureAny,
            headers: anyNamed('headers'),
          ),
        ).captured;

        final Uri capturedUri = captured[0];
        expect(capturedUri.path,
            '/${GroupApi.GROUPS_ENDPOINT}/$groupId/${GroupMembershipApi.GROUP_MEMBERSHIPS_PATH}');

        // Adds pararms to request url
        expect(capturedUri.query, contains('page=$page'));
        expect(capturedUri.query,
            contains('per_page=${Config.paginationDefaultPerPage}'));
      });

      test('returns http response with data when api request succeeds',
          () async {
        // Given
        final membershipOneId = 1;
        final membershipTwoId = 2;
        final groupOneId = 3;
        final groupTwoId = 4;
        final userOneId = 5;
        final userTwoId = 6;
        final responseBody =
            '[{"id":$membershipOneId,"is_admin":true,"created_at":"2020-08-14T09:40:45.056Z","user":{"id":$userOneId,"name":"Test User 1","country_calling_code":null,"phone_number":null,"image_url":null,"bio":null,"created_at":"2020-02-21T09:07:55.911Z"},"group":{"id":$groupOneId,"name":"Wat","description":null,"image_url":null,"access_token":"B935","created_at":"2020-08-14T09:40:45.044Z"}},{"id":$membershipTwoId,"is_admin":true,"created_at":"2020-08-14T09:39:18.428Z","user":{"id":$userTwoId,"name":"Test User 1","country_calling_code":null,"phone_number":null,"image_url":null,"bio":null,"created_at":"2020-02-21T09:07:55.911Z"},"group":{"id":$groupTwoId,"name":"Wat","description":null,"image_url":null,"access_token":"7EE7","created_at":"2020-08-14T09:39:18.375Z"}}]';

        when(mockHttp.get(
          captureAny,
          headers: anyNamed('headers'),
        )).thenAnswer((_) async => Response(responseBody, 200));

        // When
        final response = await api.getMyMemberships();

        // Then
        final memberships = response.data;
        expect(memberships[0].id, membershipOneId);
        expect(memberships[0].group.id, groupOneId);
        expect(memberships[0].user.id, userOneId);
        expect(memberships[1].id, membershipTwoId);
        expect(memberships[1].group.id, groupTwoId);
        expect(memberships[1].user.id, userTwoId);
        expect(response.status, HttpStatus.ok);
      });

      test(
          'returns http response without data when api response with error code',
          () async {
        // Given
        when(mockHttp.get(
          captureAny,
          headers: anyNamed('headers'),
        )).thenAnswer((_) async =>
            Response('Tunnel 0e6c7a642f4c.ngrok.io not found', 404));

        // When
        final response = await api.fetchGroupMemberships(groupId: groupId);

        // Then
        expect(response.status, HttpStatus.notFound);
      });

      test('returns http response without data when api request throws',
          () async {
        // Given

        final errorMessage = 'some error';
        when(mockHttp.get(
          captureAny,
          headers: anyNamed('headers'),
        )).thenThrow(errorMessage);

        // When
        final response = await api.fetchGroupMemberships(groupId: groupId);

        // Then
        expect(response.data, isNull);
        expect(response.message, equals(errorMessage));
      });
    });

    group('#leaveGroup', () {
      test('sends leave group request', () async {
        // Given
        final membershipId = 51;

        // When
        await api.leaveGroup(membershipId: membershipId);

        // Then
        final captured =
            verify(mockHttp.delete(captureAny, headers: anyNamed('headers')))
                .captured;

        final Uri capturedUri = captured[0];

        expect(
          capturedUri.path,
          '/${GroupMembershipApi.MEMBERSHIPS_ENDPOINT}/$membershipId',
        );
      });

      test('returns a group membership http response', () async {
        // Given
        final token = '1234';
        final responseBody =
            '{"id":29,"is_admin":false,"created_at":"2020-08-08T12:13:31.461Z","user":{"id":2,"name":"Test User 1","country_calling_code":null,"phone_number":null,"image_url":null,"bio":null,"created_at":"2020-02-21T09:07:55.911Z"},"group":{"id":1,"name":"New group","description":"Lorem ipsum dolor sit amet consectetur adipiscing elit sed do eiusmod tempo incididunt ut labore et dolore magna aliqua","image_url":"https://picsum.photos/200","access_token":"$token","created_at":"2020-08-08T12:11:57.658Z"}}';

        when(mockHttp.delete(any, headers: anyNamed('headers')))
            .thenAnswer((_) async => Response(responseBody, 200));

        // When
        final response = await api.leaveGroup(membershipId: 1);

        // Then
        expect(response.data, isA<GroupMembership>());
        expect(response.status, HttpStatus.ok);
        expect(response.data.group.accessToken, flutter_test.equals(token));
      });

      test(
          'returns a group http membership response without data when api request throws',
          () async {
        // Given
        final errorMessage = 'some error';

        when(mockHttp.delete(any, headers: anyNamed('headers')))
            .thenThrow(errorMessage);

        // When
        final response = await api.leaveGroup(membershipId: 1);

        // Then
        expect(response.data, isNull);
        expect(response.message, equals(errorMessage));
      });
    });
  });
}
