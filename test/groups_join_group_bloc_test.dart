import 'package:giv_flutter/features/groups/join_group/bloc/join_group_bloc.dart';
import 'package:giv_flutter/model/group_membership/group_membership.dart';
import 'package:giv_flutter/model/group_membership/repository/api/request/join_group_request.dart';
import 'package:giv_flutter/model/user/user.dart';
import 'package:giv_flutter/util/data/stream_event.dart';
import 'package:giv_flutter/util/network/http_response.dart';
import 'package:mockito/mockito.dart';
import 'package:test/test.dart';

import 'test_util/mocks.dart';

main() {
  JoinGroupBloc bloc;
  MockGroupMembershipRepository mockGroupMembershipRepository;
  MockGroupMembershipHttpResponsePublishSubject mockGroupMembershipSubject;
  MockGroupMembershipHttpResponseStreamSink mockGroupMembershipSink;
  MockDiskStorageProvider mockDiskStorage;
  JoinGroupRequest request;

  setUp(() {
    mockGroupMembershipSubject =
        MockGroupMembershipHttpResponsePublishSubject();
    mockGroupMembershipSink = MockGroupMembershipHttpResponseStreamSink();
    mockDiskStorage = MockDiskStorageProvider();

    when(mockGroupMembershipSubject.sink).thenReturn(mockGroupMembershipSink);

    mockGroupMembershipRepository = MockGroupMembershipRepository();
    bloc = JoinGroupBloc(
        groupMembershipRepository: mockGroupMembershipRepository,
        groupMembershipSubject: mockGroupMembershipSubject,
        diskStorage: mockDiskStorage);
    request = JoinGroupRequest.fake();
  });

  group('#joinGroup', () {
    test('calls repository #joinGroup', () {
      // When
      bloc.joinGroup(request);

      // Then
      verify(mockGroupMembershipRepository.joinGroup(request)).called(1);
    });

    test('adds loading http response to sink', () async {
      // Given
      final membership = GroupMembership.fake();

      when(mockGroupMembershipRepository.joinGroup(request)).thenAnswer(
          (_) async =>
              HttpResponse(data: membership, status: HttpStatus.created));

      // When
      await bloc.joinGroup(request);

      // Then
      final httpResponse =
          verify(mockGroupMembershipSink.add(captureAny)).captured.first;

      expect(httpResponse.state, StreamEventState.loading);
    });

    test(
        'adds group membership http response to sink when repository returns http response with data',
        () async {
      // Given
      final membership = GroupMembership.fake();

      when(mockGroupMembershipRepository.joinGroup(request)).thenAnswer(
          (_) async =>
              HttpResponse(data: membership, status: HttpStatus.created));

      // When
      await bloc.joinGroup(request);

      // Then
      final httpResponse =
          verify(mockGroupMembershipSink.add(captureAny)).captured.last;

      expect(httpResponse.status, HttpStatus.created);
    });

    test(
        'adds group membership http response to sink when repository returns http response without data',
        () async {
      // Given
      when(mockGroupMembershipRepository.joinGroup(request)).thenAnswer(
          (_) async => HttpResponse(data: null, status: HttpStatus.conflict));

      // When
      await bloc.joinGroup(request);

      // Then
      final httpErrorResponse =
          verify(mockGroupMembershipSink.add(captureAny)).captured.last;

      expect(httpErrorResponse.status, HttpStatus.conflict);
    });

    test('adds error to sink when repository call throws', () async {
      // Given
      final runTimeError = 'Some runtime error';
      when(mockGroupMembershipRepository.joinGroup(request))
          .thenThrow(runTimeError);

      // When
      await bloc.joinGroup(request);

      // Then
      final error =
          verify(mockGroupMembershipSink.addError(captureAny)).captured.last;

      expect(error, isNot(isA<HttpResponse>()));
      expect(error, equals(runTimeError));
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
    mockGroupMembershipSubject.close();
  });
}
