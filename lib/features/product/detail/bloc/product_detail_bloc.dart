import 'package:giv_flutter/model/location/location.dart';
import 'package:giv_flutter/model/location/repository/location_repository.dart';
import 'package:giv_flutter/util/network/http_response.dart';
import 'package:rxdart/rxdart.dart';

class ProductDetailBloc {
  final _locationRepository = LocationRepository();

  final _locationPublishSubject = PublishSubject<Location>();

  Observable<Location> get locationStream => _locationPublishSubject.stream;

  dispose() {
    _locationPublishSubject.close();
  }

  fetchLocationDetails(Location location) async {
    try {
      var response = await _locationRepository.getLocationDetails(location);
      if (response.status == HttpStatus.ok)
        _locationPublishSubject.sink.add(response.data);
      else
        _locationPublishSubject.sink.addError(response.message);
    } catch (error) {
      _locationPublishSubject.sink.addError(error);
    }
  }
}