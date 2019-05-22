import 'dart:io';

import 'package:firebase_storage/firebase_storage.dart';
import 'package:giv_flutter/config/preferences/prefs.dart';
import 'package:giv_flutter/model/image/image.dart';
import 'package:giv_flutter/model/listing/listing_image.dart';
import 'package:giv_flutter/model/listing/repository/api/request/create_listing_request.dart';
import 'package:giv_flutter/model/listing/repository/listing_repository.dart';
import 'package:giv_flutter/model/location/location.dart';
import 'package:giv_flutter/model/location/repository/location_repository.dart';
import 'package:giv_flutter/model/product/product.dart';
import 'package:giv_flutter/model/user/user.dart';
import 'package:giv_flutter/util/data/stream_event.dart';
import 'package:giv_flutter/util/firebase/firebase_storage_util.dart';
import 'package:rxdart/rxdart.dart';
import 'package:giv_flutter/util/network/http_response.dart';

class NewListingBloc {
  final bool isEditing;

  final List<double> _uploadProgresses = [];
  var _successfulUploadCount = 0;
  List<ListingImage> _listingImages;
  final List<StorageUploadTask> _uploadTasks = [];
  final List<StorageReference> _storageReferences = [];
  bool _hasSentRequest = false;
  Product _product;
  final _listingRepository = ListingRepository();
  final _locationRepository = LocationRepository();

  final _userPublishSubject = PublishSubject<NewListingBlocUser>();
  final _locationPublishSubject = PublishSubject<Location>();
  final _uploadStatusPublishSubject = PublishSubject<StreamEvent<double>>();
  final _savedProductPublishSubject = PublishSubject<Product>();

  NewListingBloc(this.isEditing);

  Observable<NewListingBlocUser> get userStream => _userPublishSubject.stream;
  Observable<Location> get locationStream => _locationPublishSubject.stream;
  Observable<StreamEvent<double>> get uploadStatusStream =>
      _uploadStatusPublishSubject.stream;
  Observable<Product> get savedProductStream =>
      _savedProductPublishSubject.stream;

  dispose() {
    _userPublishSubject.close();
    _locationPublishSubject.close();
    _uploadStatusPublishSubject.close();
    _savedProductPublishSubject.close();
  }

  loadUser({bool forceShow = false}) async {
    try {
      var user = await Prefs.getUser();
      _userPublishSubject.sink.add(NewListingBlocUser(user, forceShow));
    } catch (error) {
      _userPublishSubject.sink.addError(error);
    }
  }

  loadLocation(Location location) async {
    Location resolvedLocation;

    try {
      if (location == null) {
        resolvedLocation = await Prefs.getLocation();
      } else {
        var response = await _locationRepository.getLocationDetails(location);
        if (response.status == HttpStatus.ok) resolvedLocation = response.data;
      }
      _locationPublishSubject.sink.add(resolvedLocation);
    } catch (error) {
      _locationPublishSubject.sink.addError(error);
    }
  }

  saveProduct(Product product) {
    _product = product;
    _handleImages(product.images);
  }

  _handleImages(List<Image> images) {
    _updateProgressStream(0.0);

    _listingImages = [];
    for (var i = 0; i < images.length; i++) {
      final image = images[i];
      if (image.hasUrl)
        _listingImages.add(ListingImage(position: i, url: image.url));
      else if (image.hasFile) {
        _uploadProgresses.add(0.0);
        StorageReference ref = FirebaseStorageUtil.getListingPhotoRef();
        _storageReferences.add(ref);
        _uploadTasks.add(ref.putFile(image.file));
      }
    }

    if (_uploadTasks.isNotEmpty)
      _listenToUploadTasks();
    else
      _sendCreateRequest();
  }

  _updateProgressStream(double progress) {
    _uploadStatusPublishSubject.sink.add(
        StreamEvent<double>(state: StreamEventState.loading, data: progress));
  }

  _listenToUploadTasks() {
    for (var i = 0; i < _uploadTasks.length; i++) {
      StorageUploadTask task = _uploadTasks[i];
      task.events.listen((StorageTaskEvent event) {
        StorageTaskSnapshot snapshot = event.snapshot;

        _uploadProgresses[i] = snapshot.bytesTransferred.toDouble() /
            snapshot.totalByteCount.toDouble();

        _updateUIWithProgress(event);
      });
    }
  }

  _updateUIWithProgress(StorageTaskEvent event) async {
    final overallProgress =
        _uploadProgresses.reduce((curr, next) => curr + next) /
            _uploadProgresses.length.toDouble();

    _updateProgressStream(overallProgress);

    if (event.type == StorageTaskEventType.success) _handleSuccessfulUpload();
  }

  _handleSuccessfulUpload() async {
    _successfulUploadCount++;

    if ((_successfulUploadCount == _uploadTasks.length) && !_hasSentRequest) {
      _hasSentRequest = true;

      await _createListingImages();

      _sendCreateRequest();
    }
  }

  // TODO: Find a way to determine original position of uploaded images. (Makes rearranging possible.)
  _createListingImages() async {
    final beginAt = _listingImages.length;
    for (StorageReference ref in _storageReferences)
      await _addListImage(ref, _storageReferences.indexOf(ref) + beginAt);
  }

  _addListImage(StorageReference ref, int position) async {
    String url = await ref.getDownloadURL();
    _listingImages.add(ListingImage(position: position, url: url));
  }

  _sendCreateRequest() async {
    CreateListingRequest request = _product.toListingRequest(_listingImages);

    try {
      var response = isEditing
          ? await _listingRepository.update(request)
          : await _listingRepository.create(request);

      if (response.status == HttpStatus.created ||
          response.status == HttpStatus.ok) {
        _uploadStatusPublishSubject.sink
            .add(StreamEvent<double>(state: StreamEventState.ready, data: 1.0));
        _savedProductPublishSubject.sink.add(response.data);
      } else
        throw response.message;
    } catch (error) {
      _savedProductPublishSubject.sink.addError(error);
    }
  }
}

class NewListingBlocUser {
  final User user;
  final bool forceShow;

  NewListingBlocUser(this.user, this.forceShow);
}
