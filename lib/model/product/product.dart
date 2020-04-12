import 'dart:convert';
import 'dart:io';

import 'package:faker/faker.dart';
import 'package:giv_flutter/model/image/image.dart';
import 'package:giv_flutter/model/listing/listing_image.dart';
import 'package:giv_flutter/model/listing/repository/api/request/create_listing_request.dart';
import 'package:giv_flutter/model/location/location.dart';
import 'package:giv_flutter/model/product/product_category.dart';
import 'package:giv_flutter/model/user/user.dart';

class Product {
  int id;
  String title;
  Location location;
  String description;
  List<Image> images;
  User user;
  List<ProductCategory> categories;
  bool isActive;
  bool isMailable;
  DateTime updatedAt;

  Product({
    this.id,
    this.title,
    this.location,
    this.description,
    this.images,
    this.user,
    this.categories,
    this.isActive = true,
    this.isMailable = false,
    this.updatedAt,
  });

  Product.fromJson(Map<String, dynamic> json)
      : id = json['id'],
        title = json['title'],
        description = json['description'],
        isActive = json['is_active'],
        isMailable = false,
        updatedAt = DateTime.parse(json['updated_at']),
        location = Location.fromLocationPartIds(
            countryId: json['geonames_country_id'],
            stateId: json['geonames_state_id'],
            cityId: json['geonames_city_id']),
        user = User.fromJson(json['user']),
        categories = ProductCategory.fromDynamicList(json['categories']),
        images = Image.fromListingImageList(
            ListingImage.fromDynamicList(json['listing_images']));

  static List<Product> fromDynamicList(List<dynamic> list) {
    return list.map<Product>((json) => Product.fromJson(json)).toList();
  }

  static List<Product> parseList(String responseBody) {
    final parsed = json.decode(responseBody).cast<Map<String, dynamic>>();
    return fromDynamicList(parsed);
  }

  bool get isNotEmpty =>
      title != null ||
      description != null ||
      (images != null && images.isNotEmpty) ||
      (categories != null && categories.isNotEmpty);

  bool get isLocationComplete => location?.isOk ?? false;

  Product copy() {
    var images = List<Image>.from(this.images);

    var categories = List<ProductCategory>.from(this.categories);

    return Product(
        id: id,
        title: title,
        description: description,
        isActive: isActive,
        location: Location(
            country: location?.country,
            state: location?.state,
            city: location?.city),
        user: user,
        images: images,
        categories: categories);
  }

  CreateListingRequest toListingRequest(List<ListingImage> images) {
    return CreateListingRequest(
        id: id,
        title: title,
        description: description,
        geoNamesCityId: location?.city?.id,
        geoNamesStateId: location?.state?.id,
        geoNamesCountryId: location?.country?.id,
        images: images,
        categoryIds: categories.map((it) => it.id).toList(),
        isActive: isActive);
  }

  List<File> get imageFiles => images
      .where((image) => image.file != null)
      .map((image) => image.file)
      .toList();

  factory Product.fakeWithImageUrls(int id, {int howManyImages}) {
    final faker = new Faker();

    final numberOfImages =
        howManyImages ?? faker.randomGenerator.integer(8, min: 1);
    final imageIds = faker.randomGenerator.numbers(1000, numberOfImages);
    final images = imageIds.map((id) {
      return Image(url: "https://picsum.photos/500/500/?image=$id");
    }).toList();

    return Product(
        id: id ?? faker.randomGenerator.integer(99, min: 1),
        title: faker.food.dish(),
        location: Location.fake(),
        description:
            'Lorem ipsum dolor sit amet consectetur adipiscing elit sed do eiusmod tempor incididunt ut labore et dolore magna aliqua. The quick brown fox jumps over the lazy dog. ',
        images: images,
        categories: [
          ProductCategory(
            id: 20,
            simpleName: "Música e hobbies",
          )
        ],
        updatedAt: DateTime(1982, 8, 11),
        user: User.fake());
  }

  factory Product.fakeWithImageFiles(int id, {int howManyImages}) {
    final faker = new Faker();

    final numberOfImages =
        howManyImages ?? faker.randomGenerator.integer(8, min: 1);
    final imageIds = faker.randomGenerator.numbers(1000, numberOfImages);
    final images = imageIds.map((id) {
      return Image(file: File('some/path/{$id}.jpg'));
    }).toList();

    return Product(
        id: id ?? faker.randomGenerator.integer(99, min: 1),
        title: faker.food.dish(),
        location: Location.fake(),
        description:
            'Lorem ipsum dolor sit amet consectetur adipiscing elit sed do eiusmod tempor incididunt ut labore et dolore magna aliqua. The quick brown fox jumps over the lazy dog. ',
        images: images,
        categories: [
          ProductCategory(
            id: 20,
            simpleName: "Música e hobbies",
          )
        ],
        user: User.fake());
  }

  factory Product.fakeWithIncompleteLocation(int id, {int howManyImages}) {
    final faker = new Faker();

    final numberOfImages =
        howManyImages ?? faker.randomGenerator.integer(8, min: 1);
    final imageIds = faker.randomGenerator.numbers(1000, numberOfImages);
    final images = imageIds.map((id) {
      return Image(file: File('some/path/{$id}.jpg'));
    }).toList();

    return Product(
        id: id ?? faker.randomGenerator.integer(99, min: 1),
        title: faker.food.dish(),
        location: Location.fakeMissingNames(),
        description:
            'Lorem ipsum dolor sit amet consectetur adipiscing elit sed do eiusmod tempor incididunt ut labore et dolore magna aliqua. The quick brown fox jumps over the lazy dog. ',
        images: images,
        categories: [
          ProductCategory(
            id: 20,
            simpleName: "Música e hobbies",
          )
        ],
        user: User.fake());
  }

  static List<Product> fakeList({int quantity}) {
    final faker = new Faker();
    final List<Product> list = [];

    int size = quantity ?? faker.randomGenerator.integer(20, min: 3);

    for (var i = 0; i < size; i++) {
      list.add(Product.fakeWithImageUrls(i + 1));
    }
    return list;
  }
}
