import 'package:faker/faker.dart';

class User {
  final String name;
  final String avatarUrl;

  User({this.name, this.avatarUrl});

  static User mock() {
    final faker = new Faker();
    final fakePerson = faker.person;
    final String gender = faker.randomGenerator.boolean() ? "men" : "women";
    final id = faker.randomGenerator.integer(99, min: 1);

    return User(
      name: "${fakePerson.firstName()} ${fakePerson.lastName()}",
      avatarUrl: "https://randomuser.me/api/portraits/$gender/$id.jpg"
    );
  }
}