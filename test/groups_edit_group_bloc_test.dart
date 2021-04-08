import 'dart:async';

import 'package:firebase_storage/firebase_storage.dart';
import 'package:giv_flutter/features/groups/edit_group/bloc/edit_group_bloc.dart';
import 'package:giv_flutter/model/group/group.dart';
import 'package:giv_flutter/model/user/user.dart';
import 'package:giv_flutter/util/data/stream_event.dart';
import 'package:giv_flutter/util/network/http_response.dart';
import 'package:mockito/mockito.dart';
import 'package:test/test.dart';

import 'test_util/mocks.dart';

main() {
  EditGroupBloc bloc;
  MockGroupRepository mockGroupRepository;
  MockGroupHttpResponsePublishSubject mockGroupPublishSubject;
  MockGroupHttpResponseStreamSink mockGroupStreamSink;
  MockDiskStorageProvider mockDiskStorage;
  MockFirebaseStorageUtilProvider mockFirebaseStorageUtil;
  MockUtil mockUtil;
  MockGroupUpdatedAction mockGroupUpdatedAction;

  setUp(() {
    mockGroupPublishSubject = MockGroupHttpResponsePublishSubject();
    mockGroupStreamSink = MockGroupHttpResponseStreamSink();
    mockDiskStorage = MockDiskStorageProvider();
    mockFirebaseStorageUtil = MockFirebaseStorageUtilProvider();
    mockUtil = MockUtil();
    mockGroupUpdatedAction = MockGroupUpdatedAction();

    when(mockGroupPublishSubject.sink).thenReturn(mockGroupStreamSink);

    mockGroupRepository = MockGroupRepository();

    bloc = EditGroupBloc(
      groupRepository: mockGroupRepository,
      groupSubject: mockGroupPublishSubject,
      diskStorage: mockDiskStorage,
      firebaseStorageUtil: mockFirebaseStorageUtil,
      util: mockUtil,
      groupUpdatedAction: mockGroupUpdatedAction,
      imagePicker: MockImagePicker(),
    );
  });

  group('#getGroupById', () {
    test('gets group from repo', () {
      // Given
      final groupId = 1;
      final fakeGroup = Group.fake(id: groupId, name: 'My fake fake group');
      when(mockGroupRepository.getGroupById(groupId)).thenReturn(fakeGroup);

      // When
      final response = bloc.getGroupById(groupId);

      // Then
      expect(response.id, fakeGroup.id);
      expect(response.name, fakeGroup.name);
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

    test('calls repository #editGroup', () {
      // When
      bloc.editGroup(groupId, request);

      // Then
      verify(mockGroupRepository.editGroup(groupId, request)).called(1);
    });

    test('adds loading http response to sink when #createGroup is called',
        () async {
      // Given
      final group = Group.fake();

      when(mockGroupRepository.editGroup(groupId, request)).thenAnswer(
          (_) async => HttpResponse(data: group, status: HttpStatus.ok));

      // When
      await bloc.editGroup(groupId, request);

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

      when(mockGroupRepository.editGroup(groupId, request)).thenAnswer(
        (_) async => HttpResponse(data: group, status: HttpStatus.ok),
      );

      // When
      await bloc.editGroup(groupId, request);

      // Then
      final httpResponse =
          verify(mockGroupStreamSink.add(captureAny)).captured.last;

      expect(httpResponse.status, HttpStatus.ok);
      expect(httpResponse.data.id, group.id);
    });

    test(
        'calls group updated change notifier when repository returns http response with data',
        () async {
      // Given
      final group = Group.fake();

      when(mockGroupRepository.editGroup(groupId, request)).thenAnswer(
        (_) async => HttpResponse(data: group, status: HttpStatus.ok),
      );

      // When
      await bloc.editGroup(groupId, request);

      // Then
      final updatedGroup =
          verify(mockGroupUpdatedAction.setGroup(captureAny)).captured.first;

      expect(updatedGroup, group);
    });

    test(
        'adds group http response to sink when repository returns http response without data',
        () async {
      // Given
      when(mockGroupRepository.editGroup(groupId, request)).thenAnswer(
        (_) async => HttpResponse(
          data: null,
          status: HttpStatus.unprocessableEntity,
        ),
      );

      // When
      await bloc.editGroup(groupId, request);

      // Then
      final httpErrorResponse =
          verify(mockGroupStreamSink.add(captureAny)).captured.last;

      expect(httpErrorResponse.status, HttpStatus.unprocessableEntity);
    });

    test('adds error to sink when repository call throws', () async {
      // Given
      final runTimeError = 'Some runtime error';
      when(mockGroupRepository.editGroup(groupId, request))
          .thenThrow(runTimeError);

      // When
      await bloc.editGroup(groupId, request);

      // Then
      final error =
          verify(mockGroupStreamSink.addError(captureAny)).captured.last;

      expect(error, isNot(isA<HttpResponse>()));
      expect(error, equals(runTimeError));
    });
  });

  group('#uploadImage', () {
    int groupId;
    MockFile mockFile;
    MockStorageReference mockStorageReference;
    MockStorageUploadTask mockUploadTask;
    StreamController<TaskSnapshot> storageTaskSnapshotController;

    setUp(() {
      groupId = 18;
      mockFile = MockFile();
      mockStorageReference = MockStorageReference();
      mockUploadTask = MockStorageUploadTask();
      storageTaskSnapshotController = StreamController<TaskSnapshot>();

      when(mockFirebaseStorageUtil.getGroupImageRef(groupId))
          .thenReturn(mockStorageReference);

      when(mockStorageReference.putFile(mockFile))
          .thenAnswer((_) => mockUploadTask);

      when(mockUploadTask.snapshotEvents)
          .thenAnswer((_) => storageTaskSnapshotController.stream);
    });

    tearDown(() {
      storageTaskSnapshotController.close();
    });

    test('adds loading state to edit group stream', () {
      bloc.uploadImage(groupId, mockFile);

      // Then
      final httpResponse =
          verify(mockGroupStreamSink.add(captureAny)).captured.first;

      expect(httpResponse.state, StreamEventState.loading);
    });

    test('gets firebase storage reference', () {
      // When
      bloc.uploadImage(groupId, mockFile);

      // Then
      verify(mockFirebaseStorageUtil.getGroupImageRef(groupId)).called(1);
    });

    test('firebase storage reference puts file', () {
      // When
      bloc.uploadImage(groupId, mockFile);

      // Then
      verify(mockStorageReference.putFile(mockFile)).called(1);
    });
  });

  group('handles user authentication', () {
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
