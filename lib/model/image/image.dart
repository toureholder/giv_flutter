import 'dart:io';

class Image {
  final String url;
  final File file;

  Image({this.url, this.file});

  bool get hasUrl => url != null;
  bool get hasFile => file != null;
}