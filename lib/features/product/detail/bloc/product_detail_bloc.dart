import 'package:giv_flutter/model/api_response/api_response.dart';
import 'package:giv_flutter/model/listing/repository/api/request/create_listing_request.dart';
import 'package:giv_flutter/model/listing/repository/listing_repository.dart';
import 'package:giv_flutter/model/location/location.dart';
import 'package:giv_flutter/model/location/repository/location_repository.dart';
import 'package:giv_flutter/model/product/product.dart';
import 'package:giv_flutter/service/session/session_provider.dart';
import 'package:giv_flutter/util/data/stream_event.dart';
import 'package:giv_flutter/util/network/http_response.dart';
import 'package:rxdart/rxdart.dart';
import 'package:meta/meta.dart';

class ProductDetailBloc {
  final LocationRepository locationRepository;
  final ListingRepository listingRepository;
  final SessionProvider session;
  final PublishSubject<Location> locationPublishSubject;
  final PublishSubject<HttpResponse<ApiModelResponse>> deleteListingPublishSubject;
  final PublishSubject<HttpResponse<Product>> updateListingPublishSubject;
  final PublishSubject<StreamEventState> loadingPublishSubject;

  ProductDetailBloc({
    @required this.locationRepository,
    @required this.listingRepository,
    @required this.session,
    @required this.locationPublishSubject,
    @required this.deleteListingPublishSubject,
    @required this.updateListingPublishSubject,
    @required this.loadingPublishSubject,
  });

  Observable<Location> get locationStream => locationPublishSubject.stream;
  Observable<HttpResponse<ApiModelResponse>> get deleteListingStream =>
      deleteListingPublishSubject.stream;
  Observable<HttpResponse<Product>> get updateListingStream =>
      updateListingPublishSubject.stream;
  Observable<StreamEventState> get loadingStream =>
      loadingPublishSubject.stream;

  dispose() {
    locationPublishSubject.close();
    deleteListingPublishSubject.close();
    updateListingPublishSubject.close();
    loadingPublishSubject.close();
  }

  isAuthenticated() => session.isAuthenticated();

  fetchLocationDetails(Location location) async {
    try {
      var response = await locationRepository.getLocationDetails(location);
      if (response.status == HttpStatus.ok)
        locationPublishSubject.sink.add(response.data);
      else
        locationPublishSubject.sink.addError(response.message);
    } catch (error) {
      locationPublishSubject.sink.addError(error);
    }
  }

  deleteListing(int id) async {
    try {
      loadingPublishSubject.sink.add(StreamEventState.loading);
      final response = await listingRepository.destroy(id);
      deleteListingPublishSubject.sink.add(response);
      loadingPublishSubject.sink.add(StreamEventState.ready);
    } catch (error) {
      deleteListingPublishSubject.sink.addError(error);
    }
  }

  updateListing(UpdateListingActiveStatusRequest request) async {
    try {
      loadingPublishSubject.sink.add(StreamEventState.loading);
      final response = await listingRepository.updateActiveStatus(request);
      updateListingPublishSubject.sink.add(response);
      loadingPublishSubject.sink.add(StreamEventState.ready);
    } catch (error) {
      updateListingPublishSubject.sink.addError(error);
    }
  }
}
