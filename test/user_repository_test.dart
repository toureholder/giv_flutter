import 'package:giv_flutter/model/user/repository/api/request/log_in_request.dart';
import 'package:giv_flutter/model/user/repository/api/request/log_in_with_provider_request.dart';
import 'package:giv_flutter/model/user/repository/api/request/login_assistance_request.dart';
import 'package:giv_flutter/model/user/repository/api/request/sign_up_request.dart';
import 'package:giv_flutter/model/user/repository/user_repository.dart';
import 'package:mockito/mockito.dart';
import 'package:test/test.dart';

import 'test_util/mocks.dart';

main () {
  MockUserApi mockUserApi;
  UserRepository userRepository;

  setUp((){
    mockUserApi = MockUserApi();
    userRepository = UserRepository(userApi: mockUserApi);
  });

  tearDown((){
    reset(mockUserApi);
  });

  test('calls api sign up', (){
    userRepository.signUp(SignUpRequest.fake());
    verify(mockUserApi.signUp(any)).called(1);
  });

  test('calls api log in', (){
    userRepository.login(LogInRequest.fake());
    verify(mockUserApi.login(any)).called(1);
  });

  test('calls api log in with provider', (){
    userRepository.loginWithProvider(LogInWithProviderRequest.fake());
    verify(mockUserApi.loginWithProvider(any)).called(1);
  });

  test('calls api get me', (){
    userRepository.getMe();
    verify(mockUserApi.getMe()).called(1);
  });

  test('calls api update me', (){
    userRepository.updateMe({});
    verify(mockUserApi.updateMe(any)).called(1);
  });

  test('calls api forgot password', (){
    userRepository.forgotPassword(LoginAssistanceRequest.fake());
    verify(mockUserApi.forgotPassword(any)).called(1);
  });

  test('calls api resend activation', (){
    userRepository.resendActivation(LoginAssistanceRequest.fake());
    verify(mockUserApi.resendActivation(any)).called(1);
  });
}