import 'package:flutter/foundation.dart';
import 'package:giv_flutter/service/preferences/disk_storage_provider.dart';

class CustomerServiceDialogBloc {
  final DiskStorageProvider diskStorage;

  CustomerServiceDialogBloc({@required this.diskStorage});

  setHasAgreedToCustomerService() =>
      diskStorage.setHasAgreedToCustomerService();
}
