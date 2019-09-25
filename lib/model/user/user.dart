import 'package:faker/faker.dart';

class User {
  int id;
  String name;
  String avatarUrl;
  String phoneNumber;
  String countryCallingCode;
  String bio;
  DateTime createdAt;

  User(
      {this.id,
      this.name,
      this.avatarUrl,
      this.phoneNumber,
      this.countryCallingCode,
      this.bio,
      this.createdAt});

  static final String idKey = 'id';
  static final String nameKey = 'name';
  static final String avatarUrlKey = 'image_url';
  static final String phoneNumberKey = 'phone_number';
  static final String countryCallingCodeKey = 'country_calling_code';
  static final String bioKey = 'bio';

  Map<String, dynamic> toJson() => {
        idKey: id,
        nameKey: name,
        avatarUrlKey: avatarUrl,
        phoneNumberKey: phoneNumber,
        countryCallingCodeKey: countryCallingCode,
        bioKey: bio
      };

  User.fromJson(Map<String, dynamic> json)
      : id = json[idKey],
        name = json[nameKey],
        avatarUrl = json[avatarUrlKey],
        phoneNumber = json[phoneNumberKey],
        countryCallingCode = json[countryCallingCodeKey],
        bio = json[bioKey],
        createdAt = (json['created_at'] == null)
            ? null
            : DateTime.parse(json['created_at']);

  bool get hasPhoneNumber => phoneNumber != null && phoneNumber.isNotEmpty;

  User copy() => User.fromJson(toJson());

  static User fake({bool withPhoneNumber = true}) {
    final faker = new Faker();
    final fakePerson = faker.person;
    final String gender = faker.randomGenerator.boolean() ? "men" : "women";
    final id = faker.randomGenerator.integer(99, min: 1);

    String phoneNumber;
    String countryCallingCode;

    if (withPhoneNumber) {
      phoneNumber = '61981178515';
      countryCallingCode = '55';
    }

    return User(
      id: id,
      name: "${fakePerson.firstName()} ${fakePerson.lastName()}",
      avatarUrl: "https://randomuser.me/api/portraits/$gender/$id.jpg",
      phoneNumber: phoneNumber,
      countryCallingCode: countryCallingCode,
    );
  }

  static User newUser() {
    final faker = new Faker();
    final fakePerson = faker.person;
    final String gender = faker.randomGenerator.boolean() ? "men" : "women";
    final id = faker.randomGenerator.integer(99, min: 1);

    return User(
        id: id,
        name: "${fakePerson.firstName()} ${fakePerson.lastName()}",
        avatarUrl: "https://randomuser.me/api/portraits/$gender/$id.jpg");
  }
}
