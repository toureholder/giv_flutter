import 'package:giv_flutter/features/groups/create_group/bloc/create_group_bloc.dart';
import 'package:giv_flutter/model/group/group.dart';
import 'package:giv_flutter/model/group/repository/api/request/create_group_request.dart';
import 'package:giv_flutter/model/user/user.dart';
import 'package:giv_flutter/util/data/stream_event.dart';
import 'package:giv_flutter/util/network/http_response.dart';
import 'package:mockito/mockito.dart';
import 'package:test/test.dart';

import 'test_util/mocks.dart';

main() {
  CreateGroupBloc bloc;
  MockGroupRepository mockGroupRepository;
  MockGroupHttpResponsePublishSubject mockGroupPublishSubject;
  MockGroupHttpResponseStreamSink mockGroupStreamSink;
  MockDiskStorageProvider mockDiskStorage;
  CreateGroupRequest request;

  setUp(() {
    mockGroupPublishSubject = MockGroupHttpResponsePublishSubject();
    mockGroupStreamSink = MockGroupHttpResponseStreamSink();
    mockDiskStorage = MockDiskStorageProvider();

    when(mockGroupPublishSubject.sink).thenReturn(mockGroupStreamSink);

    mockGroupRepository = MockGroupRepository();
    bloc = CreateGroupBloc(
        groupRepository: mockGroupRepository,
        groupSubject: mockGroupPublishSubject,
        diskStorage: mockDiskStorage);
    request = CreateGroupRequest.fake();
  });

  group('#createGroup', () {
    test('calls repository #createGroup', () {
      // When
      bloc.createGroup(request);

      // Then
      verify(mockGroupRepository.createGroup(request)).called(1);
    });

    test('adds loading http response to sink when #createGroup is called',
        () async {
      // Given
      final group = Group.fake();

      when(mockGroupRepository.createGroup(request)).thenAnswer(
          (_) async => HttpResponse(data: group, status: HttpStatus.created));

      // When
      await bloc.createGroup(request);

      // Then
      final httpResponse =
          verify(mockGroupStreamSink.add(captureAny)).captured.first;

      expect(httpResponse.state, StreamEventState.loading);
    });

    test(
        'adds group http response to sink when repository returns http response with data',
        () async {
      // Given
      final group = Group.fake();

      when(mockGroupRepository.createGroup(request)).thenAnswer(
          (_) async => HttpResponse(data: group, status: HttpStatus.created));

      // When
      await bloc.createGroup(request);

      // Then
      final httpResponse =
          verify(mockGroupStreamSink.add(captureAny)).captured.last;

      expect(httpResponse.status, HttpStatus.created);
      expect(httpResponse.data.id, group.id);
    });

    test(
        'adds group http response to sink when repository returns http response without data',
        () async {
      // Given
      when(mockGroupRepository.createGroup(request)).thenAnswer((_) async =>
          HttpResponse(data: null, status: HttpStatus.unprocessableEntity));

      // When
      await bloc.createGroup(request);

      // Then
      final httpErrorResponse =
          verify(mockGroupStreamSink.add(captureAny)).captured.last;

      expect(httpErrorResponse.status, HttpStatus.unprocessableEntity);
    });

    test('adds error to sink when repository call throws', () async {
      // Given
      final runTimeError = 'Some runtime error';
      when(mockGroupRepository.createGroup(request)).thenThrow(runTimeError);

      // When
      await bloc.createGroup(request);

      // Then
      final error =
          verify(mockGroupStreamSink.addError(captureAny)).captured.last;

      expect(error, isNot(isA<HttpResponse>()));
      expect(error, equals(runTimeError));
    });
  });

  group('handle user authentication', () {
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
    mockGroupPublishSubject.close();
  });
}
