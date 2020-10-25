import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:giv_flutter/base/base_state.dart';
import 'package:giv_flutter/features/product/filters/bloc/location_filter_bloc.dart';
import 'package:giv_flutter/features/product/filters/ui/location_filter.dart';
import 'package:giv_flutter/model/location/location.dart';
import 'package:giv_flutter/model/location/location_list.dart';
import 'package:giv_flutter/model/location/location_part.dart' as LocationPart;
import 'package:giv_flutter/util/data/content_stream_builder.dart';
import 'package:giv_flutter/util/data/stream_event.dart';
import 'package:giv_flutter/util/presentation/buttons.dart';
import 'package:giv_flutter/util/util.dart';
import 'package:mockito/mockito.dart';
import 'package:provider/provider.dart';
import 'package:rxdart/rxdart.dart';

import 'test_util/mocks.dart';
import 'test_util/test_util.dart';

main() {
  MockLocationFilterBloc mockLocationFilterBloc;
  MockNavigatorObserver mockNavigatorObserver;
  Widget testableWidget;
  TestUtil testUtil;
  BehaviorSubject<LocationList> locationListController;
  PublishSubject<StreamEvent<List<LocationPart.State>>> statesController;
  PublishSubject<StreamEvent<List<LocationPart.City>>> citiesController;

  setUp(() {
    testUtil = TestUtil();
    mockLocationFilterBloc = MockLocationFilterBloc();
    mockNavigatorObserver = MockNavigatorObserver();

    locationListController = BehaviorSubject<LocationList>();
    statesController = PublishSubject<StreamEvent<List<LocationPart.State>>>();
    citiesController = PublishSubject<StreamEvent<List<LocationPart.City>>>();

    when(mockLocationFilterBloc.listStream)
        .thenAnswer((_) => locationListController.stream);

    when(mockLocationFilterBloc.statesStream)
        .thenAnswer((_) => statesController.stream);

    when(mockLocationFilterBloc.citiesStream)
        .thenAnswer((_) => citiesController.stream);
  });

  tearDown(() {
    reset(mockNavigatorObserver);
    locationListController.close();
    statesController.close();
    citiesController.close();
  });

  Widget makeTestableWidget({Location location, bool showSaveButton = false}) =>
      testUtil.makeTestableWidget(
        subject: LocationFilter(bloc: mockLocationFilterBloc),
        dependencies: [
          Provider<LocationFilterBloc>(
            create: (_) => mockLocationFilterBloc,
          ),
          Provider<Util>(
            create: (_) => MockUtil(),
          ),
        ],
        navigatorObservers: [
          mockNavigatorObserver,
        ],
      );

  group('loads content correctly', () {
    testWidgets(
      'shows circular progress inidicator while loading',
      (WidgetTester tester) async {
        testableWidget = makeTestableWidget();
        await tester.pumpWidget(testableWidget);
        expect(find.byType(SharedLoadingState), findsOneWidget);
        expect(find.byType(SharedErrorState), findsNothing);
        expect(find.byType(LocationFilterMainListView), findsNothing);
      },
    );

    testWidgets(
      'shows main list view when data is added to stream',
      (WidgetTester tester) async {
        testableWidget = makeTestableWidget();
        await tester.pumpWidget(testableWidget);

        expect(find.byType(SharedLoadingState), findsOneWidget);
        expect(find.byType(SharedErrorState), findsNothing);
        expect(find.byType(LocationFilterMainListView), findsNothing);

        locationListController.sink.add(LocationList.fakeOnlyCountries());

        await tester.pump();

        expect(find.byType(SharedLoadingState), findsNothing);
        expect(find.byType(SharedErrorState), findsNothing);
        expect(find.byType(LocationFilterMainListView), findsOneWidget);
      },
    );

    testWidgets(
      'shows states when data is added to stream',
      (WidgetTester tester) async {
        testableWidget = makeTestableWidget();
        await tester.pumpWidget(testableWidget);

        expect(find.byType(SharedLoadingState), findsOneWidget);
        expect(find.byType(SharedErrorState), findsNothing);
        expect(find.byType(LocationFilterMainListView), findsNothing);

        locationListController.sink.add(LocationList.fakeOnlyCountries());

        await tester.pump();

        statesController.sink.add(StreamEvent.loading());

        await tester.pump();

        final dropdownButtonType = DropdownButton<LocationPart.State>(
          onChanged: null,
          items: [],
        ).runtimeType;

        final loadingStatesStateFinder = find.ancestor(
            of: testUtil.findInternationalizedText('common_loading'),
            matching: find.byType(dropdownButtonType));

        expect(loadingStatesStateFinder, findsOneWidget);

        final fakeState = LocationPart.State(id: '1', name: 'Some state');
        final datEvent =
            StreamEvent<List<LocationPart.State>>(data: [fakeState]);

        statesController.sink.add(datEvent);

        await tester.pump();

        await tester.tap(find.byType(dropdownButtonType));

        await tester.pump();

        final dropdownMenuItemType = DropdownMenuItem<LocationPart.State>(
          child: Text(''),
        ).runtimeType;

        final menuItemFinder = find.ancestor(
            of: find.text(fakeState.name),
            matching: find.byType(dropdownMenuItemType));

        expect(menuItemFinder, findsOneWidget);
      },
    );

    testWidgets(
      'shows cities when data is added to stream',
      (WidgetTester tester) async {
        testableWidget = makeTestableWidget();
        await tester.pumpWidget(testableWidget);

        expect(find.byType(SharedLoadingState), findsOneWidget);
        expect(find.byType(SharedErrorState), findsNothing);
        expect(find.byType(LocationFilterMainListView), findsNothing);

        locationListController.sink.add(LocationList.fakeCountriesAndStates());

        await tester.pump();

        citiesController.sink.add(StreamEvent.loading());

        await tester.pump();

        final dropdownButtonType = DropdownButton<LocationPart.City>(
          onChanged: null,
          items: [],
        ).runtimeType;

        final loadingCitiesStateFinder = find.ancestor(
            of: testUtil.findInternationalizedText('common_loading'),
            matching: find.byType(dropdownButtonType));

        expect(loadingCitiesStateFinder, findsOneWidget);

        final fakeCity = LocationPart.City(id: '1', name: 'Some city');
        final datEvent = StreamEvent<List<LocationPart.City>>(data: [fakeCity]);

        citiesController.sink.add(datEvent);

        await tester.pump();

        await tester.tap(find.byType(dropdownButtonType));

        await tester.pump();

        final dropdownMenuItemType = DropdownMenuItem<LocationPart.City>(
          child: Text(''),
        ).runtimeType;

        final menuItemFinder = find.ancestor(
            of: find.text(fakeCity.name),
            matching: find.byType(dropdownMenuItemType));

        expect(menuItemFinder, findsOneWidget);
      },
    );

    testWidgets(
      'displays location list data',
      (WidgetTester tester) async {
        final location = Location.fake();
        final countryId = location.country.id;
        final countryName = location.country.name;
        final stateId = location.state.id;
        final stateName = location.state.name;

        testableWidget = makeTestableWidget(location: location);
        await tester.pumpWidget(testableWidget);

        final locationList = LocationList(
          countries: [
            LocationPart.Country(id: '1', name: 'Barbados'),
            LocationPart.Country(id: countryId, name: countryName),
          ],
          states: [
            LocationPart.State(id: '1', name: 'Acre'),
            LocationPart.State(id: stateId, name: stateName),
          ],
          cities: [LocationPart.City(id: '1', name: 'City on a hill')],
        );

        locationListController.sink.add(locationList);

        await tester.pump();

        expect(find.text(location.country.name), findsOneWidget);
        expect(find.text(location.state.name), findsOneWidget);
        expect(testUtil.findInternationalizedText('location_filter_all_cities'),
            findsNWidgets(2));
      },
    );

    testWidgets(
      'shows error dialog when error is added to stream',
      (WidgetTester tester) async {
        testableWidget = makeTestableWidget();
        await tester.pumpWidget(testableWidget);

        expect(find.byType(SharedLoadingState), findsOneWidget);
        expect(find.byType(SharedErrorState), findsNothing);
        expect(find.byType(LocationFilterMainListView), findsNothing);

        locationListController.sink.addError('some error');

        await tester.pump();

        expect(find.byType(SharedLoadingState), findsNothing);
        expect(find.byType(SharedErrorState), findsOneWidget);
        expect(find.byType(LocationFilterMainListView), findsNothing);
        expect(find.byType(GenericErrorDialog), findsOneWidget);
      },
    );
  });

  group('selections work as expected', () {
    testWidgets(
      'loads states when a country is selected',
      (WidgetTester tester) async {
        testableWidget = makeTestableWidget();
        await tester.pumpWidget(testableWidget);

        final locationList = LocationList.fakeOnlyCountries();

        locationListController.sink.add(locationList);

        final firstCountry = locationList.countries[0];

        await tester.pump();

        final dropdownButtonType = DropdownButton<LocationPart.Country>(
          onChanged: null,
          items: [],
        ).runtimeType;

        final dropdownMenuItemType = DropdownMenuItem<LocationPart.Country>(
          child: Text(''),
        ).runtimeType;

        await tester.tap(find.byType(dropdownButtonType));

        await tester.pump();

        final menuItemFinder = find
            .ancestor(
                of: find.text(firstCountry.name),
                matching: find.byType(dropdownMenuItemType))
            .last;

        await tester.tap(menuItemFinder);

        verify(mockLocationFilterBloc.fetchStates(any)).called(1);
      },
    );

    testWidgets(
      'loads cities when a state is selected',
      (WidgetTester tester) async {
        testableWidget = makeTestableWidget();
        await tester.pumpWidget(testableWidget);

        final locationList = LocationList.fakeCountriesAndStates();

        locationListController.sink.add(locationList);

        final firstState = locationList.states[0];

        await tester.pump();

        final dropdownButtonType = DropdownButton<LocationPart.State>(
          onChanged: null,
          items: [],
        ).runtimeType;

        final dropdownMenuItemType = DropdownMenuItem<LocationPart.State>(
          child: Text(''),
        ).runtimeType;

        await tester.tap(find.byType(dropdownButtonType));

        await tester.pump();

        final menuItemFinder = find
            .ancestor(
                of: find.text(firstState.name),
                matching: find.byType(dropdownMenuItemType))
            .last;

        await tester.tap(menuItemFinder);

        verify(mockLocationFilterBloc.fetchCities(any, any)).called(1);
      },
    );

    testWidgets(
      'selects city',
      (WidgetTester tester) async {
        testableWidget = makeTestableWidget();
        await tester.pumpWidget(testableWidget);

        final locationList = LocationList.fake();

        locationListController.sink.add(locationList);

        final firstCity = locationList.cities[0];

        await tester.pump();

        final dropdownButtonType = DropdownButton<LocationPart.City>(
          onChanged: null,
          items: [],
        ).runtimeType;

        final dropdownMenuItemType = DropdownMenuItem<LocationPart.City>(
          child: Text(''),
        ).runtimeType;

        await tester.tap(find.byType(dropdownButtonType));

        await tester.pump();

        final menuItemFinder = find
            .ancestor(
                of: find.text(firstCity.name),
                matching: find.byType(dropdownMenuItemType))
            .last;

        await tester.tap(menuItemFinder);
      },
    );
  });

  group('primary button', () {
    testWidgets(
      'saves set location to preferences',
      (WidgetTester tester) async {
        testableWidget = makeTestableWidget();
        await tester.pumpWidget(testableWidget);

        final locationList = LocationList.fake();

        locationListController.sink.add(locationList);

        final firstCity = locationList.cities[0];

        await tester.pump();

        final dropdownButtonType = DropdownButton<LocationPart.City>(
          onChanged: null,
          items: [],
        ).runtimeType;

        final dropdownMenuItemType = DropdownMenuItem<LocationPart.City>(
          child: Text(''),
        ).runtimeType;

        await tester.tap(find.byType(dropdownButtonType));

        await tester.pump();

        final menuItemFinder = find
            .ancestor(
                of: find.text(firstCity.name),
                matching: find.byType(dropdownMenuItemType))
            .last;

        await tester.tap(menuItemFinder);

        await tester.pump();

        await tester.tap(find.byType(PrimaryButton));

        verify(mockLocationFilterBloc.setLocation(any)).called(1);
      },
    );
  });
}
