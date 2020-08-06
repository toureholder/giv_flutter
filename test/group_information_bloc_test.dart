import 'package:giv_flutter/features/groups/group_information/bloc/group_information_bloc.dart';
import 'package:giv_flutter/model/group/group.dart';
import 'package:giv_flutter/model/group_membership/group_membership.dart';
import 'package:giv_flutter/model/user/user.dart';
import 'package:giv_flutter/util/network/http_response.dart';
import 'package:mockito/mockito.dart';
import 'package:test/test.dart';

import 'test_util/mocks.dart';

main() {
  GroupInformationBloc bloc;
  MockGroupMembershipRepository mockRepository;
  MockGroupMembershipListPublishSubject mockSubject;
  MockGroupMembershipListStreamSink mockStreamSink;
  MockDiskStorageProvider mockDiskStorage;
  MockUtil mockUtil;

  setUp(() {
    mockSubject = MockGroupMembershipListPublishSubject();
    mockStreamSink = MockGroupMembershipListStreamSink();
    mockDiskStorage = MockDiskStorageProvider();
    mockUtil = MockUtil();

    when(mockSubject.sink).thenReturn(mockStreamSink);

    mockRepository = MockGroupMembershipRepository();
    bloc = GroupInformationBloc(
      memberhipsRepository: mockRepository,
      loadMembershipsSubject: mockSubject,
      diskStorage: mockDiskStorage,
      util: mockUtil,
    );
  });

  group('#getGroupMemberships', () {
    int groupId;
    int page;

    setUp(() {
      groupId = 1;
      page = 1;
    });

    test('calls repository #getMyMemberships', () {
      // When
      bloc.getGroupMemberships(
        groupId: groupId,
        page: page,
      );

      // Then
      verify(mockRepository.getGroupMemberships(
        groupId: groupId,
        page: page,
      )).called(1);
    });

    test(
        'adds group membership list to sink when repository returns http response with data',
        () async {
      final memberships = GroupMembership.fakeList();

      when(mockRepository.getGroupMemberships(groupId: groupId)).thenAnswer(
          (_) async => HttpResponse(data: memberships, status: HttpStatus.ok));

      // When
      await bloc.getGroupMemberships(groupId: groupId);

      // Then
      final returnedMemberships =
          verify(mockStreamSink.add(captureAny)).captured.last;

      expect(returnedMemberships[0].id, memberships[0].id);
    });

    test(
        'adds error to sink when repository returns http response without data',
        () async {
      // Given
      when(mockRepository.getGroupMemberships(groupId: groupId)).thenAnswer(
          (_) async => HttpResponse(data: null, status: HttpStatus.notFound));

      // When
      await bloc.getGroupMemberships(groupId: groupId);

      // Then
      verify(mockStreamSink.addError(any)).called(1);
    });

    test('adds error to sink when repository call throws', () async {
      // Given
      final runTimeError = 'Some runtime error';
      when(mockRepository.getGroupMemberships(groupId: groupId))
          .thenThrow(runTimeError);

      // When
      await bloc.getGroupMemberships(groupId: groupId);

      // Then
      final error = verify(mockStreamSink.addError(captureAny)).captured.last;

      expect(error, isNot(isA<HttpResponse>()));
      expect(error, equals(runTimeError));
    });
  });

  group('#getMembershipById', () {
    test('gets membership from repository', () {
      // Given
      final membershipId = 1;
      final fakeMembership = GroupMembership.fake(id: membershipId);
      when(mockRepository.getMembershipById(membershipId))
          .thenReturn(fakeMembership);

      // When
      final membership = bloc.getMembershipById(membershipId);

      // Then
      expect(membership.id, fakeMembership.id);
      expect(membership.group.id, fakeMembership.group.id);
      expect(membership.user.id, fakeMembership.user.id);
    });
  });

  group('#getUser', () {
    test('gets user from disk storage', () {
      // Given
      final fakeUser = User.fake();
      when(mockDiskStorage.getUser()).thenReturn(fakeUser);

      // When
      final authenticatedUser = bloc.getUser();

      // Then
      expect(authenticatedUser.id, fakeUser.id);
    });
  });

  group('#shareGroup', () {
    test('calls util.shareGroup', () async {
      // Given
      final group = Group.fake();
      final context = MockBuildContext();

      // When
      await bloc.shareGroup(context, group);

      // Then
      verify(mockUtil.shareGroup(context, group)).called(1);
    });
  });

  tearDown(() {
    mockSubject.close();
  });
}
