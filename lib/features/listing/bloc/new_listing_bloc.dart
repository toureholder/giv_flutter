import 'package:giv_flutter/config/preferences/prefs.dart';
import 'package:giv_flutter/model/location/location.dart';
import 'package:giv_flutter/model/product/product.dart';
import 'package:giv_flutter/model/user/user.dart';
import 'package:giv_flutter/util/data/stream_event.dart';
import 'package:rxdart/rxdart.dart';

class NewListingBloc {
  final _userPublishSubject = PublishSubject<NewListingBlocUser>();
  final _locationPublishSubject = PublishSubject<Location>();
  final _uploadStatusPublishSubject = PublishSubject<StreamEvent<double>>();

  Observable<NewListingBlocUser> get userStream => _userPublishSubject.stream;
  Observable<Location> get locationStream => _locationPublishSubject.stream;
  Observable<StreamEvent<double>> get uploadStatusStream =>
      _uploadStatusPublishSubject.stream;

  dispose() {
    _userPublishSubject.close();
    _locationPublishSubject.close();
    _uploadStatusPublishSubject.close();
  }

  loadUser({bool forceShow = false}) async {
    try {
      var user = await Prefs.getUser();
      _userPublishSubject.sink.add(NewListingBlocUser(user, forceShow));
    } catch (error) {
      _userPublishSubject.sink.addError(error);
    }
  }

  loadLocation() async {
    try {
      var location = await Prefs.getLocation();
      _locationPublishSubject.sink.add(location);
    } catch (error) {
      _locationPublishSubject.sink.addError(error);
    }
  }

  upload(Product product) async {
    try {
      _uploadStatusPublishSubject.sink
          .add(StreamEvent<double>(state: StreamEventState.loading, data: 0.0));
      await Future.delayed(Duration(seconds: 2));
      _uploadStatusPublishSubject.sink
          .add(StreamEvent<double>(state: StreamEventState.loading, data: 0.1));
      await Future.delayed(Duration(seconds: 1));
      _uploadStatusPublishSubject.sink
          .add(StreamEvent<double>(state: StreamEventState.loading, data: 0.2));
      await Future.delayed(Duration(seconds: 1));
      _uploadStatusPublishSubject.sink
          .add(StreamEvent<double>(state: StreamEventState.loading, data: 0.3));
      await Future.delayed(Duration(seconds: 1));
      _uploadStatusPublishSubject.sink
          .add(StreamEvent<double>(state: StreamEventState.loading, data: 0.4));
      await Future.delayed(Duration(seconds: 1));
      _uploadStatusPublishSubject.sink
          .add(StreamEvent<double>(state: StreamEventState.loading, data: 0.5));
      await Future.delayed(Duration(seconds: 1));
      _uploadStatusPublishSubject.sink
          .add(StreamEvent<double>(state: StreamEventState.loading, data: 0.6));
      await Future.delayed(Duration(seconds: 1));
      _uploadStatusPublishSubject.sink
          .add(StreamEvent<double>(state: StreamEventState.loading, data: 0.7));
      await Future.delayed(Duration(seconds: 1));
      _uploadStatusPublishSubject.sink
          .add(StreamEvent<double>(state: StreamEventState.loading, data: 0.8));
      await Future.delayed(Duration(seconds: 1));
      _uploadStatusPublishSubject.sink
          .add(StreamEvent<double>(state: StreamEventState.loading, data: 0.9));
      await Future.delayed(Duration(seconds: 1));
      _uploadStatusPublishSubject.sink
          .add(StreamEvent<double>(state: StreamEventState.loading, data: 1.0));
      await Future.delayed(Duration(seconds: 1));
      _uploadStatusPublishSubject.sink
          .add(StreamEvent<double>(state: StreamEventState.ready, data: 1.0));
    } catch (error) {
      _uploadStatusPublishSubject.sink.addError(error);
    }
  }
}

class NewListingBlocUser {
  final User user;
  final bool forceShow;

  NewListingBlocUser(this.user, this.forceShow);
}
