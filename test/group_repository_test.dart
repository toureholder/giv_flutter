import 'package:giv_flutter/model/group/group.dart';
import 'package:giv_flutter/model/group/repository/api/request/add_many_listings_to_group_request.dart';
import 'package:giv_flutter/model/group/repository/api/request/create_group_request.dart';
import 'package:giv_flutter/model/group/repository/group_repository.dart';
import 'package:giv_flutter/model/group_membership/group_membership.dart';
import 'package:giv_flutter/model/product/product.dart';
import 'package:giv_flutter/util/network/http_response.dart';
import 'package:mockito/mockito.dart';
import 'package:test/test.dart';

import 'test_util/mocks.dart';

main() {
  group('GroupRepository', () {
    GroupRepository repository;
    MockGroupApi mockApi;
    MockGroupsBox mockBox;
    MockGroupMembershipsBox mockGroupMembershipsBox;

    setUp(() {
      mockApi = MockGroupApi();
      mockBox = MockGroupsBox();
      mockGroupMembershipsBox = MockGroupMembershipsBox();
      repository = GroupRepository(
        api: mockApi,
        box: mockBox,
        membershipsBox: mockGroupMembershipsBox,
      );
    });

    group('#getGroupById', () {
      test('gets group from box', () {
        // Given
        final groupId = 1;
        final fakeGroup = Group.fake(id: groupId, name: 'My fake fake group');
        when(mockBox.get(groupId)).thenReturn(fakeGroup);

        // When
        final response = repository.getGroupById(groupId);

        // Then
        expect(response.id, fakeGroup.id);
        expect(response.name, fakeGroup.name);
      });
    });

    group('#createGroup', () {
      test('calls api', () async {
        // Given
        final request = CreateGroupRequest.fake();

        // When
        await repository.createGroup(request);

        // Then
        verify(mockApi.createGroup(request)).called(1);
      });

      test('returns a group membership http response', () async {
        // Given
        final request = CreateGroupRequest.fake();
        final apiReturn =
            HttpResponse(data: Group.fake(), status: HttpStatus.created);

        when(mockApi.createGroup(request)).thenAnswer((_) async => apiReturn);

        // When
        final response = await repository.createGroup(request);

        // Then
        expect(response, isA<HttpResponse<Group>>());
        expect(response.data.id, equals(Group.fake().id));
      });
    });

    group('#editGroup', () {
      int groupId;
      Map<String, dynamic> request;
      List<GroupMembership> fakeMemberships;

      setUp(() {
        request = <String, dynamic>{
          'name': 'Wiz Trocas e Gifts',
          'description': 'Lorem ipsum dolor sit amet',
          'image_url': 'https://picsum.photos/200'
        };

        groupId = 18;

        fakeMemberships = GroupMembership.fakeList(
          containingGroupsWithIds: [groupId],
        );

        when(mockGroupMembershipsBox.values).thenReturn(
          fakeMemberships,
        );
      });

      test('calls api', () async {
        // Given
        final apiReturn =
            HttpResponse(data: Group.fake(), status: HttpStatus.created);

        when(mockApi.editGroup(groupId, request))
            .thenAnswer((_) async => apiReturn);

        // When
        await repository.editGroup(groupId, request);

        // Then
        verify(mockApi.editGroup(groupId, request)).called(1);
      });

      test('returns a group membership http response', () async {
        // Given
        final apiReturn =
            HttpResponse(data: Group.fake(), status: HttpStatus.created);

        when(mockApi.editGroup(groupId, request))
            .thenAnswer((_) async => apiReturn);

        // When
        final response = await repository.editGroup(groupId, request);

        // Then
        expect(response, isA<HttpResponse<Group>>());
        expect(response.data.id, equals(Group.fake().id));
      });

      test('updates group in box', () async {
        // Given
        final group = Group.fake();
        final apiReturn = HttpResponse(data: group, status: HttpStatus.created);

        when(mockApi.editGroup(groupId, request))
            .thenAnswer((_) async => apiReturn);

        // When
        final response = await repository.editGroup(groupId, request);

        // Then
        verify(mockBox.put(response.data.id, response.data));
      });

      test('updates group memberships in box', () async {
        // Given
        final group = Group.fake(id: groupId);
        final apiReturn = HttpResponse(data: group, status: HttpStatus.created);

        when(mockApi.editGroup(groupId, request))
            .thenAnswer((_) async => apiReturn);

        // When
        await repository.editGroup(groupId, request);

        // Then
        final captured =
            verify(mockGroupMembershipsBox.putAll(captureAny)).captured;

        expect(captured[0][fakeMemberships.first.id], isNotNull);
      });
    });

    group('#getGroupListings', () {
      test('calls api', () async {
        // Given
        final groupId = 1;
        final page = 1;

        // When
        await repository.getGroupListings(groupId: groupId, page: page);

        // Then
        verify(mockApi.fetchGroupListings(groupId: groupId, page: page))
            .called(1);
      });

      test('returns a product list http response', () async {
        // Given
        final groupId = 1;
        final page = 1;

        final apiReturn = HttpResponse(
          data: Product.fakeList(),
          status: HttpStatus.ok,
        );

        when(mockApi.fetchGroupListings(
          groupId: groupId,
          page: page,
        )).thenAnswer((_) async => apiReturn);

        // When
        final response = await repository.getGroupListings(
          groupId: groupId,
          page: page,
        );

        // Then
        expect(response, isA<HttpResponse<List<Product>>>());
        expect(response.data[0].id, equals(Product.fakeList()[0].id));
      });
    });

    group('#addManyListingsToGroup', () {
      test('calls api', () async {
        // Given
        final request = AddManyListingsToGroupRequest.fake();

        // When
        await repository.addManyListingsToGroup(request);

        // Then
        verify(mockApi.addManyListingsToGroup(request)).called(1);
      });
    });
  });
}
