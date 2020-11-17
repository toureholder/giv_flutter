import 'package:flutter_test/flutter_test.dart';
import 'package:giv_flutter/model/group/repository/api/request/add_many_listings_to_group_request.dart';

main() {
  group('AddManyListingsToGroupRequest', () {
    test('should have have instance method to create http request body', () {
      // Given
      final ids = <int>[1, 2, 3];
      final groupId = 13;

      final request = AddManyListingsToGroupRequest(
        ids: ids,
        groupId: groupId,
      );

      // When
      final httpBody = request.toHttpRequestBody();

      // Expect
      expect(httpBody['ids'], equals(ids));
    });
  });
}
