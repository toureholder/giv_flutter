import 'package:flutter/material.dart';
import 'package:giv_flutter/base/base_state.dart';
import 'package:giv_flutter/util/presentation/custom_app_bar.dart';
import 'package:giv_flutter/util/presentation/custom_scaffold.dart';

class MyListings extends StatefulWidget {
  @override
  _MyListingsState createState() => _MyListingsState();
}

class _MyListingsState extends BaseState<MyListings> {
  @override
  Widget build(BuildContext context) {
    super.build(context);

    return CustomScaffold(
      appBar: CustomAppBar(title: string('me_listings')),
      body: Center(child: Text(string('me_listings')),),
    );
  }
}
