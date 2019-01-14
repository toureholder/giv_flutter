import 'package:flutter/material.dart';
import 'package:giv_flutter/base/base_state.dart';
import 'package:giv_flutter/features/product/filters/bloc/location_filter_bloc.dart';
import 'package:giv_flutter/model/location/location.dart';
import 'package:giv_flutter/model/location/location_list.dart';
import 'package:giv_flutter/model/location/location_part.dart' as LocationPart;
import 'package:giv_flutter/util/data/content_stream_builder.dart';
import 'package:giv_flutter/util/data/stream_event.dart';
import 'package:giv_flutter/util/presentation/buttons.dart';
import 'package:giv_flutter/util/presentation/custom_app_bar.dart';
import 'package:giv_flutter/util/presentation/custom_scaffold.dart';
import 'package:giv_flutter/util/presentation/dimens.dart';

class LocationFilter extends StatefulWidget {
  final Location location;

  const LocationFilter({Key key, this.location}) : super(key: key);

  @override
  _LocationFilterState createState() => _LocationFilterState();
}

class _LocationFilterState extends BaseState<LocationFilter> {
  LocationFilterBloc _locationFilterBloc;
  LocationList _locationList;
  Location _currentLocation;

  @override
  void initState() {
    super.initState();
    _currentLocation = widget.location.copy();
    _locationFilterBloc = LocationFilterBloc();
    _locationFilterBloc.fetchLocationLists(_currentLocation);
  }

  @override
  void dispose() {
    _locationFilterBloc.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    super.build(context);
    return CustomScaffold(
      appBar: CustomAppBar(title: string('location_filter_title')),
      body: ContentStreamBuilder(
        stream: _locationFilterBloc.listStream,
        onHasData: (LocationList data) {
          _locationList = data;
          return _buildStack(context);
        },
      ),
    );
  }

  Stack _buildStack(BuildContext context) {
    return Stack(
      children: <Widget>[
        _buildMainListView(context),
        _buildActionPositioned(context)
      ],
    );
  }

  ListView _buildMainListView(BuildContext context) {
    return ListView(
      padding: EdgeInsets.only(
          top: Dimens.default_vertical_margin, bottom: Dimens.grid(60)),
      children: <Widget>[
        Container(
          padding: EdgeInsets.symmetric(
              horizontal: Dimens.default_horizontal_margin),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              _buildCountriesDropdown(context, _locationList.countries),
              _statesDropdownStreamBuilder(),
              _citiesDropdownStreamBuilder(),
            ],
          ),
        )
      ],
    );
  }

  StreamBuilder<StreamEvent<List<LocationPart.City>>>
      _citiesDropdownStreamBuilder() {
    return StreamBuilder(
      stream: _locationFilterBloc.citiesStream,
      builder: (context,
          AsyncSnapshot<StreamEvent<List<LocationPart.City>>> snapshot) {
        return _buildCitiesDropdown(context, snapshot.data);
      },
    );
  }

  StreamBuilder<StreamEvent<List<LocationPart.State>>>
      _statesDropdownStreamBuilder() {
    return StreamBuilder(
      stream: _locationFilterBloc.statesStream,
      builder: (context,
          AsyncSnapshot<StreamEvent<List<LocationPart.State>>> snapshot) {
        return _buildStatesDropdown(context, snapshot.data);
      },
    );
  }

  Widget _buildCountriesDropdown(
      BuildContext context, List<LocationPart.Country> countries) {
    var menuItems = countries?.map((country) {
      return DropdownMenuItem(value: country, child: Text(country.name));
    })?.toList();

    return Container(
      child: ButtonTheme(
        alignedDropdown: true,
        child: DropdownButton(
          hint: Text(string('common_country')),
          isExpanded: true,
          value: countries?.firstWhere((it) {
            return it.id == _currentLocation.countryId;
          }, orElse: () => null),
          items: menuItems,
          onChanged: (LocationPart.Country country) {
            setState(() {
              _currentLocation = Location(countryId: country.id);
            });
            _locationFilterBloc.fetchStates(country.id);
          },
        ),
      ),
    );
  }

  Widget _buildStatesDropdown(BuildContext context,
      StreamEvent<List<LocationPart.State>> snapshotData) {
    var event = snapshotData ??
        StreamEvent<List<LocationPart.State>>(data: _locationList.states);

    var states = event.data;

    var hintText = event.state == StreamEventState.loading
        ? string('common_loading')
        : string('common_state');

    var menuItems = states?.map((state) {
      return DropdownMenuItem(value: state, child: Text(state.name));
    })?.toList();

    return Container(
      child: ButtonTheme(
        alignedDropdown: true,
        child: DropdownButton(
          hint: Text(hintText),
          isExpanded: true,
          value: states?.firstWhere((it) {
            return it.id == _currentLocation.stateId;
          }, orElse: () => null),
          items: menuItems,
          onChanged: (LocationPart.State state) {
            setState(() {
              _currentLocation.stateId = state.id;
              _currentLocation.cityId = null;
            });
            _locationFilterBloc.fetchCities(state.id);
          },
        ),
      ),
    );
  }

  Widget _buildCitiesDropdown(
      BuildContext context, StreamEvent<List<LocationPart.City>> snapshotData) {
    var event = snapshotData ??
        StreamEvent<List<LocationPart.City>>(data: _locationList.cities);

    var cities = event.data;

    var hintText = event.state == StreamEventState.loading
        ? string('common_loading')
        : string('common_city');

    var menuItems = cities?.map((city) {
      return DropdownMenuItem(value: city, child: Text(city.name));
    })?.toList();

    return Container(
      child: ButtonTheme(
        alignedDropdown: true,
        child: DropdownButton(
          hint: Text(hintText),
          isExpanded: true,
          value: cities?.firstWhere((it) {
            return it.id == _currentLocation.cityId;
          }, orElse: () => null),
          items: menuItems,
          onChanged: (city) {
            setState(() {
              _currentLocation.cityId = city.id;
            });
          },
        ),
      ),
    );
  }

  Positioned _buildActionPositioned(BuildContext context) {
    return Positioned(
      bottom: 0.0,
      left: 0.0,
      right: 0.0,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: <Widget>[
          Divider(
            height: 1.0,
          ),
          Container(
            color: Colors.white,
            height: 80.0,
            alignment: Alignment.center,
            child: _buildPrimaryButton(context),
          )
        ],
      ),
    );
  }

  Widget _buildPrimaryButton(BuildContext context) {
    var onPressed = _currentLocation.equals(widget.location)
        ? null
        : () {
            Navigator.pop(context, _currentLocation);
          };

    return Padding(
      padding:
          EdgeInsets.symmetric(horizontal: Dimens.default_horizontal_margin),
      child: CustomButton.primary(context,
          text: string('action_filter'), onPressed: onPressed),
    );
  }
}
