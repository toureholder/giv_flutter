import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter_facebook_login/flutter_facebook_login.dart';
import 'package:giv_flutter/features/about/bloc/about_bloc.dart';
import 'package:giv_flutter/features/customer_service/bloc/customer_service_dialog_bloc.dart';
import 'package:giv_flutter/features/force_update/bloc/force_update_bloc.dart';
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
import 'package:giv_flutter/model/carousel/repository/api/carousel_api.dart';
import 'package:giv_flutter/model/carousel/repository/carousel_repository.dart';
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

  final productApi = ProductApi(client: customHttpClient);
  final userApi = UserApi(client: customHttpClient);
  final locationApi = LocationApi(client: customHttpClient);
  final listingApi = ListingApi(client: customHttpClient);
  final carouselApi = CarouselApi(client: customHttpClient);
  final appConfigApi = AppConfigApi(client: customHttpClient);

  final productCache = ProductCache(diskStorage: diskStorage);
  final locationCache = LocationCache(diskStorage: diskStorage);

  final productRepository = ProductRepository(
    productCache: productCache,
    productApi: productApi,
  );

  final userRepository = UserRepository(userApi: userApi);

  final locationRepository = LocationRepository(
    locationApi: locationApi,
    locationCache: locationCache,
  );

  final listingRepository = ListingRepository(listingApi: listingApi);

  final carouselRepository = CarouselRepository(carouselApi: carouselApi);

  final appConfigRepository = AppConfigRepository(appConfigApi: appConfigApi);

  return <SingleChildCloneableWidget>[
    Provider<LogInBloc>(
      builder: (_) => LogInBloc(
        userRepository: userRepository,
        session: session,
        loginPublishSubject: PublishSubject<HttpResponse<LogInResponse>>(),
        loginAssistancePublishSubject:
            PublishSubject<HttpResponse<ApiResponse>>(),
        firebaseAuth: firebaseAuth,
        facebookLogin: facebookLogin,
        util: util,
      ),
    ),
    Provider<UserProfileBloc>(
      builder: (_) => UserProfileBloc(
        productRepository: productRepository,
        productsPublishSubject: PublishSubject<List<Product>>(),
      ),
    ),
    Provider<SearchResultBloc>(
      builder: (_) => SearchResultBloc(
        productRepository: productRepository,
        diskStorage: diskStorage,
        searchResultSubject: PublishSubject<StreamEvent<ProductSearchResult>>(),
      ),
    ),
    Provider<MyListingsBloc>(
      builder: (_) => MyListingsBloc(
        productRepository: productRepository,
        productsPublishSubject: PublishSubject<List<Product>>(),
      ),
    ),
    Provider<HomeBloc>(
      builder: (_) => HomeBloc(
          productRepository: productRepository,
          carouselRepository: carouselRepository,
          diskStorage: diskStorage,
          contentPublishSubject: PublishSubject<HomeContent>()),
    ),
    Provider<CategoriesBloc>(
      builder: (_) => CategoriesBloc(
          productRepository: productRepository,
          categoriesSubject: BehaviorSubject<List<ProductCategory>>()),
    ),
    Provider<SplashBloc>(
      builder: (_) => SplashBloc(
        userRepository: userRepository,
        locationRepository: locationRepository,
        appConfigRepository: appConfigRepository,
        diskStorage: diskStorage,
        session: session,
        tasksSuccessSubject: PublishSubject<bool>(),
      ),
    ),
    Provider<LocationFilterBloc>(
      builder: (_) => LocationFilterBloc(
        locationRepository: locationRepository,
        diskStorage: diskStorage,
        citiesSubject: PublishSubject<StreamEvent<List<City>>>(),
        statesSubject: PublishSubject<StreamEvent<List<State>>>(),
        listSubject: BehaviorSubject<LocationList>(),
      ),
    ),
    Provider<NewListingBloc>(
      builder: (_) => NewListingBloc(
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
      builder: (_) => ProductDetailBloc(
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
      builder: (_) => SettingsBloc(
        userRepository: userRepository,
        diskStorage: diskStorage,
        session: session,
        userUpdatePublishSubject: PublishSubject<HttpResponse<User>>(),
        firebaseStorageUtil: firebaseStorageUtil,
        util: util,
      ),
    ),
    Provider<CustomerServiceDialogBloc>(
      builder: (_) => CustomerServiceDialogBloc(
        diskStorage: diskStorage,
        util: util,
      ),
    ),
    Provider<SignUpBloc>(
      builder: (_) => SignUpBloc(
        userRepository: userRepository,
        responsePublishSubject: PublishSubject<HttpResponse<ApiResponse>>(),
      ),
    ),
    Provider<AboutBloc>(
      builder: (_) => AboutBloc(
        util: util,
      ),
    ),
    Provider<ForceUpdateBloc>(
      builder: (_) => ForceUpdateBloc(
        util: util,
      ),
    ),
    Provider<Util>(
      builder: (_) => util,
    ),
  ];
}