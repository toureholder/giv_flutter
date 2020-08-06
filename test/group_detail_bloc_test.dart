import 'package:giv_flutter/features/groups/group_detail/bloc/group_detail_bloc.dart';
import 'package:giv_flutter/model/group/group.dart';
import 'package:giv_flutter/model/group_membership/group_membership.dart';
import 'package:giv_flutter/model/product/product.dart';
import 'package:giv_flutter/model/user/user.dart';
import 'package:giv_flutter/util/data/stream_event.dart';
import 'package:giv_flutter/util/network/http_response.dart';
import 'package:mockito/mockito.dart';
import 'package:test/test.dart';

import 'test_util/mocks.dart';

main() {
  GroupDetailBloc bloc;
  MockGroupRepository mockGroupRepository;
  MockGroupMembershipRepository mockGroupMembershipRepository;
  MockProductListPublishSubject mockProductsSubject;
  MockGroupMembershipHttpResponsePublishSubject mockLeaveGroupSubject;
  MockGroupMembershipHttpResponseStreamSink mockLeaveGroupSink;
  MockProductListStreamSink mockProductsSink;
  MockDiskStorageProvider mockDiskStorage;
  int membershipIdToDestroy;
  MockUtil mockUtil;

  setUp(() {
    mockProductsSubject = MockProductListPublishSubject();
    mockLeaveGroupSubject = MockGroupMembershipHttpResponsePublishSubject();
    mockLeaveGroupSink = MockGroupMembershipHttpResponseStreamSink();
    mockProductsSink = MockProductListStreamSink();
    mockDiskStorage = MockDiskStorageProvider();
    mockUtil = MockUtil();

    when(mockProductsSubject.sink).thenReturn(mockProductsSink);
    when(mockLeaveGroupSubject.sink).thenReturn(mockLeaveGroupSink);

    mockGroupRepository = MockGroupRepository();
    mockGroupMembershipRepository = MockGroupMembershipRepository();

    bloc = GroupDetailBloc(
      groupRepository: mockGroupRepository,
      groupMembershipRepository: mockGroupMembershipRepository,
      productsSubject: mockProductsSubject,
      leaveGroupSubject: mockLeaveGroupSubject,
      diskStorage: mockDiskStorage,
      util: mockUtil,
    );

    membershipIdToDestroy = 1;
  });

  group('#getGroupListings', () {
    test('calls repository #getGroupListings', () {
      // Given
      final groupId = 1;
      final page = 1;

      when(
        mockGroupRepository.getGroupListings(
          groupId: anyNamed('groupId'),
          page: anyNamed('page'),
        ),
      ).thenAnswer(
        (_) async => HttpResponse(
          data: null,
          status: HttpStatus.notFound,
        ),
      );

      // When
      bloc.getGroupListings(
        groupId: groupId,
        page: page,
      );

      // Then
      verify(mockGroupRepository.getGroupListings(
        groupId: groupId,
        page: page,
      )).called(1);
    });

    test(
        'adds product list to sink when repository returns http response with data',
        () async {
      // Given
      final products = Product.fakeList();

      when(
        mockGroupRepository.getGroupListings(
          groupId: anyNamed('groupId'),
          page: anyNamed('page'),
        ),
      ).thenAnswer(
        (_) async => HttpResponse(
          data: products,
          status: HttpStatus.ok,
        ),
      );

      // When
      await bloc.getGroupListings(groupId: 1, page: 1);

      // Then
      final returnedProducts =
          verify(mockProductsSink.add(captureAny)).captured.last;

      expect(returnedProducts[0].id, products[0].id);
    });

    test(
        'adds error to sink when repository returns http response without data',
        () async {
      // Given
      when(
        mockGroupRepository.getGroupListings(
          groupId: anyNamed('groupId'),
          page: anyNamed('page'),
        ),
      ).thenAnswer(
        (_) async => HttpResponse(
          data: null,
          status: HttpStatus.notFound,
        ),
      );

      // When
      await bloc.getGroupListings(groupId: 1, page: 1);

      // Then
      verify(mockProductsSink.addError(any)).called(1);
    });

    test('adds error to sink when repository call throws', () async {
      // Given
      final runTimeError = 'Some runtime error';
      when(
        mockGroupRepository.getGroupListings(
          groupId: anyNamed('groupId'),
          page: anyNamed('page'),
        ),
      ).thenThrow(runTimeError);

      // When
      await bloc.getGroupListings(groupId: 1, page: 1);

      // Then
      final error = verify(mockProductsSink.addError(captureAny)).captured.last;

      expect(error, isNot(isA<HttpResponse>()));
      expect(error, equals(runTimeError));
    });
  });

  group('#getMembershipById', () {
    test('gets membership from repository', () {
      // Given
      final membershipId = 1;
      final fakeMembership = GroupMembership.fake(id: membershipId);
      when(mockGroupMembershipRepository.getMembershipById(membershipId))
          .thenReturn(fakeMembership);

      // When
      final membership = bloc.getMembershipById(membershipId);

      // Then
      expect(membership.id, fakeMembership.id);
      expect(membership.group.id, fakeMembership.group.id);
      expect(membership.user.id, fakeMembership.user.id);
    });
  });

  group('#leaveGroup', () {
    test('calls repository #leaveGroup', () {
      // When
      bloc.leaveGroup(membershipId: membershipIdToDestroy);

      // Then
      verify(mockGroupMembershipRepository.leaveGroup(
        membershipId: membershipIdToDestroy,
      )).called(1);
    });

    test('adds loading http response to sink', () async {
      // Given
      final membership = GroupMembership.fake();

      when(mockGroupMembershipRepository.leaveGroup(
        membershipId: membershipIdToDestroy,
      )).thenAnswer(
          (_) async => HttpResponse(data: membership, status: HttpStatus.ok));

      // When
      await bloc.leaveGroup(membershipId: membershipIdToDestroy);

      // Then
      final httpResponse =
          verify(mockLeaveGroupSink.add(captureAny)).captured.first;

      expect(httpResponse.state, StreamEventState.loading);
    });

    test(
        'adds group membership http response to sink when repository returns http response with data',
        () async {
      // Given
      final membership = GroupMembership.fake();

      when(mockGroupMembershipRepository.leaveGroup(
        membershipId: membershipIdToDestroy,
      )).thenAnswer((_) async => HttpResponse<GroupMembership>(
            data: membership,
            status: HttpStatus.ok,
          ));

      // When
      await bloc.leaveGroup(membershipId: membershipIdToDestroy);

      // Then
      final httpResponse =
          verify(mockLeaveGroupSink.add(captureAny)).captured.last;

      expect(httpResponse.status, HttpStatus.ok);
      expect(httpResponse.data.group.accessToken, membership.group.accessToken);
    });

    test(
        'adds group membership http response to sink when repository returns http response without data',
        () async {
      // Given
      when(mockGroupMembershipRepository.leaveGroup(
        membershipId: membershipIdToDestroy,
      )).thenAnswer((_) async => HttpResponse<GroupMembership>(
            data: null,
            status: HttpStatus.badRequest,
          ));

      // When
      await bloc.leaveGroup(membershipId: membershipIdToDestroy);

      // Then
      final httpResponse =
          verify(mockLeaveGroupSink.add(captureAny)).captured.last;

      expect(httpResponse.status, HttpStatus.badRequest);
      expect(httpResponse.data, isNull);
    });

    test('adds error to sink when repository call throws', () async {
      // Given
      final runTimeError = 'Some runtime error';
      when(mockGroupMembershipRepository.leaveGroup(
        membershipId: membershipIdToDestroy,
      )).thenThrow(runTimeError);

      // When
      await bloc.leaveGroup(membershipId: membershipIdToDestroy);

      // Then
      final error =
          verify(mockLeaveGroupSink.addError(captureAny)).captured.last;

      expect(error, isNot(isA<HttpResponse>()));
      expect(error, equals(runTimeError));
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

  tearDown(() {
    mockProductsSubject.close();
    mockLeaveGroupSubject.close();
  });
}
