import 'package:flutter/material.dart';
import 'package:giv_flutter/base/base_bloc.dart';
import 'package:giv_flutter/features/product/filters/bloc/location_filter_bloc.dart';
import 'package:giv_flutter/features/product/filters/ui/location_filter.dart';
import 'package:giv_flutter/model/location/location.dart';
import 'package:provider/provider.dart';

class LocationRequiredState<T extends StatefulWidget> extends State<T> {
  final BaseBloc bloc;
  final Widget screenContent;
  final bool requireCompleteLocation;
  Location _location;

  LocationRequiredState({
    @required this.bloc,
    @required this.screenContent,
    @required this.requireCompleteLocation,
  });

  @override
  void initState() {
    super.initState();
    _location = bloc.getLocation();
  }

  @override
  Widget build(BuildContext context) {
    return _location == null
        ? Consumer<LocationFilterBloc>(
            builder: (context, bloc, child) => LocationFilter(
              bloc: bloc,
              requireCompleteLocation: requireCompleteLocation,
              redirect: screenContent,
              showHelpWdiget: true,
            ),
          )
        : screenContent;
  }
}
