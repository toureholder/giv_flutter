import 'package:firebase_storage/firebase_storage.dart';
import 'package:giv_flutter/base/base_bloc.dart';
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
import 'package:image_picker/image_picker.dart';
import 'package:meta/meta.dart';
import 'package:rxdart/rxdart.dart';

class NewListingBloc extends BaseBloc {
  final ListingRepository listingRepository;
  final LocationRepository locationRepository;
  final DiskStorageProvider diskStorage;
  final PublishSubject<Location> locationPublishSubject;
  final PublishSubject<StreamEvent<double>> uploadStatusPublishSubject;
  final PublishSubject<Product> savedProductPublishSubject;
  final FirebaseStorageUtilProvider firebaseStorageUtil;
  final ImagePicker imagePicker;

  NewListingBloc({
    @required this.locationRepository,
    @required this.listingRepository,
    @required this.diskStorage,
    @required this.locationPublishSubject,
    @required this.uploadStatusPublishSubject,
    @required this.savedProductPublishSubject,
    @required this.firebaseStorageUtil,
    @required this.imagePicker,
  }) : super(
          diskStorage: diskStorage,
          imagePicker: imagePicker,
        );

  bool isEditing;

  List<double> _uploadProgresses = [];
  int _successfulUploadCount = 0;
  List<ListingImage> _listingImages;
  List<UploadTask> _uploadTasks = [];
  List<Reference> _storageReferences = [];
  bool _hasSentRequest = false;
  Product _product;

  factory NewListingBloc.from(NewListingBloc bloc, bool isEditing) {
    bloc.isEditing = isEditing;
    return bloc;
  }

  Stream<Location> get locationStream => locationPublishSubject.stream;
  Stream<StreamEvent<double>> get uploadStatusStream =>
      uploadStatusPublishSubject.stream;
  Stream<Product> get savedProductStream => savedProductPublishSubject.stream;

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

  Location getPreferredLocation() {
    final location = diskStorage.getLocation();
    return (location?.isComplete ?? false) ? location : null;
  }

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
        Reference ref = firebaseStorageUtil.getListingPhotoRef();
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
      UploadTask task = _uploadTasks[i];

      task.snapshotEvents.listen((TaskSnapshot snapshot) {
        _uploadProgresses[i] = snapshot.bytesTransferred.toDouble() /
            snapshot.totalBytes.toDouble();

        _updateUIWithProgress();
      });

      task.whenComplete(() => _handleSuccessfulUpload());
    }
  }

  _updateUIWithProgress() async {
    final overallProgress =
        _uploadProgresses.reduce((curr, next) => curr + next) /
            _uploadProgresses.length.toDouble();

    _updateProgressStream(overallProgress);
  }

  _handleSuccessfulUpload() async {
    _successfulUploadCount++;

    if ((_successfulUploadCount == _uploadTasks.length) && !_hasSentRequest) {
      _hasSentRequest = true;

      await _createListingImages();

      _sendCreateRequest();
    }
  }

  _createListingImages() async {
    final beginAt = _listingImages.length;
    for (Reference ref in _storageReferences)
      await _addListImage(ref, _storageReferences.indexOf(ref) + beginAt);
  }

  _addListImage(Reference ref, int position) async {
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
