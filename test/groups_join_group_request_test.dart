import 'package:flutter_test/flutter_test.dart';
import 'package:giv_flutter/model/group_membership/repository/api/request/join_group_request.dart';

main() {
  group('JoinGroupRequest', () {
    test('should have have instance method to create http request body', () {
      // Given
      final accessToken = 'ABCD';
      final request = JoinGroupRequest(accessToken: accessToken);

      // When
      final httpBody = request.toHttpRequestBody();

      // Expect
      expect(httpBody['access_token'], equals(accessToken));
    });
  });
}
