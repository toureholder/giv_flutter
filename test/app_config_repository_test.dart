import 'package:giv_flutter/model/app_config/repository/app_config_repository.dart';
import 'package:mockito/mockito.dart';
import 'package:test/test.dart';

import 'test_util/mocks.dart';

void main() {
  AppConfigRepository appConfigRepository;
  MockAppConfigApi mockAppConfigApi;

  setUp((){
    mockAppConfigApi = MockAppConfigApi();
    appConfigRepository = AppConfigRepository(appConfigApi: mockAppConfigApi);
  });

  tearDown((){
    reset(mockAppConfigApi);
  });

  test('calls appConfig api', () async {
    await appConfigRepository.getConfig();
    verify(mockAppConfigApi.getConfig());
  });
}