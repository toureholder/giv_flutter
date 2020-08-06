import 'dart:async';
import 'dart:io';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_facebook_login/flutter_facebook_login.dart';
import 'package:giv_flutter/config/i18n/string_localizations.dart';
import 'package:giv_flutter/features/force_update/bloc/force_update_bloc.dart';
import 'package:giv_flutter/features/groups/create_group/bloc/create_group_bloc.dart';
import 'package:giv_flutter/features/groups/edit_group/bloc/edit_group_bloc.dart';
import 'package:giv_flutter/features/groups/group_detail/bloc/group_detail_bloc.dart';
import 'package:giv_flutter/features/groups/group_information/bloc/group_information_bloc.dart';
import 'package:giv_flutter/features/groups/join_group/bloc/join_group_bloc.dart';
import 'package:giv_flutter/features/groups/my_groups/bloc/my_groups_bloc.dart';
import 'package:giv_flutter/features/home/bloc/home_bloc.dart';
import 'package:giv_flutter/features/home/ui/home.dart';
import 'package:giv_flutter/features/listing/bloc/my_listings_bloc.dart';
import 'package:giv_flutter/features/listing/bloc/new_listing_bloc.dart';
import 'package:giv_flutter/features/log_in/bloc/log_in_bloc.dart';
import 'package:giv_flutter/features/product/categories/bloc/categories_bloc.dart';
import 'package:giv_flutter/features/product/detail/bloc/product_detail_bloc.dart';
import 'package:giv_flutter/features/product/filters/bloc/location_filter_bloc.dart';
import 'package:giv_flutter/features/product/search_result/bloc/search_result_bloc.dart';
import 'package:giv_flutter/features/settings/bloc/settings_bloc.dart';
import 'package:giv_flutter/features/sign_up/bloc/sign_up_bloc.dart';
import 'package:giv_flutter/features/splash/bloc/splash_bloc.dart';
import 'package:giv_flutter/features/user_profile/bloc/user_profile_bloc.dart';
import 'package:giv_flutter/model/api_response/api_response.dart';
import 'package:giv_flutter/model/app_config/repository/api/app_config_api.dart';
import 'package:giv_flutter/model/app_config/repository/app_config_repository.dart';
import 'package:giv_flutter/model/authenticated_user_updated_action.dart';
import 'package:giv_flutter/model/carousel/repository/api/carousel_api.dart';
import 'package:giv_flutter/model/carousel/repository/carousel_repository.dart';
import 'package:giv_flutter/model/group/group.dart';
import 'package:giv_flutter/model/group/repository/api/group_api.dart';
import 'package:giv_flutter/model/group/repository/group_repository.dart';
import 'package:giv_flutter/model/group_membership/group_membership.dart';
import 'package:giv_flutter/model/group_updated_action.dart';
import 'package:giv_flutter/model/group_membership/repository/api/group_membership_api.dart';
import 'package:giv_flutter/model/group_membership/repository/group_membership_repository.dart';
import 'package:giv_flutter/model/listing/repository/api/listing_api.dart';
import 'package:giv_flutter/model/listing/repository/listing_repository.dart';
import 'package:giv_flutter/model/location/location.dart';
import 'package:giv_flutter/model/location/repository/api/location_api.dart';
import 'package:giv_flutter/model/location/repository/cache/location_cache.dart';
import 'package:giv_flutter/model/location/repository/location_repository.dart';
import 'package:giv_flutter/model/product/product.dart';
import 'package:giv_flutter/model/product/repository/api/product_api.dart';
import 'package:giv_flutter/model/product/repository/cache/product_cache.dart';
import 'package:giv_flutter/model/product/repository/product_repository.dart';
import 'package:giv_flutter/model/user/repository/api/user_api.dart';
import 'package:giv_flutter/model/user/repository/user_repository.dart';
import 'package:giv_flutter/service/preferences/disk_storage_provider.dart';
import 'package:giv_flutter/service/session/session_provider.dart';
import 'package:giv_flutter/util/data/stream_event.dart';
import 'package:giv_flutter/util/firebase/firebase_storage_util_provider.dart';
import 'package:giv_flutter/util/network/http_client_wrapper.dart';
import 'package:giv_flutter/util/network/http_response.dart';
import 'package:giv_flutter/util/util.dart';
import 'package:hive/hive.dart';
import 'package:http/http.dart';
import 'package:mockito/mockito.dart';
import 'package:rxdart/rxdart.dart';
import 'package:shared_preferences/shared_preferences.dart';

// Miscellaneous

class MockClient extends Mock implements HttpClientWrapper {}

class MockDiskStorageProvider extends Mock implements DiskStorageProvider {}

class MockFacebookLogin extends Mock implements FacebookLogin {}

class MockFirebaseAuth extends Mock implements FirebaseAuth {}

class MockGetLocalizedStringFunction extends Mock
    implements GetLocalizedStringFunction {}

class MockHttp extends Mock implements Client {}

class MockNavigatorObserver extends Mock implements NavigatorObserver {}

class MockSharedPreferences extends Mock implements SharedPreferences {}

class MockSessionProvider extends Mock implements SessionProvider {}

class MockUtil extends Mock implements Util {}

class MockHomeListener extends Mock implements HomeListener {}

class MockFile extends Mock implements File {}

class MockBuildContext extends Mock implements BuildContext {}

// Firebase storage

class MockFirebaseStorageUtilProvider extends Mock
    implements FirebaseStorageUtilProvider {}

class MockFirebaseStorage extends Mock implements FirebaseStorage {}

class MockStorageReference extends Mock implements StorageReference {}

class MockStorageUploadTask extends Mock implements StorageUploadTask {}

class MockStorageTaskEventStream extends Mock
    implements Stream<StorageTaskEvent> {}

class MockStorageTaskEvent extends Mock implements StorageTaskEvent {}

class MockSuccessStorageTaskEvent extends Mock implements StorageTaskEvent {
  @override
  StorageTaskEventType get type => StorageTaskEventType.success;
}

class MockStorageTaskSnapshot extends Mock implements StorageTaskSnapshot {}

// Mock APIs

class MockAppConfigApi extends Mock implements AppConfigApi {}

class MockCarouselApi extends Mock implements CarouselApi {}

class MockListingApi extends Mock implements ListingApi {}

class MockLocationApi extends Mock implements LocationApi {}

class MockProductApi extends Mock implements ProductApi {}

class MockUserApi extends Mock implements UserApi {}

class MockGroupMembershipApi extends Mock implements GroupMembershipApi {}

class MockGroupApi extends Mock implements GroupApi {}

// Mock Repositories

class MockAppConfigRepository extends Mock implements AppConfigRepository {}

class MockCarouselRepository extends Mock implements CarouselRepository {}

class MockListingRepository extends Mock implements ListingRepository {}

class MockLocationRepository extends Mock implements LocationRepository {}

class MockProductRepository extends Mock implements ProductRepository {}

class MockUserRepository extends Mock implements UserRepository {}

class MockGroupMembershipRepository extends Mock
    implements GroupMembershipRepository {}

class MockGroupRepository extends Mock implements GroupRepository {}

// Mock Boxes
class MockGroupMembershipsBox extends Mock implements Box<GroupMembership> {}

class MockGroupsBox extends Mock implements Box<Group> {}

// Mock ChangeNotifiers
class MockGroupUpdatedAction extends Mock implements GroupUpdatedAction {}

class MockAuthUserUpdatedAction extends Mock implements AuthUserUpdatedAction {}

// Mock Caches

class MockLocationCache extends Mock implements LocationCache {}

class MockProductCache extends Mock implements ProductCache {}

// Mock BLoCs

class MockCategoriesBloc extends Mock implements CategoriesBloc {}

class MockForceUpdateBloc extends Mock implements ForceUpdateBloc {}

class MockHomeBloc extends Mock implements HomeBloc {}

class MockLocationFilterBloc extends Mock implements LocationFilterBloc {}

class MockLoginBloc extends Mock implements LogInBloc {}

class MockMyListingsBloc extends Mock implements MyListingsBloc {}

class MockNewListingBloc extends Mock implements NewListingBloc {}

class MockProductDetailBloc extends Mock implements ProductDetailBloc {}

class MockSearchResultBloc extends Mock implements SearchResultBloc {}

class MockSettingsBloc extends Mock implements SettingsBloc {}

class MockSignUpBloc extends Mock implements SignUpBloc {}

class MockSplashBloc extends Mock implements SplashBloc {}

class MockUserProfileBloc extends Mock implements UserProfileBloc {}

class MockJoinGroupBloc extends Mock implements JoinGroupBloc {}

class MockCreateGroupBloc extends Mock implements CreateGroupBloc {}

class MockMyGroupsBloc extends Mock implements MyGroupsBloc {}

class MockGroupDetailBloc extends Mock implements GroupDetailBloc {}

class MockGroupInformationBloc extends Mock implements GroupInformationBloc {}

class MockEditGroupBloc extends Mock implements EditGroupBloc {}

// Mock Rx Subjects and Streams

class MockApiHttpResponseSubject extends Mock
    implements PublishSubject<HttpResponse<ApiResponse>> {}

class MockApiHttpResponseStreamSink extends Mock
    implements StreamSink<HttpResponse<ApiResponse>> {}

class MockApiModelHttpResponseSubject extends Mock
    implements PublishSubject<HttpResponse<ApiModelResponse>> {}

class MockApiModelHttpResponseStreamSink extends Mock
    implements StreamSink<HttpResponse<ApiModelResponse>> {}

class MockProductHttpResponseSubject extends Mock
    implements PublishSubject<HttpResponse<Product>> {}

class MockProductHttpResponseStreamSink extends Mock
    implements StreamSink<HttpResponse<Product>> {}

class MockLocationSubject extends Mock implements PublishSubject<Location> {}

class MockLocationStreamSink extends Mock implements StreamSink<Location> {}

class MockStreamEventStateSubject extends Mock
    implements PublishSubject<StreamEventState> {}

class MockStreamEventStateStreamSink extends Mock
    implements StreamSink<StreamEventState> {}

class MockBooleanSubject extends Mock implements PublishSubject<bool> {}

class MockBooleanStreamSink extends Mock implements StreamSink<bool> {}

class MockProductListPublishSubject extends Mock
    implements PublishSubject<List<Product>> {}

class MockProductListStreamSink extends Mock
    implements StreamSink<List<Product>> {}

class MockGroupMembershipHttpResponsePublishSubject extends Mock
    implements PublishSubject<HttpResponse<GroupMembership>> {}

class MockGroupMembershipHttpResponseStreamSink extends Mock
    implements StreamSink<HttpResponse<GroupMembership>> {}

class MockGroupHttpResponsePublishSubject extends Mock
    implements PublishSubject<HttpResponse<Group>> {}

class MockGroupHttpResponseStreamSink extends Mock
    implements StreamSink<HttpResponse<Group>> {}

class MockGroupMembershipListPublishSubject extends Mock
    implements PublishSubject<List<GroupMembership>> {}

class MockGroupMembershipListStreamSink extends Mock
    implements StreamSink<List<GroupMembership>> {}
