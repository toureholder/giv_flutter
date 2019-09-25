import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_facebook_login/flutter_facebook_login.dart';
import 'package:giv_flutter/model/user/repository/api/response/log_in_response.dart';
import 'package:giv_flutter/model/user/user.dart';
import 'package:giv_flutter/service/preferences/disk_storage_provider.dart';
import 'package:giv_flutter/service/session/session_provider.dart';

class Session extends SessionProvider {
  final DiskStorageProvider diskStorage;
  final FirebaseAuth firebaseAuth;
  final FacebookLogin facebookLogin;

  Session(this.diskStorage, this.firebaseAuth, this.facebookLogin);

  @override
  Future<List<bool>> logUserIn(LogInResponse logInResponse) => Future.wait([
        diskStorage.setUser(logInResponse.user),
        diskStorage.setServerToken(logInResponse.longLivedToken),
        diskStorage.setFirebaseToken(logInResponse.firebaseAuthToken),
      ]);

  @override
  Future<List<bool>> logUserOut() async {
    firebaseAuth.signOut();
    facebookLogin.logOut();

    return Future.wait([
      diskStorage.clearUser(),
      diskStorage.clearServerToken(),
      diskStorage.clearFirebaseToken()
    ]);
  }

  @override
  bool isAuthenticated() => diskStorage.getServerToken() != null;

  @override
  User getUser() => diskStorage.getUser();
}
