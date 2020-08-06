import 'package:flutter/material.dart';
import 'package:giv_flutter/features/groups/join_group/ui/join_group_get_more_info_row.dart';
import 'package:giv_flutter/model/group_membership/group_membership.dart';
import 'package:giv_flutter/util/data/content_stream_builder.dart';
import 'package:giv_flutter/util/network/http_response.dart';

class JoinGroupLoadingStreamBuilder extends StatelessWidget {
  final Stream<HttpResponse<GroupMembership>> stream;

  const JoinGroupLoadingStreamBuilder({
    Key key,
    @required this.stream,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<HttpResponse<GroupMembership>>(
        stream: stream,
        builder:
            (context, AsyncSnapshot<HttpResponse<GroupMembership>> snapshot) {
          return snapshot.data != null && snapshot.data.isLoading
              ? SharedLoadingState()
              : JoinGroupGetMoreInfoRow();
        });
  }
}
