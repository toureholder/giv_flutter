import 'package:giv_flutter/util/util.dart';

class AboutBloc {
  final Util util;

  AboutBloc({this.util});

  launchURL(url) => util.launchURL(url);
}
