import 'package:flutter/material.dart';
import 'package:giv_flutter/base/base_state.dart';
import 'package:giv_flutter/config/i18n/string_localizations.dart';
import 'package:giv_flutter/features/product/filters/bloc/location_filter_bloc.dart';
import 'package:giv_flutter/features/product/filters/ui/location_filter_help.dart';
import 'package:giv_flutter/model/listing/listing_type.dart';
import 'package:giv_flutter/model/location/location.dart';
import 'package:giv_flutter/model/location/location_list.dart';
import 'package:giv_flutter/model/location/location_part.dart' as LocationPart;
import 'package:giv_flutter/util/data/content_stream_builder.dart';
import 'package:giv_flutter/util/data/stream_event.dart';
import 'package:giv_flutter/util/presentation/buttons.dart';
import 'package:giv_flutter/util/presentation/custom_app_bar.dart';
import 'package:giv_flutter/util/presentation/custom_dropdown_button_underline.dart';
import 'package:giv_flutter/util/presentation/custom_scaffold.dart';
import 'package:giv_flutter/util/presentation/spacing.dart';
import 'package:giv_flutter/util/presentation/typography.dart';
import 'package:giv_flutter/values/dimens.dart';

class LocationFilter extends StatefulWidget {
  final Location location;
  final bool showSaveButton;
  final LocationFilterBloc bloc;
  final ListingType listingType;
  final bool requireCompleteLocation;
  final Widget redirect;
  final bool showHelpWdiget;
  final String locationFilterText;

  const LocationFilter({
    Key key,
    @required this.bloc,
    this.location,
    this.showSaveButton = false,
    this.listingType,
    @required this.requireCompleteLocation,
    this.redirect,
    this.showHelpWdiget = false,
    this.locationFilterText,
  }) : super(key: key);

  @override
  _LocationFilterState createState() => _LocationFilterState();
}

class _LocationFilterState extends BaseState<LocationFilter> {
  LocationFilterBloc _locationFilterBloc;
  LocationList _locationList;
  Location _currentLocation;
  ListingType _listingType;
  bool _isCountryError = false;
  bool _isStateError = false;
  bool _isCityError = false;
  bool _isValidating = false;
  bool _showHelpWdiget;
  Widget _redirect;
  ScrollController _listViewController = ScrollController();

  @override
  void initState() {
    super.initState();
    _showHelpWdiget = widget.showHelpWdiget;
    _redirect = widget.redirect;
    _locationFilterBloc = widget.bloc;
    _listingType = widget.listingType;
    _currentLocation = widget.location?.copy() ??
        _locationFilterBloc.getLocation() ??
        Location();
    _listenForErrors();
    _locationFilterBloc.fetchLocationLists(_currentLocation);
  }

  void _listenForErrors() {
    _locationFilterBloc.listStream
        ?.listen((event) {}, onError: _handleNetworkError);
    _locationFilterBloc.statesStream
        ?.listen((event) {}, onError: _handleNetworkError);
    _locationFilterBloc.citiesStream
        ?.listen((event) {}, onError: _handleNetworkError);
  }

  @override
  Widget build(BuildContext context) {
    super.build(context);

    final title = _showHelpWdiget ? '' : string('location_filter_title');

    return CustomScaffold(
      appBar: CustomAppBar(title: title),
      body: ContentStreamBuilder(
        stream: _locationFilterBloc.listStream,
        onHasData: (LocationList data) {
          _locationList = data;
          return _buildMainListView();
        },
      ),
    );
  }

  Widget _buildMainListView() {
    return LocationFilterMainListView(
      controller: _listViewController,
      children: <Widget>[
        if (_showHelpWdiget)
          LocationFilterHelp(
            text: widget.locationFilterText,
          ),
        _buildCountriesDropdown(
          context,
          _locationList.countries,
          _isCountryError,
        ),
        _statesDropdownStreamBuilder(),
        _citiesDropdownStreamBuilder(),
        Spacing.vertical(Dimens.grid(16)),
        _buildPrimaryButton(context),
        DefaultVerticalSpacingAndAHalf(),
        LocationFilterHelpButton(
          onPressed: _requestHelp,
        ),
      ],
    );
  }

  StreamBuilder<StreamEvent<List<LocationPart.City>>>
      _citiesDropdownStreamBuilder() {
    return StreamBuilder(
      stream: _locationFilterBloc.citiesStream,
      builder: (context,
          AsyncSnapshot<StreamEvent<List<LocationPart.City>>> snapshot) {
        return _buildCitiesDropdown(
          context,
          snapshot.data,
          _isCityError,
        );
      },
    );
  }

  StreamBuilder<StreamEvent<List<LocationPart.State>>>
      _statesDropdownStreamBuilder() {
    return StreamBuilder(
      stream: _locationFilterBloc.statesStream,
      builder: (context,
          AsyncSnapshot<StreamEvent<List<LocationPart.State>>> snapshot) {
        return _buildStatesDropdown(
          context,
          snapshot.data,
          _isStateError,
        );
      },
    );
  }

  Widget _buildCountriesDropdown(
    BuildContext context,
    List<LocationPart.Country> countries,
    bool isError,
  ) {
    final menuItems = countries?.map((country) {
      return DropdownMenuItem(value: country, child: Text(country.name));
    })?.toList();

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        CountryDropdownButton(
          value: countries?.firstWhere(
            (it) {
              return it.id == _currentLocation?.country?.id;
            },
            orElse: () => null,
          ),
          menuItems: menuItems,
          onChanged: _onCountryChanged,
          isError: isError,
        ),
        LocationFilterErrorMessage(
          text: 'location_filter_error_country_required',
          show: isError,
        ),
      ],
    );
  }

  void _onCountryChanged(LocationPart.Country country) {
    setState(() {
      _currentLocation = Location(
        country: LocationPart.Country(id: country.id, name: country.name),
      );
    });

    _onLocationChanged();

    _locationFilterBloc.fetchStates(country?.id);
  }

  Widget _buildStatesDropdown(
    BuildContext context,
    StreamEvent<List<LocationPart.State>> snapshotData,
    bool isError,
  ) {
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

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        ButtonTheme(
          alignedDropdown: true,
          child: DropdownButton(
            underline: CustomDropDownButtonUnderline(
              isError: isError,
            ),
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

              _onLocationChanged();

              _locationFilterBloc.fetchCities(
                  _currentLocation?.country?.id, state?.id);
            },
          ),
        ),
        LocationFilterErrorMessage(
          text: 'location_filter_error_state_required',
          show: isError,
        ),
      ],
    );
  }

  Widget _buildCitiesDropdown(
    BuildContext context,
    StreamEvent<List<LocationPart.City>> snapshotData,
    bool isError,
  ) {
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

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        ButtonTheme(
          alignedDropdown: true,
          child: DropdownButton(
            underline: CustomDropDownButtonUnderline(isError: isError),
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

              _onLocationChanged();
            },
          ),
        ),
        LocationFilterErrorMessage(
          text: 'location_filter_error_city_required',
          show: isError,
        ),
      ],
    );
  }

  Widget _buildPrimaryButton(BuildContext context) {
    var onPressed = _hasChangedLocation() ? _onPrimaryButtonPressed : null;

    var res = widget.showSaveButton
        ? 'shared_action_save'
        : _redirect == null
            ? 'action_filter'
            : 'action_continue';

    return (_listingType == ListingType.donationRequest)
        ? AccentButton(
            text: string(res),
            onPressed: onPressed,
          )
        : PrimaryButton(
            text: string(res),
            onPressed: onPressed,
          );
  }

  bool _hasChangedLocation() => !_currentLocation.equals(widget.location);

  bool _isLocationValid() {
    _isValidating = widget.requireCompleteLocation;
    _onLocationChanged();
    return _isValidating ? _currentLocation.isComplete : true;
  }

  void _onLocationChanged() {
    _scrollDownSome();

    if (!_isValidating) {
      return;
    }

    setState(() {
      _isCountryError = _currentLocation.country == null ||
          !_currentLocation.country.isFilledIn;
      _isStateError =
          _currentLocation.state == null || !_currentLocation.state.isFilledIn;
      _isCityError =
          _currentLocation.city == null || !_currentLocation.city.isFilledIn;
    });
  }

  void _onPrimaryButtonPressed() async {
    if (!_isLocationValid()) {
      return;
    }

    await _locationFilterBloc.setLocation(_currentLocation);

    if (_redirect != null) {
      navigation.pushReplacement(_redirect);
    } else {
      Navigator.pop(context, _currentLocation);
    }
  }

  void _requestHelp() {
    handleCustomerServiceRequest(
      string('location_filter_help_me_chat_message'),
    );
  }

  void _handleNetworkError(error) {
    showGenericErrorDialog();
  }

  void _scrollDownSome() {
    final scrollPosition = _listViewController.position.pixels;
    final screenHeight = MediaQuery.of(context).size.height;

    if (_showHelpWdiget && screenHeight < 641.0 && scrollPosition < 36.0) {
      _listViewController.animateTo(
        208.0,
        duration: Duration(milliseconds: 500),
        curve: Curves.easeOut,
      );
    }
  }

  DropdownMenuItem _buildClearValueEntry<T>(String resId) =>
      DropdownMenuItem<T>(value: null, child: Text(string(resId)));

  void _addClearValueEntries<T>(
      List<DropdownMenuItem<T>> menuItems, String resId) {
    if (menuItems?.isNotEmpty ?? false) {
      final clearItem = _buildClearValueEntry<T>(resId);
      menuItems?.insert(0, clearItem);
    }
  }
}

class LocationFilterErrorMessage extends StatelessWidget {
  final String text;
  final bool show;

  const LocationFilterErrorMessage({
    Key key,
    @required this.text,
    @required this.show,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return show
        ? Padding(
            padding: const EdgeInsets.only(left: 16.0, bottom: 16.0),
            child: Body2Text(
              GetLocalizedStringFunction(context)(text),
              color: Colors.red,
            ),
          )
        : SizedBox();
  }
}

class LocationFilterMainListView extends StatelessWidget {
  final List<Widget> children;
  final ScrollController controller;

  const LocationFilterMainListView({
    Key key,
    @required this.children,
    @required this.controller,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ListView(
      controller: controller,
      padding: EdgeInsets.only(
        top: Dimens.default_vertical_margin,
        bottom: Dimens.grid(60),
      ),
      children: <Widget>[
        Container(
          padding: EdgeInsets.symmetric(
            horizontal: Dimens.default_horizontal_margin,
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: children,
          ),
        ),
      ],
    );
  }
}

class CountryDropdownButton extends StatelessWidget {
  final ValueChanged<LocationPart.Country> onChanged;
  final List<DropdownMenuItem<LocationPart.Country>> menuItems;
  final LocationPart.Country value;
  final bool isError;

  const CountryDropdownButton({
    Key key,
    @required this.onChanged,
    @required this.menuItems,
    @required this.value,
    @required this.isError,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      child: ButtonTheme(
        alignedDropdown: true,
        child: DropdownButton<LocationPart.Country>(
          underline: CustomDropDownButtonUnderline(
            isError: isError,
          ),
          hint: Text(GetLocalizedStringFunction(context)('common_country')),
          isExpanded: true,
          value: value,
          items: menuItems,
          onChanged: onChanged,
        ),
      ),
    );
  }
}

class LocationFilterHelpButton extends StatelessWidget {
  final VoidCallback onPressed;

  const LocationFilterHelpButton({
    Key key,
    @required this.onPressed,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Center(
      child: TextFlatButton(
        text: GetLocalizedStringFunction(context)(
          'location_filter_help_me',
        ),
        onPressed: onPressed,
      ),
    );
  }
}
