import 'package:flutter/foundation.dart';

class AddManyListingsToGroupRequest {
  final int groupId;
  final List<int> ids;

  AddManyListingsToGroupRequest({
    @required this.groupId,
    @required this.ids,
  });

  Map<String, dynamic> toHttpRequestBody() => {'ids': this.ids};

  AddManyListingsToGroupRequest.fake()
      : groupId = 1,
        ids = [1, 2, 3];
}
