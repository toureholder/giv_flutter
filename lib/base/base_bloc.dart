import 'package:flutter/foundation.dart';
import 'package:giv_flutter/model/location/location.dart';
import 'package:giv_flutter/model/user/user.dart';
import 'package:giv_flutter/service/preferences/disk_storage_provider.dart';

class BaseBloc {
  final DiskStorageProvider diskStorage;

  BaseBloc({@required this.diskStorage});

  User getUser() => diskStorage.getUser();
  Location getLocation() => diskStorage.getLocation();
}
