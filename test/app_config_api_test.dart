import 'package:giv_flutter/model/app_config/app_config.dart';
import 'package:giv_flutter/model/app_config/repository/api/app_config_api.dart';
import 'package:giv_flutter/util/network/http_client_wrapper.dart';
import 'package:giv_flutter/util/network/http_response.dart';
import 'package:http/http.dart';
import 'package:mockito/mockito.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:test/test.dart';

import 'test_util/mocks.dart';

void main() {
  SharedPreferences.setMockInitialValues({});
  HttpClientWrapper client;
  MockHttp mockHttp;
  AppConfigApi appConfigApi;

  setUp(() {
    mockHttp = MockHttp();
    client = HttpClientWrapper(mockHttp, MockDiskStorageProvider());
    appConfigApi = AppConfigApi(client: client);
  });

  tearDown((){
    reset(mockHttp);
  });

  test('returns list of CarouselItems data if GET request succeeds', () async {
    final responseBody =
        '{"customer_service_number":"5561999454459","privacy_policy_url":"https://alguemquer-terms.firebaseapp.com/privacy.html","terms_of_service_url":"https://alguemquer-terms.firebaseapp.com/"}';

    when(client.http.get(any, headers: anyNamed('headers')))
        .thenAnswer((_) async => Response(responseBody, 200));

    final response = await appConfigApi.getConfig();

    expect(response.data, isA<AppConfig>());
    expect(response.status, HttpStatus.ok);
  });

  test('returns null data if GET request fails', () async {
    when(client.http.get(any, headers: anyNamed('headers')))
        .thenAnswer((_) async => Response('', 500));

    final response = await appConfigApi.getConfig();

    expect(response.data, isA<void>());
    expect(response.status, HttpStatus.internalServerError);
  });
}
