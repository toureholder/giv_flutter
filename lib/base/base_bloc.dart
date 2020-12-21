import 'package:flutter/foundation.dart';
import 'package:giv_flutter/model/location/location.dart';
import 'package:giv_flutter/model/user/user.dart';
import 'package:giv_flutter/service/preferences/disk_storage_provider.dart';

class BaseBloc {
  final DiskStorageProvider diskStorage;

  BaseBloc({@required this.diskStorage});

  User getUser() => diskStorage.getUser();

  Location getLocation() => diskStorage.getLocation();

  bool hasSeenCreateGroupIntroduction() =>
      diskStorage.hasSeenCreateGroupIntroduction();

  Future<bool> setHasSeenCreateGroupIntroduction() =>
      diskStorage.setHasSeenCreateGroupIntroduction();

  bool hasSeenJoinGroupIntroduction() =>
      diskStorage.hasSeenJoinGroupIntroduction();

  Future<bool> setHasSeenJoinGroupIntroduction() =>
      diskStorage.setHasSeenJoinGroupIntroduction();

  bool hasSeenDonationIntroduction() =>
      diskStorage.hasSeenDonationIntroduction();

  Future<bool> setHasSeenDonationIntroduction() =>
      diskStorage.setHasSeenDonationIntroduction();

  bool hasSeenDonationRequestIntroduction() =>
      diskStorage.hasSeenDonationRequestIntroduction();

  Future<bool> setHasSeenDonationRequestIntroduction() =>
      diskStorage.setHasSeenDonationRequestIntroduction();
}
