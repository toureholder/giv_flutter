class TokenStore {
  final String firebaseAuthToken;
  final String longLivedToken;

  TokenStore({this.firebaseAuthToken, this.longLivedToken});

  static final String firebaseKey = 'firebase';
  static final String longLivedKey = 'longLived';

  Map<String, dynamic> toJson() =>
      {firebaseKey: firebaseAuthToken, longLivedKey: longLivedToken};

  TokenStore.fromJson(Map<String, dynamic> json)
      : firebaseAuthToken = json[firebaseKey],
        longLivedToken = json[longLivedKey];
}
