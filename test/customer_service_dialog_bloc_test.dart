import 'package:giv_flutter/features/customer_service/bloc/customer_service_dialog_bloc.dart';
import 'package:mockito/mockito.dart';
import 'package:test/test.dart';

import 'test_util/mocks.dart';

main() {
  MockDiskStorageProvider mockDiskStorage;
  CustomerServiceDialogBloc customerServiceDialogBloc;
  MockUtil mockUtil;

  setUp(() {
    mockDiskStorage = MockDiskStorageProvider();
    mockUtil = MockUtil();
    customerServiceDialogBloc = CustomerServiceDialogBloc(
      diskStorage: mockDiskStorage,
      util: mockUtil,
    );
  });

  tearDown(() {
    reset(mockDiskStorage);
    reset(mockUtil);
  });

  test('saves \'has agreed to customer service\' to disk', () {
    customerServiceDialogBloc.setHasAgreedToCustomerService();
    verify(mockDiskStorage.setHasAgreedToCustomerService()).called(1);
  });

  test('launched customer service', () {
    final message = 'message';
    customerServiceDialogBloc.launchCustomerService(message);
    verify(mockUtil.launchCustomerService(message)).called(1);
  });
}
