import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter_facebook_login/flutter_facebook_login.dart';
import 'package:giv_flutter/config/hive/constants.dart';
import 'package:giv_flutter/features/about/bloc/about_bloc.dart';
import 'package:giv_flutter/features/customer_service/bloc/customer_service_dialog_bloc.dart';
import 'package:giv_flutter/features/force_update/bloc/force_update_bloc.dart';
import 'package:giv_flutter/features/groups/create_group/bloc/create_group_bloc.dart';
import 'package:giv_flutter/features/groups/edit_group/bloc/edit_group_bloc.dart';
import 'package:giv_flutter/features/groups/group_detail/bloc/group_detail_bloc.dart';
import 'package:giv_flutter/features/groups/group_information/bloc/group_information_bloc.dart';
import 'package:giv_flutter/features/groups/join_group/bloc/join_group_bloc.dart';
import 'package:giv_flutter/features/groups/my_groups/bloc/my_groups_bloc.dart';
import 'package:giv_flutter/features/home/bloc/home_bloc.dart';
import 'package:giv_flutter/features/home/model/home_content.dart';
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
import 'package:giv_flutter/model/group_membership/repository/api/group_membership_api.dart';
import 'package:giv_flutter/model/group_membership/repository/group_membership_repository.dart';
import 'package:giv_flutter/model/group_updated_action.dart';
import 'package:giv_flutter/model/listing/repository/api/listing_api.dart';
import 'package:giv_flutter/model/listing/repository/listing_repository.dart';
import 'package:giv_flutter/model/location/location.dart';
import 'package:giv_flutter/model/location/location_list.dart';
import 'package:giv_flutter/model/location/location_part.dart';
import 'package:giv_flutter/model/location/repository/api/location_api.dart';
import 'package:giv_flutter/model/location/repository/cache/location_cache.dart';
import 'package:giv_flutter/model/location/repository/location_repository.dart';
import 'package:giv_flutter/model/product/product.dart';
import 'package:giv_flutter/model/product/product_category.dart';
import 'package:giv_flutter/model/product/product_search_result.dart';
import 'package:giv_flutter/model/product/repository/api/product_api.dart';
import 'package:giv_flutter/model/product/repository/cache/product_cache.dart';
import 'package:giv_flutter/model/product/repository/product_repository.dart';
import 'package:giv_flutter/model/user/repository/api/response/log_in_response.dart';
import 'package:giv_flutter/model/user/repository/api/user_api.dart';
import 'package:giv_flutter/model/user/repository/user_repository.dart';
import 'package:giv_flutter/model/user/user.dart';
import 'package:giv_flutter/service/preferences/shared_preferences_storage.dart';
import 'package:giv_flutter/service/session/session.dart';
import 'package:giv_flutter/util/data/stream_event.dart';
import 'package:giv_flutter/util/firebase/firebase_storage_util.dart';
import 'package:giv_flutter/util/network/http_client_wrapper.dart';
import 'package:giv_flutter/util/network/http_response.dart';
import 'package:giv_flutter/util/util.dart';
import 'package:hive/hive.dart';
import 'package:http/http.dart';
import 'package:provider/provider.dart';
import 'package:rxdart/rxdart.dart';
import 'package:shared_preferences/shared_preferences.dart';

Future<List<SingleChildCloneableWidget>> getAppDependencies() async {
  final sharedPreferences = await SharedPreferences.getInstance();
  final httpClient = Client();
  final diskStorage = SharedPreferencesStorage(sharedPreferences);
  final firebaseAuth = FirebaseAuth.instance;
  final facebookLogin = FacebookLogin();
  final session = Session(diskStorage, firebaseAuth, facebookLogin);
  final customHttpClient = HttpClientWrapper(httpClient, diskStorage);
  final firebaseStorage = FirebaseStorage.instance;
  final firebaseStorageUtil = FirebaseStorageUtil(
      diskStorage: diskStorage, firebaseStorage: firebaseStorage);
  final util = Util(diskStorage: diskStorage);
  final productCache = ProductCache(diskStorage: diskStorage);
  final locationCache = LocationCache(diskStorage: diskStorage);

  Hive.registerAdapter(UserAdapter());
  Hive.registerAdapter(GroupAdapter());
  Hive.registerAdapter(GroupMembershipAdapter());

  final groupsBox = await Hive.openBox<Group>(
    HiveConstants.groupsBoxName,
  );

  final groupMembershipsBox = await Hive.openBox<GroupMembership>(
    HiveConstants.groupMembershipsBoxName,
  );

  // APIs
  final productApi = ProductApi(
    client: customHttpClient,
  );
  final userApi = UserApi(
    client: customHttpClient,
  );
  final locationApi = LocationApi(
    client: customHttpClient,
  );
  final listingApi = ListingApi(
    client: customHttpClient,
  );
  final carouselApi = CarouselApi(
    client: customHttpClient,
  );
  final appConfigApi = AppConfigApi(
    client: customHttpClient,
  );
  final groupMembershipApi = GroupMembershipApi(
    clientWrapper: customHttpClient,
  );
  final groupApi = GroupApi(
    clientWrapper: customHttpClient,
  );

  // Repositories
  final productRepository = ProductRepository(
    productCache: productCache,
    productApi: productApi,
  );

  final userRepository = UserRepository(
    userApi: userApi,
  );

  final locationRepository = LocationRepository(
    locationApi: locationApi,
    locationCache: locationCache,
  );

  final listingRepository = ListingRepository(
    listingApi: listingApi,
  );

  final carouselRepository = CarouselRepository(
    carouselApi: carouselApi,
  );

  final appConfigRepository = AppConfigRepository(
    appConfigApi: appConfigApi,
  );

  final groupMembershipRepository = GroupMembershipRepository(
    api: groupMembershipApi,
    box: groupMembershipsBox,
    groupsBox: groupsBox,
  );

  final groupRepository = GroupRepository(
    api: groupApi,
    box: groupsBox,
    membershipsBox: groupMembershipsBox,
  );

  final authUserUpdatedAction = AuthUserUpdatedAction();
  final groupUpdatedAction = GroupUpdatedAction();

  return <SingleChildCloneableWidget>[
    Provider<LogInBloc>(
      create: (_) => LogInBloc(
        userRepository: userRepository,
        session: session,
        loginPublishSubject: PublishSubject<HttpResponse<LogInResponse>>(),
        loginAssistancePublishSubject:
            PublishSubject<HttpResponse<ApiResponse>>(),
        firebaseAuth: firebaseAuth,
        facebookLogin: facebookLogin,
        util: util,
        authUserUpdatedAction: authUserUpdatedAction,
      ),
    ),
    Provider<UserProfileBloc>(
      create: (_) => UserProfileBloc(
        productRepository: productRepository,
        productsPublishSubject: PublishSubject<List<Product>>(),
      ),
    ),
    Provider<SearchResultBloc>(
      create: (_) => SearchResultBloc(
        productRepository: productRepository,
        diskStorage: diskStorage,
        searchResultSubject: PublishSubject<StreamEvent<ProductSearchResult>>(),
      ),
    ),
    Provider<MyListingsBloc>(
      create: (_) => MyListingsBloc(
        productRepository: productRepository,
        productsPublishSubject: PublishSubject<List<Product>>(),
      ),
    ),
    Provider<HomeBloc>(
      create: (_) => HomeBloc(
          productRepository: productRepository,
          carouselRepository: carouselRepository,
          diskStorage: diskStorage,
          contentPublishSubject: PublishSubject<HomeContent>()),
    ),
    Provider<CategoriesBloc>(
      create: (_) => CategoriesBloc(
          productRepository: productRepository,
          categoriesSubject: BehaviorSubject<List<ProductCategory>>()),
    ),
    Provider<SplashBloc>(
      create: (_) => SplashBloc(
        userRepository: userRepository,
        locationRepository: locationRepository,
        appConfigRepository: appConfigRepository,
        diskStorage: diskStorage,
        session: session,
        tasksSuccessSubject: PublishSubject<bool>(),
      ),
    ),
    Provider<LocationFilterBloc>(
      create: (_) => LocationFilterBloc(
        locationRepository: locationRepository,
        diskStorage: diskStorage,
        citiesSubject: PublishSubject<StreamEvent<List<City>>>(),
        statesSubject: PublishSubject<StreamEvent<List<State>>>(),
        listSubject: BehaviorSubject<LocationList>(),
      ),
    ),
    Provider<NewListingBloc>(
      create: (_) => NewListingBloc(
        locationRepository: locationRepository,
        listingRepository: listingRepository,
        diskStorage: diskStorage,
        locationPublishSubject: PublishSubject<Location>(),
        savedProductPublishSubject: PublishSubject<Product>(),
        uploadStatusPublishSubject: PublishSubject<StreamEvent<double>>(),
        firebaseStorageUtil: firebaseStorageUtil,
      ),
    ),
    Provider<ProductDetailBloc>(
      create: (_) => ProductDetailBloc(
        locationRepository: locationRepository,
        listingRepository: listingRepository,
        session: session,
        locationPublishSubject: PublishSubject<Location>(),
        deleteListingPublishSubject:
            PublishSubject<HttpResponse<ApiModelResponse>>(),
        loadingPublishSubject: PublishSubject<StreamEventState>(),
        updateListingPublishSubject: PublishSubject<HttpResponse<Product>>(),
        util: util,
      ),
    ),
    Provider<SettingsBloc>(
      create: (_) => SettingsBloc(
        userRepository: userRepository,
        diskStorage: diskStorage,
        session: session,
        userUpdatePublishSubject: PublishSubject<HttpResponse<User>>(),
        firebaseStorageUtil: firebaseStorageUtil,
        util: util,
        authUserUpdatedAction: authUserUpdatedAction,
      ),
    ),
    Provider<CustomerServiceDialogBloc>(
      create: (_) => CustomerServiceDialogBloc(
        diskStorage: diskStorage,
        util: util,
      ),
    ),
    Provider<SignUpBloc>(
      create: (_) => SignUpBloc(
        userRepository: userRepository,
        responsePublishSubject: PublishSubject<HttpResponse<ApiResponse>>(),
      ),
    ),
    Provider<AboutBloc>(
      create: (_) => AboutBloc(
        util: util,
      ),
    ),
    Provider<ForceUpdateBloc>(
      create: (_) => ForceUpdateBloc(
        util: util,
      ),
    ),
    Provider<JoinGroupBloc>(
      create: (_) => JoinGroupBloc(
        groupMembershipRepository: groupMembershipRepository,
        groupMembershipSubject: PublishSubject<HttpResponse<GroupMembership>>(),
        diskStorage: diskStorage,
      ),
    ),
    Provider<CreateGroupBloc>(
      create: (_) => CreateGroupBloc(
        groupRepository: groupRepository,
        groupSubject: PublishSubject<HttpResponse<Group>>(),
        diskStorage: diskStorage,
      ),
    ),
    Provider<MyGroupsBloc>(
      create: (_) => MyGroupsBloc(
        repository: groupMembershipRepository,
        subject: PublishSubject<List<GroupMembership>>(),
        diskStorage: diskStorage,
        util: util,
      ),
    ),
    Provider<GroupDetailBloc>(
      create: (_) => GroupDetailBloc(
        groupRepository: groupRepository,
        groupMembershipRepository: groupMembershipRepository,
        productsSubject: PublishSubject<List<Product>>(),
        leaveGroupSubject: PublishSubject<HttpResponse<GroupMembership>>(),
        diskStorage: diskStorage,
        util: util,
      ),
    ),
    Provider<GroupInformationBloc>(
      create: (_) => GroupInformationBloc(
        memberhipsRepository: groupMembershipRepository,
        loadMembershipsSubject: PublishSubject<List<GroupMembership>>(),
        diskStorage: diskStorage,
        util: util,
      ),
    ),
    Provider<EditGroupBloc>(
      create: (_) => EditGroupBloc(
        groupRepository: groupRepository,
        groupSubject: PublishSubject<HttpResponse<Group>>(),
        diskStorage: diskStorage,
        firebaseStorageUtil: firebaseStorageUtil,
        util: util,
        groupUpdatedAction: groupUpdatedAction,
      ),
    ),
    Provider<Util>(
      create: (_) => util,
    ),
    ChangeNotifierProvider<GroupUpdatedAction>(
      create: (context) => groupUpdatedAction,
    ),
    ChangeNotifierProvider<AuthUserUpdatedAction>(
      create: (context) => authUserUpdatedAction,
    )
  ];
}
