import 'package:flutter/foundation.dart';
import 'package:giv_flutter/util/util.dart';

class AboutBloc {
  final Util util;
  final String versionName;

  AboutBloc({
    @required this.util,
    @required this.versionName,
  });

  launchURL(url) => util.launchURL(url);
}
