import 'package:faker/faker.dart';
import 'package:giv_flutter/model/user/user.dart';

class Product {
  final String title;
  final String location;
  final String description;
  final List<String> imageUrls;
  final User user;

  Product({
    this.title,
    this.location,
    this.description,
    this.imageUrls,
    this.user
  });

  static List<Product> getMockList(int quantity) {
    final faker = new Faker();
    final List<Product> list = [];

    for (var i = 0; i < quantity; i++) {
      final numberOfImages = faker.randomGenerator.integer(8, min: 1);
      final imageIds = faker.randomGenerator.numbers(1000, numberOfImages);
      final imageUrls = imageIds.map((id) {
        return "https://picsum.photos/1000/1000/?image=$id";
      }).toList();

      list.add(
        Product(
          title: faker.food.dish(),
          location: "${faker.address.city()}, ${faker.address.country()}",
          description: 'Lorem ipsum dolor sit amet consectetur adipiscing elit sed do eiusmod tempor incididunt ut labore et dolore magna aliqua. The quick brown fox jumps over the lazy dog. ',
          imageUrls: imageUrls,
          user: User.mock()
        )
      );
    }
    return list;
  }
}
