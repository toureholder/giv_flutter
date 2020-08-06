import 'package:flutter/foundation.dart';
import 'package:giv_flutter/model/user/user.dart';
import 'package:giv_flutter/service/preferences/disk_storage_provider.dart';

class BaseBlocWithAuth {
  final DiskStorageProvider diskStorage;

  BaseBlocWithAuth({@required this.diskStorage});

  User getUser() => diskStorage.getUser();
}
