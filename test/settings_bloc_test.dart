import 'dart:async';

import 'package:flutter/material.dart';
import 'package:giv_flutter/features/settings/bloc/settings_bloc.dart';
import 'package:giv_flutter/model/user/user.dart';
import 'package:giv_flutter/util/data/stream_event.dart';
import 'package:giv_flutter/util/network/http_response.dart';
import 'package:mockito/mockito.dart';
import 'package:rxdart/rxdart.dart';
import 'package:test/test.dart';

import 'test_util/mocks.dart';

class MockUserHttpResponseSubject extends Mock
    implements PublishSubject<HttpResponse<User>> {}

class MockUserHttpResponseStreamSink extends Mock
    implements StreamSink<HttpResponse<User>> {}

main() {
  MockUserHttpResponseSubject mockUserHttpResponseSubject;
  MockUserHttpResponseStreamSink mockUserHttpResponseStreamSink;
  MockUserRepository mockUserRepository;
  MockDiskStorageProvider mockDiskStorageProvider;
  MockSessionProvider mockSessionProvider;
  MockFirebaseStorageUtilProvider mockFirebaseStorageUtilProvider;
  MockUtil mockUtil;
  MockAuthUserUpdatedAction mockAuthUserUpdatedAction;

  SettingsBloc bloc;

  setUp(() {
    mockUserHttpResponseSubject = MockUserHttpResponseSubject();
    mockUserHttpResponseStreamSink = MockUserHttpResponseStreamSink();
    mockUserRepository = MockUserRepository();
    mockDiskStorageProvider = MockDiskStorageProvider();
    mockSessionProvider = MockSessionProvider();
    mockFirebaseStorageUtilProvider = MockFirebaseStorageUtilProvider();
    mockUtil = MockUtil();
    mockAuthUserUpdatedAction = MockAuthUserUpdatedAction();

    bloc = SettingsBloc(
      userRepository: mockUserRepository,
      diskStorage: mockDiskStorageProvider,
      session: mockSessionProvider,
      userUpdatePublishSubject: mockUserHttpResponseSubject,
      firebaseStorageUtil: mockFirebaseStorageUtilProvider,
      util: mockUtil,
      authUserUpdatedAction: mockAuthUserUpdatedAction,
      platform: TargetPlatform.android,
    );

    when(mockUserHttpResponseSubject.stream)
        .thenAnswer((_) => PublishSubject<HttpResponse<User>>().stream);

    when(mockUserHttpResponseSubject.sink)
        .thenReturn(mockUserHttpResponseStreamSink);
  });

  tearDown(() {
    mockUserHttpResponseSubject.close();
  });

  group('exposes platform', () {
    test('android', () {
      expect(bloc.platform, TargetPlatform.android);
    });

    test('ios', () {
      bloc = SettingsBloc(
        userRepository: mockUserRepository,
        diskStorage: mockDiskStorageProvider,
        session: mockSessionProvider,
        userUpdatePublishSubject: mockUserHttpResponseSubject,
        firebaseStorageUtil: mockFirebaseStorageUtilProvider,
        util: mockUtil,
        authUserUpdatedAction: mockAuthUserUpdatedAction,
        platform: TargetPlatform.iOS,
      );

      expect(bloc.platform, TargetPlatform.iOS);
    });
  });

  test('gets user from disk storage', () {
    when(mockDiskStorageProvider.getUser()).thenReturn(User.fake());
    expect(bloc.getUser(), isA<User>());
  });

  test('gets profile photo ref user from firebase storage util', () {
    bloc.getProfilePhotoRef();
    verify(mockFirebaseStorageUtilProvider.getProfilePhotoRef()).called(1);
  });

  test('opens whatsapp', () {
    final number = '+987654321';
    final message = 'Howdy';
    bloc.openWhatsApp(number, message);
    verify(mockUtil.openWhatsApp(number, message)).called(1);
  });

  test('logs user out from session', () {
    bloc.logout();
    verify(mockSessionProvider.logUserOut()).called(1);
  });

  group('updates user', () {
    test('adds loading state to sink', () async {
      await bloc.updateUser(<String, dynamic>{'attribute': 'value'});

      verify(mockUserRepository.updateMe(any)).called(1);

      final loading =
          verify(mockUserHttpResponseStreamSink.add(captureAny)).captured.first;

      expect(loading.state, StreamEventState.loading);
    });

    test('adds data to sink when repository call succeeds', () async {
      when(mockUserRepository.updateMe(any))
          .thenAnswer((_) async => HttpResponse<User>(
                status: HttpStatus.ok,
                data: User.fake(),
              ));

      await bloc.updateUser(<String, dynamic>{'attribute': 'value'});

      verify(mockUserRepository.updateMe(any)).called(1);

      final response =
          verify(mockUserHttpResponseStreamSink.add(captureAny)).captured.last;

      expect(response.status, HttpStatus.ok);
    });

    test('calls auth user update change notifier when repository call succeeds',
        () async {
      when(mockUserRepository.updateMe(any))
          .thenAnswer((_) async => HttpResponse<User>(
                status: HttpStatus.ok,
                data: User.fake(),
              ));

      await bloc.updateUser(<String, dynamic>{'attribute': 'value'});

      verify(mockUserRepository.updateMe(any)).called(1);

      verify(mockAuthUserUpdatedAction.notify()).called(1);
    });

    test('saves user to disk storage when repository call succeeds', () async {
      when(mockUserRepository.updateMe(any))
          .thenAnswer((_) async => HttpResponse<User>(
                status: HttpStatus.ok,
                data: User.fake(),
              ));

      await bloc.updateUser(<String, dynamic>{'attribute': 'value'});

      verify(mockDiskStorageProvider.setUser(any)).called(1);
    });

    test('doesn\'t save user to disk storage when repository call fails',
        () async {
      when(mockUserRepository.updateMe(any))
          .thenAnswer((_) async => HttpResponse<User>(
                status: HttpStatus.unauthorized,
                data: null,
              ));

      await bloc.updateUser(<String, dynamic>{'attribute': 'value'});

      verifyNever(mockDiskStorageProvider.setUser(any));
    });

    test('adds error to sink if exception is thrown', () async {
      bloc = SettingsBloc(
        userRepository: null,
        diskStorage: mockDiskStorageProvider,
        session: mockSessionProvider,
        userUpdatePublishSubject: mockUserHttpResponseSubject,
        firebaseStorageUtil: mockFirebaseStorageUtilProvider,
        util: mockUtil,
        authUserUpdatedAction: mockAuthUserUpdatedAction,
        platform: TargetPlatform.iOS,
      );

      await bloc.updateUser(<String, dynamic>{'attribute': 'value'});
      verify(mockUserHttpResponseStreamSink.addError(any)).called(1);
    });
  });

  group('manages streams', () {
    test('exposes streams', () async {
      expect(bloc.userUpdateStream, isA<Stream<HttpResponse<User>>>());
    });

    test('closes streams', () async {
      await bloc.dispose();
      verify(mockUserHttpResponseSubject.close()).called(1);
    });
  });
}
