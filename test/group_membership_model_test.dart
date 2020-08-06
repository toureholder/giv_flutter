import 'package:giv_flutter/model/group_membership/group_membership.dart';
import 'package:test/test.dart';

main() {
  group('GroupMemberhip', () {
    test('should have a static method to deserialize an instance from json',
        () {
      // Given
      final Map<String, dynamic> json = {
        "id": 29,
        "is_admin": false,
        "created_at": "2020-08-08T12:13:31.461Z",
        "user": {
          "id": 2,
          "name": "Test User 1",
          "country_calling_code": null,
          "phone_number": null,
          "image_url": null,
          "bio": null,
          "created_at": "2020-02-21T09:07:55.911Z"
        },
        "group": {
          "id": 19,
          "name": "New group",
          "description":
              "Lorem ipsum dolor sit amet consectetur adipiscing elit sed do eiusmod tempo incididunt ut labore et dolore magna aliqua",
          "image_url": "https://picsum.photos/200",
          "access_token": "9C43",
          "created_at": "2020-08-08T12:11:57.658Z"
        }
      };

      // When
      final instance = GroupMembership.fromJson(json);

      // THen
      final group = instance.group;
      final user = instance.user;
      final groupJson = json['group'];
      final userJson = json['user'];

      expect(instance, isA<GroupMembership>());
      expect(instance.id, equals(json['id']));
      expect(instance.isAdmin, equals(json['is_admin']));
      expect(instance.createdAt, equals(DateTime.parse(json['created_at'])));
      expect(group.id, equals(groupJson['id']));
      expect(group.name, equals(groupJson['name']));
      expect(group.description, equals(groupJson['description']));
      expect(group.imageUrl, equals(groupJson['image_url']));
      expect(group.accessToken, equals(groupJson['access_token']));
      expect(group.createdAt, equals(DateTime.parse(groupJson['created_at'])));
      expect(user.id, equals(userJson['id']));
      expect(user.name, equals(userJson['name']));
      expect(user.bio, equals(userJson['bio']));
      expect(user.createdAt, equals(DateTime.parse(userJson['created_at'])));
    });

    test('should have a static method to create a fake instance', () {
      // When
      final instance = GroupMembership.fake();

      // Then
      expect(instance, isA<GroupMembership>());
    });

    test('should have a static method to tranform list into a map', () {
      // Given
      final memberhsips = GroupMembership.fakeList();

      // When
      final map = GroupMembership.listToMap(memberhsips);

      // Then
      final firstMembership = memberhsips[0];
      expect(map[firstMembership.id].group.id, firstMembership.group.id);
      expect(map[firstMembership.id].user.id, firstMembership.user.id);
    });

    test(
        'should have a static method to deserialize a list of instances from a list of json objects',
        () {
      // Given
      final membershipOneId = 1;
      final membershipTwoId = 2;
      final groupOneId = 3;
      final groupTwoId = 4;
      final userOneId = 5;
      final userTwoId = 6;
      final List<dynamic> json = [
        {
          "id": membershipOneId,
          "is_admin": true,
          "created_at": "2020-08-14T09:40:45.056Z",
          "user": {
            "id": userOneId,
            "name": "Test User 1",
            "country_calling_code": null,
            "phone_number": null,
            "image_url": null,
            "bio": null,
            "created_at": "2020-02-21T09:07:55.911Z"
          },
          "group": {
            "id": groupOneId,
            "name": "Wat",
            "description": null,
            "image_url": null,
            "access_token": "B935",
            "created_at": "2020-08-14T09:40:45.044Z"
          }
        },
        {
          "id": membershipTwoId,
          "is_admin": true,
          "created_at": "2020-08-14T09:39:18.428Z",
          "user": {
            "id": userTwoId,
            "name": "Test User 1",
            "country_calling_code": null,
            "phone_number": null,
            "image_url": null,
            "bio": null,
            "created_at": "2020-02-21T09:07:55.911Z"
          },
          "group": {
            "id": groupTwoId,
            "name": "Wat",
            "description": null,
            "image_url": null,
            "access_token": "7EE7",
            "created_at": "2020-08-14T09:39:18.375Z"
          }
        },
      ];

      // When
      final memberships = GroupMembership.fromDynamicList(json);

      // Then
      expect(memberships[0].id, membershipOneId);
      expect(memberships[0].group.id, groupOneId);
      expect(memberships[0].user.id, userOneId);
      expect(memberships[1].id, membershipTwoId);
      expect(memberships[1].group.id, groupTwoId);
      expect(memberships[1].user.id, userTwoId);
    });

    test(
        'should have a static method to deserialize a list of instances from json string',
        () {
      // Given
      final membershipOneId = 1;
      final membershipTwoId = 2;
      final groupOneId = 3;
      final groupTwoId = 4;
      final userOneId = 5;
      final userTwoId = 6;
      final jsonString =
          '[{"id":$membershipOneId,"is_admin":true,"created_at":"2020-08-14T09:40:45.056Z","user":{"id":$userOneId,"name":"Test User 1","country_calling_code":null,"phone_number":null,"image_url":null,"bio":null,"created_at":"2020-02-21T09:07:55.911Z"},"group":{"id":$groupOneId,"name":"Wat","description":null,"image_url":null,"access_token":"B935","created_at":"2020-08-14T09:40:45.044Z"}},{"id":$membershipTwoId,"is_admin":true,"created_at":"2020-08-14T09:39:18.428Z","user":{"id":$userTwoId,"name":"Test User 1","country_calling_code":null,"phone_number":null,"image_url":null,"bio":null,"created_at":"2020-02-21T09:07:55.911Z"},"group":{"id":$groupTwoId,"name":"Wat","description":null,"image_url":null,"access_token":"7EE7","created_at":"2020-08-14T09:39:18.375Z"}}]';

      // When
      final memberships = GroupMembership.parseList(jsonString);

      // Then
      expect(memberships[0].id, membershipOneId);
      expect(memberships[0].group.id, groupOneId);
      expect(memberships[0].user.id, userOneId);
      expect(memberships[1].id, membershipTwoId);
      expect(memberships[1].group.id, groupTwoId);
      expect(memberships[1].user.id, userTwoId);
    });
  });
}
