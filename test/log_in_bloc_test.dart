import 'dart:async';

import 'package:giv_flutter/features/log_in/bloc/log_in_bloc.dart';
import 'package:giv_flutter/model/api_response/api_response.dart';
import 'package:giv_flutter/model/user/repository/api/request/log_in_request.dart';
import 'package:giv_flutter/model/user/repository/api/request/log_in_with_provider_request.dart';
import 'package:giv_flutter/model/user/repository/api/request/login_assistance_request.dart';
import 'package:giv_flutter/model/user/repository/api/response/log_in_response.dart';
import 'package:giv_flutter/util/network/http_response.dart';
import 'package:mockito/mockito.dart';
import 'package:rxdart/rxdart.dart';
import 'package:test/test.dart';

import 'test_util/mocks.dart';

class MockLoginHttpResponsePublishSubject extends Mock
    implements PublishSubject<HttpResponse<LogInResponse>> {}

class MockLoginHttpResponseStreamSink extends Mock
    implements StreamSink<HttpResponse<LogInResponse>> {}

main() {
  MockUserRepository mockUserRepository;
  MockSessionProvider mockSessionProvider;
  MockLoginHttpResponsePublishSubject mockLoginHttpResponsePublishSubject;
  MockLoginHttpResponseStreamSink mockLoginHttpResponseStreamSink;
  MockApiHttpResponseSubject mockApiHttpResponsePublishSubject;
  MockApiHttpResponseStreamSink mockApiHttpResponseStreamSink;
  MockFirebaseAuth mockFirebaseAuth;
  MockFacebookLogin mockFacebookLogin;
  MockUtil mockUtil;
  LogInBloc bloc;

  setUp(() {
    mockUserRepository = MockUserRepository();
    mockSessionProvider = MockSessionProvider();
    mockLoginHttpResponsePublishSubject = MockLoginHttpResponsePublishSubject();
    mockLoginHttpResponseStreamSink = MockLoginHttpResponseStreamSink();
    mockApiHttpResponsePublishSubject = MockApiHttpResponseSubject();
    mockApiHttpResponseStreamSink = MockApiHttpResponseStreamSink();
    mockFirebaseAuth = MockFirebaseAuth();
    mockFacebookLogin = MockFacebookLogin();
    mockUtil = MockUtil();

    bloc = LogInBloc(
      util: mockUtil,
      loginAssistancePublishSubject: mockApiHttpResponsePublishSubject,
      firebaseAuth: mockFirebaseAuth,
      loginPublishSubject: mockLoginHttpResponsePublishSubject,
      userRepository: mockUserRepository,
      session: mockSessionProvider,
      facebookLogin: mockFacebookLogin,
    );

    when(mockLoginHttpResponsePublishSubject.sink)
        .thenReturn(mockLoginHttpResponseStreamSink);

    when(mockApiHttpResponsePublishSubject.sink)
        .thenReturn(mockApiHttpResponseStreamSink);

    final apiResponseStream =
        PublishSubject<HttpResponse<ApiResponse>>().stream;
    when(mockApiHttpResponsePublishSubject.stream)
        .thenAnswer((_) => apiResponseStream);

    final loginResponseStream =
        PublishSubject<HttpResponse<LogInResponse>>().stream;
    when(mockLoginHttpResponsePublishSubject.stream)
        .thenAnswer((_) => loginResponseStream);
  });

  test('logs in to facebook', () {
    bloc.loginToFacebook();
    verify(mockFacebookLogin.logInWithReadPermissions(any));
  });

  test('adds loading and data events to sink if login succeeds', () async {
    when(mockUserRepository.login(any))
        .thenAnswer((_) async => HttpResponse<LogInResponse>(
              data: LogInResponse.fake(),
              status: HttpStatus.ok,
            ));

    when(mockSessionProvider.logUserIn(any)).thenAnswer((_) async => [true]);
    when(mockFirebaseAuth.signInWithCustomToken(token: anyNamed('token')))
        .thenAnswer((_) async => null);

    await bloc.login(LogInRequest.fake());

    verify(mockLoginHttpResponseStreamSink.add(any)).called(2);
  });

  test('adds loading and data events to sink if login fails', () async {
    when(mockUserRepository.login(any))
        .thenAnswer((_) async => HttpResponse<LogInResponse>(
              data: null,
              status: HttpStatus.unauthorized,
            ));

    when(mockSessionProvider.logUserIn(any)).thenAnswer((_) async => [true]);
    when(mockFirebaseAuth.signInWithCustomToken(token: anyNamed('token')))
        .thenAnswer((_) async => null);

    await bloc.login(LogInRequest.fake());

    verify(mockLoginHttpResponseStreamSink.add(any)).called(2);
  });

  test('adds error to sink if an exception is thrown during login', () async {
    when(mockLoginHttpResponsePublishSubject.sink).thenReturn(null);

    await bloc.login(LogInRequest.fake());

    verify(mockLoginHttpResponsePublishSubject.addError(any)).called(1);
  });

  test('adds loading and data events to sink if login with provider succeeds',
      () async {
    when(mockUserRepository.loginWithProvider(any))
        .thenAnswer((_) async => HttpResponse<LogInResponse>(
              data: LogInResponse.fake(),
              status: HttpStatus.ok,
            ));

    when(mockSessionProvider.logUserIn(any)).thenAnswer((_) async => [true]);
    when(mockFirebaseAuth.signInWithCustomToken(token: anyNamed('token')))
        .thenAnswer((_) async => null);

    await bloc.loginWithProvider(LogInWithProviderRequest.fake());

    verify(mockLoginHttpResponseStreamSink.add(any)).called(2);
  });

  test('adds loading and data events to sink if login with provider fails',
      () async {
    when(mockUserRepository.loginWithProvider(any))
        .thenAnswer((_) async => HttpResponse<LogInResponse>(
              data: null,
              status: HttpStatus.badRequest,
            ));

    when(mockSessionProvider.logUserIn(any)).thenAnswer((_) async => [true]);
    when(mockFirebaseAuth.signInWithCustomToken(token: anyNamed('token')))
        .thenAnswer((_) async => null);

    await bloc.loginWithProvider(LogInWithProviderRequest.fake());

    verify(mockLoginHttpResponseStreamSink.add(any)).called(2);
  });

  test(
      'adds error to sink if an exception is thrown during login with provider',
      () async {
    when(mockLoginHttpResponsePublishSubject.sink).thenReturn(null);

    await bloc.loginWithProvider(LogInWithProviderRequest.fake());

    verify(mockLoginHttpResponsePublishSubject.addError(any)).called(1);
  });

  test(
      'adds loading and data events to sink if forgot password request succeeds',
      () async {
    when(mockUserRepository.forgotPassword(any)).thenAnswer((_) async =>
        HttpResponse<ApiResponse>(
            data: ApiResponse.fake(), status: HttpStatus.ok));

    await bloc.forgotPassword(LoginAssistanceRequest.fake());
    verify(mockApiHttpResponseStreamSink.add(any)).called(2);
  });

  test(
      'adds error to sink if an exception is thrown during forgot password request',
      () async {
    when(mockApiHttpResponsePublishSubject.sink).thenReturn(null);

    await bloc.forgotPassword(LoginAssistanceRequest.fake());

    verify(mockApiHttpResponsePublishSubject.addError(any)).called(1);
  });

  test(
      'adds loading and data events to sink if resend activaation request succeeds',
      () async {
    when(mockUserRepository.resendActivation(any)).thenAnswer((_) async =>
        HttpResponse<ApiResponse>(
            data: ApiResponse.fake(), status: HttpStatus.ok));

    await bloc.resendActivation(LoginAssistanceRequest.fake());
    verify(mockApiHttpResponseStreamSink.add(any)).called(2);
  });

  test(
      'adds error to sink if an exception is thrown during forgot password request',
      () async {
    when(mockApiHttpResponsePublishSubject.sink).thenReturn(null);

    await bloc.resendActivation(LoginAssistanceRequest.fake());

    verify(mockApiHttpResponsePublishSubject.addError(any)).called(1);
  });

  test('creates user session if login succeeds', () async {
    when(mockUserRepository.loginWithProvider(any))
        .thenAnswer((_) async => HttpResponse<LogInResponse>(
              data: LogInResponse.fake(),
              status: HttpStatus.ok,
            ));

    await bloc.loginWithProvider(LogInWithProviderRequest.fake());

    verify(mockSessionProvider.logUserIn(any)).called(1);
  });

  test('doesn\'t create user session if login fails', () async {
    when(mockUserRepository.loginWithProvider(any))
        .thenAnswer((_) async => HttpResponse<LogInResponse>(
              data: null,
              status: HttpStatus.unauthorized,
            ));

    await bloc.loginWithProvider(LogInWithProviderRequest.fake());

    verifyNever(mockSessionProvider.logUserIn(any));
  });

  test('logs into firebase if login succeeds', () async {
    when(mockUserRepository.loginWithProvider(any))
        .thenAnswer((_) async => HttpResponse<LogInResponse>(
              data: LogInResponse.fake(),
              status: HttpStatus.ok,
            ));

    await bloc.loginWithProvider(LogInWithProviderRequest.fake());

    verify(mockFirebaseAuth.signInWithCustomToken(token: anyNamed('token')))
        .called(1);
  });

  test('doesn\'t log into firebase if login fails', () async {
    when(mockUserRepository.loginWithProvider(any))
        .thenAnswer((_) async => HttpResponse<LogInResponse>(
              data: null,
              status: HttpStatus.badRequest,
            ));

    await bloc.loginWithProvider(LogInWithProviderRequest.fake());

    verifyNever(
        mockFirebaseAuth.signInWithCustomToken(token: anyNamed('token')));
  });

  test('gets contoller streams', () async {
    expect(
      bloc.loginAssistanceStream,
      isA<Stream<HttpResponse<ApiResponse>>>(),
    );
    expect(
      bloc.loginResponseStream,
      isA<Stream<HttpResponse<LogInResponse>>>(),
    );
  });

  test('closes streams', () async {
    await bloc.dispose();
    verify(mockLoginHttpResponsePublishSubject.close()).called(1);
    verify(mockApiHttpResponsePublishSubject.close()).called(1);
  });
}
