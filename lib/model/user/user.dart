import 'package:faker/faker.dart';

class User {
  final String name;
  final String avatarUrl;
  final String phoneNumber;

  User({this.name, this.avatarUrl, this.phoneNumber});

  static final String nameKey = 'name';
  static final String avatarUrlKey = 'avatarUrl';
  static final String phoneNumberKey = 'phoneNumber';

  Map<String, dynamic> toJson() =>
      {nameKey: name, avatarUrlKey: avatarUrl, phoneNumberKey: phoneNumber};

  User.fromJson(Map<String, dynamic> json)
      : name = json[nameKey],
        avatarUrl = json[avatarUrlKey],
        phoneNumber = json[phoneNumberKey];

  static User mock() {
    final faker = new Faker();
    final fakePerson = faker.person;
    final String gender = faker.randomGenerator.boolean() ? "men" : "women";
    final id = faker.randomGenerator.integer(99, min: 1);

    return User(
        name: "${fakePerson.firstName()} ${fakePerson.lastName()}",
        avatarUrl: "https://randomuser.me/api/portraits/$gender/$id.jpg",
        phoneNumber: '5561981178515');
  }
}
