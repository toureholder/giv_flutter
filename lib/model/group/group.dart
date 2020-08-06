import 'package:giv_flutter/config/hive/constants.dart';
import 'package:hive/hive.dart';

part 'group.g.dart';

@HiveType(typeId: HiveConstants.groupsTypeId)
class Group extends HiveObject {
  @HiveField(0)
  final int id;

  @HiveField(1)
  final String name;

  @HiveField(2)
  final String description;

  @HiveField(3)
  final String imageUrl;

  @HiveField(4)
  final String accessToken;

  @HiveField(5)
  final DateTime createdAt;

  String randomImageUrl;

  Group(
      {this.id,
      this.name,
      this.description,
      this.imageUrl,
      this.accessToken,
      this.createdAt});

  static final String idKey = 'id';
  static final String nameKey = 'name';
  static final String descriptionKey = 'description';
  static final String imageUrlKey = 'image_url';
  static final String accessTokenKey = 'access_token';
  static final String createdAtlKey = 'created_at';

  Map<String, dynamic> toJson() => {
        idKey: this.id,
        nameKey: this.name,
        descriptionKey: this.description,
        imageUrlKey: this.imageUrl,
        accessTokenKey: this.accessToken,
        createdAtlKey: this.createdAt
      };

  Group.fromJson(Map<String, dynamic> json)
      : id = json[idKey],
        name = json[nameKey],
        description = json[descriptionKey],
        imageUrl = json[imageUrlKey],
        accessToken = json[accessTokenKey],
        createdAt = (json[createdAtlKey] == null)
            ? null
            : DateTime.parse(json[createdAtlKey]);

  static List<Group> fromDynamicList(List jsonList) {
    return jsonList.map<Group>((json) => Group.fromJson(json)).toList();
  }

  Group.fake({int id, String name})
      : id = id ?? 1,
        name = name ?? 'Fake group',
        description =
            'Lorem ipsum dolor sit amet consectetur adipiscing elit sed do eiusmod tempor incididunt ut labore et dolore magna aliqua.',
        imageUrl = 'https://picsum.photos/200',
        accessToken = 'ABCD',
        createdAt = DateTime.now();

  static List<Group> fakeList() {
    return [
      Group.fake(id: 1, name: 'Group 1'),
      Group.fake(id: 2, name: 'Group 2'),
    ];
  }

  static Map<int, Group> listToMap(List<Group> groups) {
    final map = <int, Group>{};

    groups.forEach((group) {
      map.addAll(
        {group.id: group},
      );
    });

    return map;
  }
}
