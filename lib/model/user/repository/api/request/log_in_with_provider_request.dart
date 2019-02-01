import 'package:meta/meta.dart';

class LogInWithProviderRequest {
  final String provider;
  final String accessToken;

  LogInWithProviderRequest(
      {@required this.provider, @required this.accessToken});

  static const facebook = 'FACEBOOK';
}
