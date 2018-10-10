class Product {
  final String title;
  final String location;
  final String description;
  final List<String> imageUrls;

  Product({this.title, this.location, this.description, this.imageUrls});

  static List<Product> getMockList(int quantity, {prefix = "2"}) {
    final List<Product> list = [];
    for (var i = 0; i < quantity; i++) {
      list.add(
        Product(
          title: "Notebook MacBookPro com defeito nas caixas de som",
          location: 'Brasília - DF',
          description: 'Lorem ipsum dolor sit amet consectetur adipiscing elit sed do eiusmod tempor incididunt ut labore et dolore magna aliqua. The quick brown fox jumps over the lazy dog. ',
          imageUrls: [
            "https://picsum.photos/1000/1000/?image=$prefix$i",
            "https://picsum.photos/1000/1000/?image=$prefix${i + 1}",
            "https://picsum.photos/1000/1000/?image=$prefix${i + 2}",
            "https://picsum.photos/1000/1000/?image=$prefix${i + 3}",
            "https://picsum.photos/1000/1000/?image=$prefix${i + 4}",
          ]
        )
      );
    }
    return list;
  }
}
