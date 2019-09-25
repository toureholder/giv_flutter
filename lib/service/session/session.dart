import 'package:giv_flutter/service/preferences/disk_storage_provider.dart';
import 'package:giv_flutter/model/user/repository/api/response/log_in_response.dart';
import 'package:giv_flutter/service/session/session_provider.dart';

class Session extends SessionProvider {
  final DiskStorageProvider diskStorage;

  Session(this.diskStorage);

  @override
  Future<List<bool>> logUserIn(LogInResponse logInResponse) => Future.wait([
        diskStorage.setUser(logInResponse.user),
        diskStorage.setServerToken(logInResponse.longLivedToken),
        diskStorage.setFirebaseToken(logInResponse.firebaseAuthToken),
      ]);

  @override
  Future<List<bool>> logUserOut() => Future.wait([
        diskStorage.clearUser(),
        diskStorage.clearServerToken(),
        diskStorage.clearFirebaseToken()
      ]);

  @override
  bool isAuthenticated() => diskStorage.getServerToken() != null;
}
