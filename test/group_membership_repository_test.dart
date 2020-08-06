import 'package:giv_flutter/model/group/group.dart';
import 'package:giv_flutter/model/group_membership/group_membership.dart';
import 'package:giv_flutter/model/group_membership/repository/api/request/join_group_request.dart';
import 'package:giv_flutter/model/group_membership/repository/group_membership_repository.dart';
import 'package:giv_flutter/util/network/http_response.dart';
import 'package:mockito/mockito.dart';
import 'package:test/test.dart';

import 'test_util/mocks.dart';

main() {
  group('GroupMembershipRepository', () {
    GroupMembershipRepository repository;
    MockGroupMembershipApi mockApi;
    MockGroupMembershipsBox mockBox;
    MockGroupsBox mockGroupsBox;

    setUp(() {
      mockApi = MockGroupMembershipApi();
      mockBox = MockGroupMembershipsBox();
      mockGroupsBox = MockGroupsBox();
      repository = GroupMembershipRepository(
        api: mockApi,
        box: mockBox,
        groupsBox: mockGroupsBox,
      );
    });

    group('#getMyMemberships', () {
      group('tryCache == true', () {
        group('box has values', () {
          final groupIds = [12, 23, 45, 67, 89];

          setUp(() {
            when(mockBox.values).thenReturn(
                GroupMembership.fakeList(containingGroupsWithIds: groupIds));
          });

          test('does not call api', () async {
            // When
            await repository.getMyMemberships();

            // Then
            verifyNever(mockApi.getMyMemberships());
          });

          test('returns a group memberships list http response', () async {
            // When
            final response = await repository.getMyMemberships();

            // Then
            expect(response, isA<HttpResponse<List<GroupMembership>>>());

            expect(
              response.data
                  .where((element) => groupIds.contains(element.group.id))
                  .length,
              groupIds.length,
            );
          });
        });

        group('box is empty', () {
          setUp(() {
            when(mockBox.values).thenReturn([]);
          });

          test('calls api', () async {
            // When
            await repository.getMyMemberships();

            // Then
            verify(mockApi.getMyMemberships()).called(1);
          });

          test('returns a group memberships list http response', () async {
            // Given
            final apiReturn = HttpResponse(
                data: GroupMembership.fakeList(), status: HttpStatus.ok);

            when(mockApi.getMyMemberships()).thenAnswer((_) async => apiReturn);

            // When
            final response = await repository.getMyMemberships();

            // Then
            expect(response, isA<HttpResponse<List<GroupMembership>>>());
            expect(
                response.data[0].id, equals(GroupMembership.fakeList()[0].id));
          });
        });
      });

      group('tryCache == false', () {
        final groupIds = [12, 23, 45, 67, 89];

        setUp(() {
          when(mockBox.values).thenReturn(
              GroupMembership.fakeList(containingGroupsWithIds: groupIds));
        });

        test('calls api even if box has values', () async {
          // When
          await repository.getMyMemberships(tryCache: false);

          // Then
          verify(mockApi.getMyMemberships()).called(1);
        });

        test('returns a group memberships list http response', () async {
          // Given
          final apiReturn = HttpResponse(
              data: GroupMembership.fakeList(), status: HttpStatus.ok);

          when(mockApi.getMyMemberships()).thenAnswer((_) async => apiReturn);

          // When
          final response = await repository.getMyMemberships(tryCache: false);

          // Then
          expect(response, isA<HttpResponse<List<GroupMembership>>>());
          expect(response.data[0].id, equals(GroupMembership.fakeList()[0].id));
        });

        test('puts group memberships in box', () async {
          // Given
          final apiReturn = HttpResponse(
              data: GroupMembership.fakeList(), status: HttpStatus.ok);

          when(mockApi.getMyMemberships()).thenAnswer((_) async => apiReturn);

          // When
          final response = await repository.getMyMemberships(tryCache: false);

          // Then
          final memberships = response.data;
          final entries = GroupMembership.listToMap(memberships);
          verify(mockBox.putAll(entries));
        });

        test('puts groups in box', () async {
          // Given
          final apiReturn = HttpResponse(
              data: GroupMembership.fakeList(), status: HttpStatus.ok);

          when(mockApi.getMyMemberships()).thenAnswer((_) async => apiReturn);

          // When
          final response = await repository.getMyMemberships(tryCache: false);

          // Then
          final memberships = response.data;
          final groups = memberships.map((it) => it.group).toList();
          final entries = Group.listToMap(groups);
          verify(mockGroupsBox.putAll(entries));
        });
      });
    });

    group('#getMembershipById', () {
      test('gets membership from box', () {
        // Given
        final membershipId = 1;
        final fakeMembership = GroupMembership.fake(id: membershipId);
        when(mockBox.get(membershipId)).thenReturn(fakeMembership);

        // When
        final response = repository.getMembershipById(membershipId);

        // Then
        expect(response.id, fakeMembership.id);
        expect(response.group.id, fakeMembership.group.id);
        expect(response.user.id, fakeMembership.user.id);
      });
    });

    group('#getGroupMemberships', () {
      int groupId;
      int page;

      setUp(() {
        groupId = 1;
        page = 1;
      });

      test('calls api', () async {
        // When
        await repository.getGroupMemberships(groupId: groupId, page: page);

        // Then
        verify(mockApi.fetchGroupMemberships(groupId: groupId, page: page))
            .called(1);
      });

      test('returns a group memberships list http response', () async {
        // Given
        final apiReturn = HttpResponse(
            data: GroupMembership.fakeList(), status: HttpStatus.ok);

        when(mockApi.fetchGroupMemberships(groupId: groupId))
            .thenAnswer((_) async => apiReturn);

        // When
        final response = await repository.getGroupMemberships(groupId: groupId);

        // Then
        expect(response, isA<HttpResponse<List<GroupMembership>>>());
        expect(response.data[0].id, equals(GroupMembership.fakeList()[0].id));
      });
    });

    group('#joinGroup', () {
      test('calls api', () async {
        // Given
        final request = JoinGroupRequest(accessToken: 'whatever');

        // When
        await repository.joinGroup(request);

        // Then
        verify(mockApi.joinGroup(request)).called(1);
      });

      test('returns a group membership http response', () async {
        // Given
        final request = JoinGroupRequest(accessToken: 'whatever');
        final apiReturn = HttpResponse(
            data: GroupMembership.fake(), status: HttpStatus.created);

        when(mockApi.joinGroup(request)).thenAnswer((_) async => apiReturn);

        // When
        final response = await repository.joinGroup(request);

        // Then
        expect(response, isA<HttpResponse<GroupMembership>>());
        expect(response.data.id, equals(GroupMembership.fake().id));
      });
    });

    group('#leaveGroup', () {
      test('calls api', () async {
        // Given
        final membershipId = 1;

        // When
        await repository.leaveGroup(membershipId: membershipId);

        // Then
        verify(mockApi.leaveGroup(membershipId: membershipId)).called(1);
      });

      test('returns a group membership http response', () async {
        // Given
        final membershipId = 1;
        final apiReturn =
            HttpResponse(data: GroupMembership.fake(), status: HttpStatus.ok);

        when(mockApi.leaveGroup(membershipId: membershipId))
            .thenAnswer((_) async => apiReturn);

        // When
        final response =
            await repository.leaveGroup(membershipId: membershipId);

        // Then
        expect(response, isA<HttpResponse<GroupMembership>>());
        expect(response.status, HttpStatus.ok);
        expect(response.data.group.accessToken,
            equals(GroupMembership.fake().group.accessToken));
      });
    });
  });
}
