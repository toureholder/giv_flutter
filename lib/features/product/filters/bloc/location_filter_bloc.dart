import 'package:giv_flutter/service/preferences/disk_storage_provider.dart';
import 'package:giv_flutter/model/location/location.dart';
import 'package:giv_flutter/model/location/location_list.dart';
import 'package:giv_flutter/model/location/location_part.dart';
import 'package:giv_flutter/model/location/repository/location_repository.dart';
import 'package:giv_flutter/util/data/stream_event.dart';
import 'package:giv_flutter/util/network/http_response.dart';
import 'package:rxdart/rxdart.dart';
import 'package:meta/meta.dart';

class LocationFilterBloc {
  final LocationRepository locationRepository;
  final DiskStorageProvider diskStorage;
  final BehaviorSubject<LocationList> listSubject;
  final PublishSubject<StreamEvent<List<State>>> statesSubject;
  final PublishSubject<StreamEvent<List<City>>> citiesSubject;

  LocationFilterBloc({
    @required this.locationRepository,
    @required this.diskStorage,
    @required this.listSubject,
    @required this.statesSubject,
    @required this.citiesSubject,
  });

  Observable<LocationList> get listStream => listSubject.stream;

  Observable<StreamEvent<List<State>>> get statesStream => statesSubject.stream;

  Observable<StreamEvent<List<City>>> get citiesStream => citiesSubject.stream;

  dispose() {
    listSubject.close();
    statesSubject.close();
    citiesSubject.close();
  }

  fetchLocationLists(Location location) async {
    try {
      var response = await locationRepository.getLocationList(location);
      if (response.status == HttpStatus.ok)
        listSubject.sink.add(response.data);
      else
        listSubject.sink.addError(response.message);
    } catch (error) {
      listSubject.sink.addError(error);
    }
  }

  fetchStates(String countryId) async {
    _clearStates();

    if (countryId == null) return;

    try {
      statesSubject.sink.add(StreamEvent.loading());
      var response = await locationRepository.getStates(countryId);

      if (response.status == HttpStatus.ok)
        statesSubject.sink.add(StreamEvent<List<State>>(data: response.data));
      else
        statesSubject.sink.addError(response.message);
    } catch (error) {
      statesSubject.sink.addError(error);
    }
  }

  fetchCities(String countryId, String stateId) async {
    _clearCities();

    if (stateId == null) return;

    try {
      citiesSubject.sink.add(StreamEvent.loading());
      var response = await locationRepository.getCities(countryId, stateId);

      if (response.status == HttpStatus.ok)
        citiesSubject.sink.add(StreamEvent<List<City>>(data: response.data));
      else
        citiesSubject.sink.addError(response.message);
    } catch (error) {
      citiesSubject.sink.addError(error);
    }
  }

  setLocation(Location location) => diskStorage.setLocation(location);

  _clearCities() {
    citiesSubject.sink.add(StreamEvent<List<City>>(
      state: StreamEventState.empty,
    ));
  }

  _clearStates() {
    statesSubject.sink.add(StreamEvent<List<State>>(
      state: StreamEventState.empty,
    ));

    _clearCities();
  }
}
