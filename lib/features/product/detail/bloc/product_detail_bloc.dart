import 'package:giv_flutter/model/api_response/api_response.dart';
import 'package:giv_flutter/model/listing/repository/api/request/create_listing_request.dart';
import 'package:giv_flutter/model/listing/repository/listing_repository.dart';
import 'package:giv_flutter/model/location/location.dart';
import 'package:giv_flutter/model/location/repository/location_repository.dart';
import 'package:giv_flutter/model/product/product.dart';
import 'package:giv_flutter/util/data/stream_event.dart';
import 'package:giv_flutter/util/network/http_response.dart';
import 'package:rxdart/rxdart.dart';

class ProductDetailBloc {
  final _locationRepository = LocationRepository();
  final _listingRepository = ListingRepository();

  final _locationPublishSubject = PublishSubject<Location>();
  final _deleteListingPublishSubject =
      PublishSubject<HttpResponse<ApiModelResponse>>();
  final _updateListingPublishSubject =
      PublishSubject<HttpResponse<Product>>();
  final _loadingPublishSubject = PublishSubject<StreamEventState>();

  Observable<Location> get locationStream => _locationPublishSubject.stream;
  Observable<HttpResponse<ApiModelResponse>> get deleteListingStream =>
      _deleteListingPublishSubject.stream;
  Observable<HttpResponse<Product>> get updateListingStream =>
      _updateListingPublishSubject.stream;
  Observable<StreamEventState> get loadingStream =>
      _loadingPublishSubject.stream;

  dispose() {
    _locationPublishSubject.close();
    _deleteListingPublishSubject.close();
    _updateListingPublishSubject.close();
    _loadingPublishSubject.close();
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

  deleteListing(int id) async {
    try {
      _loadingPublishSubject.sink.add(StreamEventState.loading);
      final response = await _listingRepository.destroy(id);
      _deleteListingPublishSubject.sink.add(response);
      _loadingPublishSubject.sink.add(StreamEventState.ready);
    } catch (error) {
      _deleteListingPublishSubject.sink.addError(error);
    }
  }

  updateListing(UpdateListingActiveStatusRequest request) async {
    try {
      _loadingPublishSubject.sink.add(StreamEventState.loading);
      final response = await _listingRepository.updateActiveStatus(request);
      _updateListingPublishSubject.sink.add(response);
      _loadingPublishSubject.sink.add(StreamEventState.ready);
    } catch (error) {
      _updateListingPublishSubject.sink.addError(error);
    }
  }
}
