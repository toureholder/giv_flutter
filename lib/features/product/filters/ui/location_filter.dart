import 'package:flutter/material.dart';
import 'package:giv_flutter/base/base_state.dart';
import 'package:giv_flutter/config/preferences/prefs.dart';
import 'package:giv_flutter/features/product/filters/bloc/location_filter_bloc.dart';
import 'package:giv_flutter/model/location/location.dart';
import 'package:giv_flutter/model/location/location_list.dart';
import 'package:giv_flutter/model/location/location_part.dart' as LocationPart;
import 'package:giv_flutter/util/data/content_stream_builder.dart';
import 'package:giv_flutter/util/data/stream_event.dart';
import 'package:giv_flutter/util/presentation/buttons.dart';
import 'package:giv_flutter/util/presentation/custom_app_bar.dart';
import 'package:giv_flutter/util/presentation/custom_scaffold.dart';
import 'package:giv_flutter/util/presentation/spacing.dart';
import 'package:giv_flutter/values/dimens.dart';

class LocationFilter extends StatefulWidget {
  final Location location;
  final bool showSaveButton;

  const LocationFilter({Key key, this.location, this.showSaveButton = false})
      : super(key: key);

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
    _currentLocation = widget.location?.copy() ?? Location();
    _locationFilterBloc = LocationFilterBloc();
    _listenForErrors();
    _locationFilterBloc.fetchLocationLists(_currentLocation);
  }

  void _listenForErrors() {
    _locationFilterBloc.listStream
        .listen((event) {}, onError: _handleNetworkError);
    _locationFilterBloc.statesStream
        .listen((event) {}, onError: _handleNetworkError);
    _locationFilterBloc.citiesStream
        .listen((event) {}, onError: _handleNetworkError);
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
          return _buildMainListView(context);
        },
      ),
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
              Spacing.vertical(Dimens.grid(16)),
              _buildPrimaryButton(context)
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
    List<DropdownMenuItem<LocationPart.Country>> menuItems =
        countries?.map((country) {
      return DropdownMenuItem(value: country, child: Text(country.name));
    })?.toList();

    return Container(
      child: ButtonTheme(
        alignedDropdown: true,
        child: DropdownButton(
          hint: Text(string('common_country')),
          isExpanded: true,
          value: countries?.firstWhere((it) {
            return it.id == _currentLocation?.country?.id;
          }, orElse: () => null),
          items: menuItems,
          onChanged: (LocationPart.Country country) {
            setState(() {
              _currentLocation = country == null
                  ? Location()
                  : Location(
                      country: LocationPart.Country(
                          id: country.id, name: country.name));
            });
            _locationFilterBloc.fetchStates(country?.id);
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

    List<DropdownMenuItem<LocationPart.State>> menuItems = states?.map((state) {
      return DropdownMenuItem(value: state, child: Text(state.name));
    })?.toList();

    _addClearValueEntries<LocationPart.State>(
        menuItems, 'location_filter_all_states');

    return Container(
      child: ButtonTheme(
        alignedDropdown: true,
        child: DropdownButton(
          hint: Text(hintText),
          isExpanded: true,
          value: states?.firstWhere((it) {
            return it.id == _currentLocation?.state?.id;
          }, orElse: () => null),
          items: menuItems,
          onChanged: (LocationPart.State state) {
            setState(() {
              _currentLocation?.state = state == null
                  ? null
                  : LocationPart.State(id: state.id, name: state.name);
              _currentLocation?.city = null;
            });
            _locationFilterBloc.fetchCities(
                _currentLocation?.country?.id, state?.id);
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

    List<DropdownMenuItem<LocationPart.City>> menuItems = cities?.map((city) {
      return DropdownMenuItem(value: city, child: Text(city.name));
    })?.toList();

    _addClearValueEntries<LocationPart.City>(
        menuItems, 'location_filter_all_cities');

    return Container(
      child: ButtonTheme(
        alignedDropdown: true,
        child: DropdownButton(
          hint: Text(hintText),
          isExpanded: true,
          value: cities?.firstWhere((it) {
            return it.id == _currentLocation?.city?.id;
          }, orElse: () => null),
          items: menuItems,
          onChanged: (LocationPart.City city) {
            setState(() {
              _currentLocation?.city = city == null
                  ? null
                  : LocationPart.City(id: city.id, name: city.name);
            });
          },
        ),
      ),
    );
  }

  Widget _buildPrimaryButton(BuildContext context) {
    var onPressed = _hasChangedLocation() ? returnCurrentLocation : null;

    var res = widget.showSaveButton ? 'shared_action_save' : 'action_filter';

    return PrimaryButton(text: string(res), onPressed: onPressed);
  }

  bool _hasChangedLocation() => !_currentLocation.equals(widget.location);

  void returnCurrentLocation() async {
    await Prefs.setLocation(_currentLocation);
    Navigator.pop(context, _currentLocation);
  }

  void _handleNetworkError(error) {
    showGenericErrorDialog();
  }

  DropdownMenuItem _buildClearValueEntry<T>(String resId) =>
      DropdownMenuItem<T>(value: null, child: Text(string(resId)));

  void _addClearValueEntries<T>(
      List<DropdownMenuItem<T>> menuItems, String resId) {
    if (menuItems?.isNotEmpty ?? false) {
      final clearItem = _buildClearValueEntry<T>(resId);
      menuItems?.insert(0, clearItem);
      menuItems?.add(clearItem);
    }
  }
}
