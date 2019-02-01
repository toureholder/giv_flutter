import 'package:meta/meta.dart';

class LogInWithProviderRequest {
  final String provider;
  final String accessToken;
  final String localeString;

  LogInWithProviderRequest(
      {@required this.provider, @required this.accessToken, this.localeString});

  Map<String, String> toHttpRequestBody() => {
    'auth_provider': provider,
    'access_token': accessToken,
    'locale': localeString
  };

  static const facebook = 'FACEBOOK';
}
