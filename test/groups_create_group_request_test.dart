import 'package:flutter_test/flutter_test.dart';
import 'package:giv_flutter/model/group/repository/api/request/create_group_request.dart';

main() {
  group('CreateGroupRequest', () {
    test('should have have instance method to create http request body', () {
      // Given
      final name = 'My new group';
      final description =
          'Lorem ipsum dolor sit amet consectetur adipiscing elit sed do eiusmod tempor incididucnt ut labore et dolore magna aliqual.';

      final request = CreateGroupRequest(
        name: name,
        description: description,
      );

      // When
      final httpBody = request.toHttpRequestBody();

      // Expect
      expect(httpBody['name'], equals(name));
      expect(httpBody['description'], equals(description));
    });
  });
}
