import 'dart:convert';

class ListingImage {
  final String url;
  final int position;

  ListingImage({this.url, this.position});

  Map<String, dynamic> toHttpRequestBody() => {
    'url': url,
    'position': position
  };

  String toEncodedBody() => json.encode(toHttpRequestBody());
}