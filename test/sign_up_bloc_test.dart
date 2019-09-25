import 'package:giv_flutter/features/sign_up/bloc/sign_up_bloc.dart';
import 'package:giv_flutter/model/api_response/api_response.dart';
import 'package:giv_flutter/model/user/repository/api/request/sign_up_request.dart';
import 'package:giv_flutter/util/network/http_response.dart';
import 'package:mockito/mockito.dart';
import 'package:rxdart/rxdart.dart';
import 'package:test/test.dart';

import 'test_util/mocks.dart';

main() {
  MockUserRepository mockUserRepository;
  MockApiHttpResponseSubject mockApiHttpResponsePublishSubject;
  MockApiHttpResponseStreamSink mockApiHttpResponseStreamSink;
  SignUpBloc bloc;

  setUp(() {
    mockUserRepository = MockUserRepository();
    mockApiHttpResponsePublishSubject = MockApiHttpResponseSubject();
    mockApiHttpResponseStreamSink = MockApiHttpResponseStreamSink();
    bloc = SignUpBloc(
      responsePublishSubject: mockApiHttpResponsePublishSubject,
      userRepository: mockUserRepository,
    );

    when(mockApiHttpResponsePublishSubject.sink)
        .thenReturn(mockApiHttpResponseStreamSink);

    final stream = PublishSubject<HttpResponse<ApiResponse>>().stream;

    when(mockApiHttpResponsePublishSubject.stream).thenAnswer((_) => stream);
  });

  tearDown(() {
    mockApiHttpResponsePublishSubject.close();
  });

  test('adds loading and data events to sink if sign up succeeds', () async {
    when(mockUserRepository.signUp(any))
        .thenAnswer((_) async => HttpResponse<ApiResponse>(
              data: ApiResponse.fake(),
              status: HttpStatus.created,
            ));

    await bloc.signUp(SignUpRequest.fake());

    verify(mockApiHttpResponseStreamSink.add(any)).called(2);
  });

  test('adds error to sink if an exception is thrown during login', () async {
    when(mockApiHttpResponsePublishSubject.sink).thenReturn(null);

    await bloc.signUp(SignUpRequest.fake());

    verify(mockApiHttpResponsePublishSubject.addError(any)).called(1);
  });

  test('gets contoller stream', () async {
    expect(bloc.responseStream, isA<Stream<HttpResponse<ApiResponse>>>());
  });

  test('closes stream', () async {
    await bloc.dispose();
    verify(mockApiHttpResponsePublishSubject.close()).called(1);
  });
}
