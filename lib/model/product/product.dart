import 'package:faker/faker.dart';
import 'package:giv_flutter/model/image/image.dart';
import 'package:giv_flutter/model/location/location.dart';
import 'package:giv_flutter/model/product/product_category.dart';
import 'package:giv_flutter/model/user/user.dart';

class Product {
  String title;
  Location location;
  String description;
  List<Image> images;
  User user;
  List<ProductCategory> categories;
  bool isActive;

  Product(
      {this.title,
      this.location,
      this.description,
      this.images,
      this.user,
      this.categories,
      this.isActive = true});

  bool get isNotEmpty {
    return title != null ||
        description != null ||
        (images != null && images.isNotEmpty) ||
        (categories != null && categories.isNotEmpty);
  }

  static Product mock() {
    final faker = new Faker();

    final numberOfImages = faker.randomGenerator.integer(8, min: 1);
    final imageIds = faker.randomGenerator.numbers(1000, numberOfImages);
    final images = imageIds.map((id) {
      return Image(url: "https://picsum.photos/500/500/?image=$id");
    }).toList();

    return Product(
        title: faker.food.dish(),
        location: Location.mock(),
        description:
            'Lorem ipsum dolor sit amet consectetur adipiscing elit sed do eiusmod tempor incididunt ut labore et dolore magna aliqua. The quick brown fox jumps over the lazy dog. ',
        images: images,
        categories: [
          ProductCategory(
            id: 20,
            simpleName: "Música e hobbies",
          )
        ],
        user: User.mock());
  }

  static List<Product> getMockList({int quantity}) {
    final faker = new Faker();
    final List<Product> list = [];

    int size = quantity ?? faker.randomGenerator.integer(20, min: 3);

    for (var i = 0; i < size; i++) {
      list.add(Product.mock());
    }
    return list;
  }
}
