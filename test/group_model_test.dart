import 'package:giv_flutter/model/group/group.dart';
import 'package:test/test.dart';

main() {
  group('Group', () {
    test('should have a static method to tranform list into a map', () {
      // Given
      final groups = Group.fakeList();

      // When
      final map = Group.listToMap(groups);

      // Then
      final firstGroup = groups[0];
      expect(map[firstGroup.id].id, firstGroup.id);
      expect(map[firstGroup.id].name, firstGroup.name);
    });

    test('should have a static method to deserialize an instance from json',
        () {
      // Given
      final json = {
        "id": 8,
        "name": "My group",
        "description":
            "Lorem ipsum dolor sit amet consectetur adipiscing elit sed do eiusmod tempo incididunt ut labore et dolore magna aliqua",
        "image_url": null,
        "created_at": "2020-08-01T12:24:49.007Z"
      };

      // When
      final instance = Group.fromJson(json);

      // Then
      expect(instance, isA<Group>());
      expect(instance.name, equals(json['name']));
      expect(instance.description, equals(json['description']));
      expect(instance.imageUrl, equals(json['image_url']));
      expect(instance.accessToken, isNull);
      expect(instance.createdAt, equals(DateTime.parse(json['created_at'])));
    });

    test(
        'should have a static method to deserialize a list of instances from a list of json objects',
        () {
      final groupOneId = 3;
      final List<dynamic> json = [
        {
          "id": groupOneId,
          "name": "My group",
          "description":
              "Lorem ipsum dolor sit amet consectetur adipiscing elit sed do eiusmod tempo incididunt ut labore et dolore magna aliqua",
          "image_url": null,
          "created_at": "2020-08-01T12:25:16.009Z"
        }
      ];

      // When
      final groups = Group.fromDynamicList(json);

      // Then
      expect(groups[0].id, groupOneId);
    });
  });
}
