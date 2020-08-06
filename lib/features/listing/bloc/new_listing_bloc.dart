import 'dart:io';

import 'package:firebase_storage/firebase_storage.dart';
import 'package:giv_flutter/base/base_bloc_with_auth.dart';
import 'package:giv_flutter/model/image/image.dart';
import 'package:giv_flutter/model/listing/listing_image.dart';
import 'package:giv_flutter/model/listing/repository/api/request/create_listing_request.dart';
import 'package:giv_flutter/model/listing/repository/listing_repository.dart';
import 'package:giv_flutter/model/location/location.dart';
import 'package:giv_flutter/model/location/repository/location_repository.dart';
import 'package:giv_flutter/model/product/product.dart';
import 'package:giv_flutter/service/preferences/disk_storage_provider.dart';
import 'package:giv_flutter/util/data/stream_event.dart';
import 'package:giv_flutter/util/firebase/firebase_storage_util_provider.dart';
import 'package:giv_flutter/util/network/http_response.dart';
import 'package:meta/meta.dart';
import 'package:rxdart/rxdart.dart';

class NewListingBloc extends BaseBlocWithAuth {
  final ListingRepository listingRepository;
  final LocationRepository locationRepository;
  final DiskStorageProvider diskStorage;
  final PublishSubject<Location> locationPublishSubject;
  final PublishSubject<StreamEvent<double>> uploadStatusPublishSubject;
  final PublishSubject<Product> savedProductPublishSubject;
  final FirebaseStorageUtilProvider firebaseStorageUtil;

  NewListingBloc({
    @required this.locationRepository,
    @required this.listingRepository,
    @required this.diskStorage,
    @required this.locationPublishSubject,
    @required this.uploadStatusPublishSubject,
    @required this.savedProductPublishSubject,
    @required this.firebaseStorageUtil,
  }) : super(diskStorage: diskStorage);

  bool isEditing;

  List<double> _uploadProgresses = [];
  int _successfulUploadCount = 0;
  List<ListingImage> _listingImages;
  List<StorageUploadTask> _uploadTasks = [];
  List<StorageReference> _storageReferences = [];
  bool _hasSentRequest = false;
  Product _product;

  factory NewListingBloc.from(NewListingBloc bloc, bool isEditing) {
    bloc.isEditing = isEditing;
    return bloc;
  }

  Observable<Location> get locationStream => locationPublishSubject.stream;
  Observable<StreamEvent<double>> get uploadStatusStream =>
      uploadStatusPublishSubject.stream;
  Observable<Product> get savedProductStream =>
      savedProductPublishSubject.stream;

  _resetProgress() {
    _uploadProgresses = [];
    _successfulUploadCount = 0;
    _listingImages = [];
    _uploadTasks = [];
    _storageReferences = [];
    _hasSentRequest = false;
  }

  dispose() {
    locationPublishSubject.close();
    uploadStatusPublishSubject.close();
    savedProductPublishSubject.close();
  }

  Location getPreferredLocation() => diskStorage.getLocation();

  loadCompleteLocation(Location location) async {
    Location resolvedLocation;

    try {
      if (location == null) {
        resolvedLocation = diskStorage.getLocation();
      } else {
        var response = await locationRepository.getLocationDetails(location);
        if (response.status == HttpStatus.ok) resolvedLocation = response.data;
      }

      locationPublishSubject.sink.add(resolvedLocation);
    } catch (error) {
      locationPublishSubject.sink.addError(error);
    }
  }

  saveProduct(Product product) {
    _product = product;
    _handleImages(product.images);
  }

  _handleImages(List<Image> images) {
    _updateProgressStream(0.0);

    _resetProgress();
    for (var i = 0; i < images.length; i++) {
      final image = images[i];
      if (image.hasUrl)
        _listingImages.add(ListingImage(position: i, url: image.url));
      else if (image.hasFile) {
        _uploadProgresses.add(0.0);
        StorageReference ref = firebaseStorageUtil.getListingPhotoRef();
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
    uploadStatusPublishSubject.sink.add(
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

  // TODO: Find a way to determine original position of uploaded images.
  // (Makes rearranging possible.)
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
          ? await listingRepository.update(request)
          : await listingRepository.create(request);

      if (response.status == HttpStatus.created ||
          response.status == HttpStatus.ok) {
        uploadStatusPublishSubject.sink
            .add(StreamEvent<double>(state: StreamEventState.ready, data: 1.0));
        savedProductPublishSubject.sink.add(response.data);
      } else
        throw response.message;
    } catch (error) {
      savedProductPublishSubject.sink.addError(error);
    }
  }
}
