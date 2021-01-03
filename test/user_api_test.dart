import 'package:flutter_test/flutter_test.dart' as flutter_test;
import 'package:giv_flutter/model/api_response/api_response.dart';
import 'package:giv_flutter/model/user/repository/api/request/log_in_request.dart';
import 'package:giv_flutter/model/user/repository/api/request/log_in_with_provider_request.dart';
import 'package:giv_flutter/model/user/repository/api/request/login_assistance_request.dart';
import 'package:giv_flutter/model/user/repository/api/request/sign_up_request.dart';
import 'package:giv_flutter/model/user/repository/api/response/log_in_response.dart';
import 'package:giv_flutter/model/user/repository/api/user_api.dart';
import 'package:giv_flutter/model/user/user.dart';
import 'package:giv_flutter/util/network/http_client_wrapper.dart';
import 'package:giv_flutter/util/network/http_response.dart';
import 'package:http/http.dart';
import 'package:mockito/mockito.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:test/test.dart';

import 'test_util/mocks.dart';

void main() {
  flutter_test.TestWidgetsFlutterBinding.ensureInitialized();
  SharedPreferences.setMockInitialValues({});
  HttpClientWrapper client;
  MockHttp mockHttp;
  UserApi userApi;

  setUp(() {
    mockHttp = MockHttp();
    client = HttpClientWrapper(mockHttp, MockDiskStorageProvider());
    userApi = UserApi(client: client);
  });

  tearDown(() {
    reset(mockHttp);
  });

  test('returns api response data if sign up request succeeds', () async {
    final responseBody = '{"message":"Account created successfully"}';

    when(client.http
            .post(any, body: anyNamed('body'), headers: anyNamed('headers')))
        .thenAnswer((_) async => Response(responseBody, 201));

    final response = await userApi.signUp(SignUpRequest.fake());

    expect(response.data, isA<ApiResponse>());
    expect(response.status, HttpStatus.created);
  });

  test('returns null data if sign up request fails', () async {
    final responseBody = '{"message":"Validation failed"}';

    when(client.http
            .post(any, body: anyNamed('body'), headers: anyNamed('headers')))
        .thenAnswer((_) async => Response(responseBody, 422));

    final response = await userApi.signUp(SignUpRequest.fake());

    expect(response.data, isA<void>());
    expect(response.status, HttpStatus.unprocessableEntity);
  });

  test('returns login response data if log in request succeeds', () async {
    final responseBody =
        '{"firebse_auth_token":"eyJhbGciOiJSUzI1NiJ9.eyJpc3MiOiJmaXJlYmFzZS1hZG1pbnNkay1id3BsZkBnaXZhcHAtOTM4ZGUuaWFtLmdzZXJ2aWNlYWNjb3VudC5jb20iLCJzdWIiOiJmaXJlYmFzZS1hZG1pbnNkay1id3BsZkBnaXZhcHAtOTM4ZGUuaWFtLmdzZXJ2aWNlYWNjb3VudC5jb20iLCJhdWQiOiJodHRwczovL2lkZW50aXR5dG9vbGtpdC5nb29nbGVhcGlzLmNvbS9nb29nbGUuaWRlbnRpdHkuaWRlbnRpdHl0b29sa2l0LnYxLklkZW50aXR5VG9vbGtpdCIsImlhdCI6MTU2OTg1MDM2NiwiZXhwIjoxNTY5ODUzOTY2LCJ1aWQiOiIxIn0.o0by5v5meiIBx23Cv1jGlAtJKoEZxsNwpEIU6TPpwH38bU008mmrrevEk8lVjFFAZdv7ni9vfJe4D27vNIZv_dYiOorK9U-KvxWyyMewlPOQDmFK8qcLF-4LC8XdD2fzMUttS_GbC552ybIGRrNzo1qBbfGvCuAS_BnBz4gkoaNnwB2ZX8AxCFr78_Tq4Zae8eCvVNpb_Lu1EpluZj5pjMSVCbIhYfLFb_4dIk-sfcNl_4KqvygB9lLzh8CR5rI7N24Ne9OfdAwxEIp_yCMBy2C-lv8f47SucO4XPp0szdwNymZ8xuDZ7cHI68bO_huA-8X_TpNMR7jiYGUF_OR2HQ","long_lived_token":"eyJhbGciOiJSUzI1NiJ9.eyJ1c2VyX2lkIjoxfQ.ASzeai9eq83itNqL4CDvKq94UiHgs57xxTfig-5d3wR_b94U1w6Zl0iB6geAwpa8bDvTheympJ_PAc0Q45cuqDqCLlpdzKGX2v4YkNb-At4pkM-gf9KZBDLQqKzTir1--wO-Av6trSCr0CJ4CmeB-p-tRnm02wJC9VakHmjdyLkewC3dksnGnXBHJNxu1fimqeJaXBE3yHiBDrGzzngw6JhTE0grtvSw0nFU90cX5MHEYUbyU-tI-9BXnBhhwzjMyHyUMrZu-dgjpbRtQD_8--45ZYmsGWEB8Tkhe2OcawrbDH3bBkq5FF04ah6GLt8L4RYeekQbK9Ffzx2wRkwIsA","user":{"id":1,"name":"Test User","country_calling_code":"55","phone_number":"61981178515","image_url":"https://firebasestorage.googleapis.com/v0/b/givapp-938de.appspot.com/o/dev%2Fusers%2F1%2Fphotos%2F1569400230645.jpg?alt=media&token=5f7cdb23-1f6d-4e10-bd30-9df04265522e","bio":null,"admin":true,"created_at":"2019-03-25T02:39:26.452Z"}}';

    when(client.http
            .post(any, body: anyNamed('body'), headers: anyNamed('headers')))
        .thenAnswer((_) async => Response(responseBody, 200));

    final response = await userApi.login(LogInRequest.fake());

    expect(response.data, isA<LogInResponse>());
    expect(response.status, HttpStatus.ok);
  });

  test('returns null data if log in request fails', () async {
    final responseBody = '{"message":"Invalid credentials"}';

    when(client.http
            .post(any, body: anyNamed('body'), headers: anyNamed('headers')))
        .thenAnswer((_) async => Response(responseBody, 422));

    final response = await userApi.login(LogInRequest.fake());

    expect(response.data, isA<void>());
    expect(response.status, HttpStatus.unprocessableEntity);
  });

  test('returns login response data if log in with provider request succeeds',
      () async {
    final responseBody =
        '{"firebse_auth_token":"eyJhbGciOiJSUzI1NiJ9.eyJpc3MiOiJmaXJlYmFzZS1hZG1pbnNkay1id3BsZkBnaXZhcHAtOTM4ZGUuaWFtLmdzZXJ2aWNlYWNjb3VudC5jb20iLCJzdWIiOiJmaXJlYmFzZS1hZG1pbnNkay1id3BsZkBnaXZhcHAtOTM4ZGUuaWFtLmdzZXJ2aWNlYWNjb3VudC5jb20iLCJhdWQiOiJodHRwczovL2lkZW50aXR5dG9vbGtpdC5nb29nbGVhcGlzLmNvbS9nb29nbGUuaWRlbnRpdHkuaWRlbnRpdHl0b29sa2l0LnYxLklkZW50aXR5VG9vbGtpdCIsImlhdCI6MTU2OTg1MDM2NiwiZXhwIjoxNTY5ODUzOTY2LCJ1aWQiOiIxIn0.o0by5v5meiIBx23Cv1jGlAtJKoEZxsNwpEIU6TPpwH38bU008mmrrevEk8lVjFFAZdv7ni9vfJe4D27vNIZv_dYiOorK9U-KvxWyyMewlPOQDmFK8qcLF-4LC8XdD2fzMUttS_GbC552ybIGRrNzo1qBbfGvCuAS_BnBz4gkoaNnwB2ZX8AxCFr78_Tq4Zae8eCvVNpb_Lu1EpluZj5pjMSVCbIhYfLFb_4dIk-sfcNl_4KqvygB9lLzh8CR5rI7N24Ne9OfdAwxEIp_yCMBy2C-lv8f47SucO4XPp0szdwNymZ8xuDZ7cHI68bO_huA-8X_TpNMR7jiYGUF_OR2HQ","long_lived_token":"eyJhbGciOiJSUzI1NiJ9.eyJ1c2VyX2lkIjoxfQ.ASzeai9eq83itNqL4CDvKq94UiHgs57xxTfig-5d3wR_b94U1w6Zl0iB6geAwpa8bDvTheympJ_PAc0Q45cuqDqCLlpdzKGX2v4YkNb-At4pkM-gf9KZBDLQqKzTir1--wO-Av6trSCr0CJ4CmeB-p-tRnm02wJC9VakHmjdyLkewC3dksnGnXBHJNxu1fimqeJaXBE3yHiBDrGzzngw6JhTE0grtvSw0nFU90cX5MHEYUbyU-tI-9BXnBhhwzjMyHyUMrZu-dgjpbRtQD_8--45ZYmsGWEB8Tkhe2OcawrbDH3bBkq5FF04ah6GLt8L4RYeekQbK9Ffzx2wRkwIsA","user":{"id":1,"name":"Test User","country_calling_code":"55","phone_number":"61981178515","image_url":"https://firebasestorage.googleapis.com/v0/b/givapp-938de.appspot.com/o/dev%2Fusers%2F1%2Fphotos%2F1569400230645.jpg?alt=media&token=5f7cdb23-1f6d-4e10-bd30-9df04265522e","bio":null,"admin":true,"created_at":"2019-03-25T02:39:26.452Z"}}';

    when(client.http
            .post(any, body: anyNamed('body'), headers: anyNamed('headers')))
        .thenAnswer((_) async => Response(responseBody, 200));

    final response =
        await userApi.loginWithProvider(LogInWithProviderRequest.fake());

    expect(response.data, isA<LogInResponse>());
    expect(response.status, HttpStatus.ok);
  });

  test('returns null data if log in with provider request fails', () async {
    final responseBody = '{"message":"Invalid credentials"}';

    when(client.http
            .post(any, body: anyNamed('body'), headers: anyNamed('headers')))
        .thenAnswer((_) async => Response(responseBody, 422));

    final response =
        await userApi.loginWithProvider(LogInWithProviderRequest.fake());

    expect(response.data, isA<void>());
    expect(response.status, HttpStatus.unprocessableEntity);
  });

  test('returns api response data if forgot password request succeeds',
      () async {
    final responseBody = '{"message":"Password reset email sent"}';

    when(client.http
            .post(any, body: anyNamed('body'), headers: anyNamed('headers')))
        .thenAnswer((_) async => Response(responseBody, 200));

    final response =
        await userApi.forgotPassword(LoginAssistanceRequest.fake());

    expect(response.data, isA<ApiResponse>());
    expect(response.status, HttpStatus.ok);
  });

  test('returns null data if forgot password request fails', () async {
    final responseBody = '{"message":"Validation failed"}';

    when(client.http
            .post(any, body: anyNamed('body'), headers: anyNamed('headers')))
        .thenAnswer((_) async => Response(responseBody, 400));

    final response =
        await userApi.forgotPassword(LoginAssistanceRequest.fake());

    expect(response.data, isA<void>());
    expect(response.status, HttpStatus.badRequest);
  });

  group('#deleteMe', () {
    test('sends correct request', () async {
      // Given
      final name = "Test User";
      final responseBody =
          '{"id":1,"name":"$name","country_calling_code":"55","phone_number":"61981178515","image_url":"https://firebasestorage.googleapis.com/v0/b/givapp-938de.appspot.com/o/dev%2Fusers%2F1%2Fphotos%2F1569400230645.jpg?alt=media&token=5f7cdb23-1f6d-4e10-bd30-9df04265522e","bio":null,"admin":true,"created_at":"2019-03-25T02:39:26.452Z"}';

      when(mockHttp.delete('${userApi.baseUrl}/${UserApi.ME_ENDPOINT}',
              headers: anyNamed('headers')))
          .thenAnswer((_) async => Response(responseBody, 200));

      // When
      await userApi.deleteMe();

      // Expect
      verify(
        mockHttp.delete(
          '${userApi.baseUrl}/${UserApi.ME_ENDPOINT}',
          headers: anyNamed('headers'),
        ),
      ).captured;
    });

    test('returns correct user data if request succeeds', () async {
      // Given
      final name = "Test User";
      final responseBody =
          '{"id":1,"name":"$name","country_calling_code":"55","phone_number":"61981178515","image_url":"https://firebasestorage.googleapis.com/v0/b/givapp-938de.appspot.com/o/dev%2Fusers%2F1%2Fphotos%2F1569400230645.jpg?alt=media&token=5f7cdb23-1f6d-4e10-bd30-9df04265522e","bio":null,"admin":true,"created_at":"2019-03-25T02:39:26.452Z"}';

      when(mockHttp.delete('${userApi.baseUrl}/${UserApi.ME_ENDPOINT}',
              headers: anyNamed('headers')))
          .thenAnswer((_) async => Response(responseBody, 200));

      // When
      final response = await userApi.deleteMe();

      // Then
      expect(response.data, isA<User>());
      expect(response.data.name, name);
      expect(response.status, HttpStatus.ok);
    });

    test('returns null data if request fails', () async {
      final responseBody = '{"message":"Unauthorized"}';

      when(mockHttp.delete('${userApi.baseUrl}/${UserApi.ME_ENDPOINT}',
              headers: anyNamed('headers')))
          .thenAnswer((_) async => Response(responseBody, 401));

      final response = await userApi.deleteMe();

      expect(response.data, isA<void>());
      expect(response.status, HttpStatus.unauthorized);
    });

    test('returns null data and error message if http throws', () async {
      // Given
      final errorMessage = 'some error';

      when(mockHttp.delete('${userApi.baseUrl}/${UserApi.ME_ENDPOINT}',
              headers: anyNamed('headers')))
          .thenThrow(errorMessage);

      // When
      final response = await userApi.deleteMe();

      // Then
      expect(response.data, isNull);
      expect(response.message, equals(errorMessage));
    });
  });

  group('#createAccountCancellationIntent', () {
    test('sends correct request', () async {
      // When
      await userApi.createAccountCancellationIntent();

      // Expect
      final captured = verify(mockHttp.post(captureAny,
              body: captureAnyNamed('body'), headers: anyNamed('headers')))
          .captured;

      final capturedUrl = captured[0];
      expect(
        capturedUrl,
        '${userApi.baseUrl}/${UserApi.ACCOUNT_CANCELATION_INTENT_ENDPOINT}',
      );
    });

    test('returns api response data if request succeeds', () async {
      final responseBody = '{"message":"Account cancellation intent received"}';

      when(
        client.http.post(
          '${userApi.baseUrl}/${UserApi.ACCOUNT_CANCELATION_INTENT_ENDPOINT}',
          body: anyNamed('body'),
          headers: anyNamed('headers'),
        ),
      ).thenAnswer((_) async => Response(responseBody, 201));

      final response = await userApi.createAccountCancellationIntent();

      expect(response.data, isA<ApiResponse>());
      expect(response.status, HttpStatus.created);
    });

    test('returns null data if resend activation request fails', () async {
      final responseBody = '{"message":"Validation failed"}';

      when(
        client.http.post(
          '${userApi.baseUrl}/${UserApi.ACCOUNT_CANCELATION_INTENT_ENDPOINT}',
          body: anyNamed('body'),
          headers: anyNamed('headers'),
        ),
      ).thenAnswer((_) async => Response(responseBody, 404));

      final response = await userApi.createAccountCancellationIntent();

      expect(response.data, isA<void>());
      expect(response.status, HttpStatus.notFound);
    });

    test('returns null data and error message if http throws', () async {
      // Given
      final errorMessage = 'some error';

      when(
        client.http.post(
          '${userApi.baseUrl}/${UserApi.ACCOUNT_CANCELATION_INTENT_ENDPOINT}',
          body: anyNamed('body'),
          headers: anyNamed('headers'),
        ),
      ).thenThrow(errorMessage);

      // When
      final response = await userApi.createAccountCancellationIntent();

      // Then
      expect(response.data, isNull);
      expect(response.message, equals(errorMessage));
    });
  });

  test('returns api response data if resend activation request succeeds',
      () async {
    final responseBody = '{"message":"Password reset email sent"}';

    when(client.http
            .post(any, body: anyNamed('body'), headers: anyNamed('headers')))
        .thenAnswer((_) async => Response(responseBody, 200));

    final response =
        await userApi.resendActivation(LoginAssistanceRequest.fake());

    expect(response.data, isA<ApiResponse>());
    expect(response.status, HttpStatus.ok);
  });

  test('returns null data if resend activation request fails', () async {
    final responseBody = '{"message":"Validation failed"}';

    when(client.http
            .post(any, body: anyNamed('body'), headers: anyNamed('headers')))
        .thenAnswer((_) async => Response(responseBody, 400));

    final response =
        await userApi.resendActivation(LoginAssistanceRequest.fake());

    expect(response.data, isA<void>());
    expect(response.status, HttpStatus.badRequest);
  });

  test('returns correct user data if get me request succeeds', () async {
    final name = "Test User";
    final responseBody =
        '{"id":1,"name":"$name","country_calling_code":"55","phone_number":"61981178515","image_url":"https://firebasestorage.googleapis.com/v0/b/givapp-938de.appspot.com/o/dev%2Fusers%2F1%2Fphotos%2F1569400230645.jpg?alt=media&token=5f7cdb23-1f6d-4e10-bd30-9df04265522e","bio":null,"admin":true,"created_at":"2019-03-25T02:39:26.452Z"}';

    when(client.http.get(any, headers: anyNamed('headers')))
        .thenAnswer((_) async => Response(responseBody, 200));

    final response = await userApi.getMe();

    expect(response.data, isA<User>());
    expect(response.data.name, name);
    expect(response.status, HttpStatus.ok);
  });

  test('returns null data if get me request fails', () async {
    final responseBody = '{"message":"Unauthorized"}';

    when(client.http.get(any, headers: anyNamed('headers')))
        .thenAnswer((_) async => Response(responseBody, 401));

    final response = await userApi.getMe();

    expect(response.data, isA<void>());
    expect(response.status, HttpStatus.unauthorized);
  });

  test('returns correct user data if update me request succeeds', () async {
    final name = "Test User";
    final responseBody =
        '{"id":1,"name":"$name","country_calling_code":"55","phone_number":"61981178515","image_url":"https://firebasestorage.googleapis.com/v0/b/givapp-938de.appspot.com/o/dev%2Fusers%2F1%2Fphotos%2F1569400230645.jpg?alt=media&token=5f7cdb23-1f6d-4e10-bd30-9df04265522e","bio":null,"admin":true,"created_at":"2019-03-25T02:39:26.452Z"}';

    when(client.http
            .put(any, body: anyNamed('body'), headers: anyNamed('headers')))
        .thenAnswer((_) async => Response(responseBody, 200));

    final response = await userApi.updateMe({});

    expect(response.data, isA<User>());
    expect(response.data.name, name);
    expect(response.status, HttpStatus.ok);
  });

  test('returns null data if update me request fails', () async {
    final responseBody = '{"message":"Unauthorized"}';

    when(client.http
            .put(any, body: anyNamed('body'), headers: anyNamed('headers')))
        .thenAnswer((_) async => Response(responseBody, 401));

    final response = await userApi.updateMe({});

    expect(response.data, isA<void>());
    expect(response.status, HttpStatus.unauthorized);
  });
}
