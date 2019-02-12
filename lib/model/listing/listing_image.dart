class ListingImage {
  final String url;
  final int position;

  ListingImage({this.url, this.position});

  Map<String, dynamic> toHttpRequestBody() =>
      {'url': url, 'position': position};

  ListingImage.fromJson(Map<String, dynamic> json)
      : url = json['url'],
        position = json['position'];

  static List<ListingImage> fromDynamicList(List<dynamic> list) {
    return list
        .map<ListingImage>((json) => ListingImage.fromJson(json))
        .toList();
  }
}
