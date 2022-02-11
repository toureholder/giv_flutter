import 'package:giv_flutter/util/util.dart';
import 'package:meta/meta.dart';

class ForceUpdateBloc {
  final Util util;

  ForceUpdateBloc({@required this.util});

  launchURL(url) => util.launchURL(url);
}
