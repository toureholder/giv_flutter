import 'package:flutter/foundation.dart';
import 'package:giv_flutter/service/preferences/disk_storage_provider.dart';
import 'package:giv_flutter/util/util.dart';

class CustomerServiceDialogBloc {
  final DiskStorageProvider diskStorage;
  final Util util;

  CustomerServiceDialogBloc({
    @required this.diskStorage,
    @required this.util,
  });

  setHasAgreedToCustomerService() =>
      diskStorage.setHasAgreedToCustomerService();

  launchCustomerService(message) => util.launchCustomerService(message);
}
