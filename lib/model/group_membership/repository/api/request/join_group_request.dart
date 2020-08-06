class JoinGroupRequest {
  final String accessToken;

  JoinGroupRequest({this.accessToken});

  Map<String, String> toHttpRequestBody() => {
        'access_token': accessToken,
      };

  JoinGroupRequest.fake() : accessToken = 'ABCD';
}
