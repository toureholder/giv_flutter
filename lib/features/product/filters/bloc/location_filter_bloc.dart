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

  final _listPublishSubject = PublishSubject<LocationList>();
  final _statesPublishSubject = PublishSubject<StreamEvent<List<State>>>();
  final _citiesPublishSubject = PublishSubject<StreamEvent<List<City>>>();

  LocationFilterBloc({
    @required this.locationRepository,
    @required this.diskStorage,
  });

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
      var response = await locationRepository.getLocationList(location);
      if (response.status == HttpStatus.ok)
        _listPublishSubject.sink.add(response.data);
      else
        _listPublishSubject.sink.addError(response.message);
    } catch (error) {
      _listPublishSubject.sink.addError(error);
    }
  }

  fetchStates(String countryId) async {
    _clearStates();

    if (countryId == null) return;

    try {
      _statesPublishSubject.sink.add(StreamEvent.loading());
      var response = await locationRepository.getStates(countryId);

      if (response.status == HttpStatus.ok)
        _statesPublishSubject.sink
            .add(StreamEvent<List<State>>(data: response.data));
      else
        _statesPublishSubject.sink.addError(response.message);
    } catch (error) {
      _statesPublishSubject.sink.addError(error);
    }
  }

  fetchCities(String countryId, String stateId) async {
    _clearCities();

    if (stateId == null) return;

    try {
      _citiesPublishSubject.sink.add(StreamEvent.loading());
      var response = await locationRepository.getCities(countryId, stateId);

      if (response.status == HttpStatus.ok)
        _citiesPublishSubject.sink
            .add(StreamEvent<List<City>>(data: response.data));
      else
        _citiesPublishSubject.sink.addError(response.message);
    } catch (error) {
      _citiesPublishSubject.sink.addError(error);
    }
  }

  setLocation(Location location) => diskStorage.setLocation(location);

  _clearCities() {
    _citiesPublishSubject.sink.add(StreamEvent<List<City>>(
      state: StreamEventState.empty,
    ));
  }

  _clearStates() {
    _statesPublishSubject.sink.add(StreamEvent<List<State>>(
      state: StreamEventState.empty,
    ));

    _clearCities();
  }
}
