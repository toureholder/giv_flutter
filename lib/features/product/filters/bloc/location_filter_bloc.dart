import 'package:giv_flutter/model/location/location.dart';
import 'package:giv_flutter/model/location/location_list.dart';
import 'package:giv_flutter/model/location/location_part.dart';
import 'package:giv_flutter/model/location/repository/location_repository.dart';
import 'package:giv_flutter/util/data/stream_event.dart';
import 'package:rxdart/rxdart.dart';

class LocationFilterBloc {
  final _locationRepository = LocationRepository();

  final _listPublishSubject = PublishSubject<LocationList>();
  final _statesPublishSubject = PublishSubject<StreamEvent<List<State>>>();
  final _citiesPublishSubject = PublishSubject<StreamEvent<List<City>>>();

  Observable<LocationList> get listStream => _listPublishSubject.stream;

  Observable<StreamEvent<List<State>>> get statesStream =>
      _statesPublishSubject.stream;

  Observable<StreamEvent<List<City>>> get citiesStream =>
      _citiesPublishSubject.stream;

  dispose() {
    _listPublishSubject.close();
    _statesPublishSubject.close();
    _citiesPublishSubject.close();
  }

  fetchLocationLists(Location location) async {
    try {
      var list = await _locationRepository.getLocationList(location);
      _listPublishSubject.sink.add(list);
    } catch (error) {
      _listPublishSubject.sink.addError(error);
    }
  }

  fetchStates(String countryId) async {
    try {
      _clearCities();
      _statesPublishSubject.sink.add(StreamEvent.loading());
      var states = await _locationRepository.getStates(countryId);
      _statesPublishSubject.sink.add(StreamEvent<List<State>>(data: states));
    } catch (error) {
      _statesPublishSubject.sink.addError(error);
    }
  }

  fetchCities(String stateId) async {
    try {
      _clearCities();
      _citiesPublishSubject.sink.add(StreamEvent.loading());
      var cities = await _locationRepository.getCities(stateId);
      _citiesPublishSubject.sink.add(StreamEvent<List<City>>(data: cities));
    } catch (error) {
      _citiesPublishSubject.sink.addError(error);
    }
  }

  _clearCities() {
    _citiesPublishSubject.sink.add(StreamEvent<List<City>>(
      state: StreamEventState.empty,
    ));
  }
}
