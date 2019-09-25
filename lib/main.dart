import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter/services.dart';
import 'package:flutter_facebook_login/flutter_facebook_login.dart';
import 'package:giv_flutter/base/app.dart';
import 'package:giv_flutter/features/home/model/home_content.dart';
import 'package:giv_flutter/model/api_response/api_response.dart';
import 'package:giv_flutter/model/location/location.dart';
import 'package:giv_flutter/model/product/product.dart';
import 'package:giv_flutter/model/product/product_category.dart';
import 'package:giv_flutter/model/user/repository/api/response/log_in_response.dart';
import 'package:giv_flutter/model/user/user.dart';
import 'package:giv_flutter/service/preferences/shared_preferences_storage.dart';
import 'package:giv_flutter/features/customer_service/bloc/customer_service_dialog_bloc.dart';
import 'package:giv_flutter/features/home/bloc/home_bloc.dart';
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
import 'package:giv_flutter/model/app_config/repository/api/app_config_api.dart';
import 'package:giv_flutter/model/app_config/repository/app_config_repository.dart';
import 'package:giv_flutter/model/carousel/repository/api/carousel_api.dart';
import 'package:giv_flutter/model/carousel/repository/carousel_repository.dart';
import 'package:giv_flutter/model/listing/repository/api/listing_api.dart';
import 'package:giv_flutter/model/listing/repository/listing_repository.dart';
import 'package:giv_flutter/model/location/repository/api/location_api.dart';
import 'package:giv_flutter/model/location/repository/cache/location_cache.dart';
import 'package:giv_flutter/model/location/repository/location_repository.dart';
import 'package:giv_flutter/model/product/repository/api/product_api.dart';
import 'package:giv_flutter/model/product/repository/cache/product_cache.dart';
import 'package:giv_flutter/model/product/repository/product_repository.dart';
import 'package:giv_flutter/model/user/repository/api/user_api.dart';
import 'package:giv_flutter/model/user/repository/user_repository.dart';
import 'package:giv_flutter/service/session/session.dart';
import 'package:giv_flutter/util/data/stream_event.dart';
import 'package:giv_flutter/util/network/http_response.dart';
import 'package:http/http.dart' as http;
import 'package:provider/provider.dart';
import 'package:rxdart/rxdart.dart';
import 'package:shared_preferences/shared_preferences.dart';

void main() async {
  debugPaintSizeEnabled = false;
  await SystemChrome.setPreferredOrientations(
      [DeviceOrientation.portraitUp, DeviceOrientation.portraitDown]);

  final sharedPreferences = await SharedPreferences.getInstance();
  final httpClient = http.Client();

  final productApi = ProductApi(client: httpClient);
  final userApi = UserApi(client: httpClient);
  final locationApi = LocationApi(client: httpClient);
  final listingApi = ListingApi(client: httpClient);
  final carouselApi = CarouselApi(client: httpClient);
  final appConfigApi = AppConfigApi(client: httpClient);

  final productCache = ProductCache(sharedPreferences: sharedPreferences);
  final locationCache = LocationCache(sharedPreferences: sharedPreferences);

  final diskStorage = SharedPreferencesStorage(sharedPreferences);
  final session = Session(diskStorage);
  final firebaseAuth = FirebaseAuth.instance;

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

  final dependencies = <SingleChildCloneableWidget>[
    Provider<LogInBloc>(
      builder: (_) => LogInBloc(
        userRepository: userRepository,
        session: session,
        loginPublishSubject: PublishSubject<HttpResponse<LogInResponse>>(),
        loginAssistancePublishSubject:
            PublishSubject<HttpResponse<ApiResponse>>(),
        firebaseAuth: firebaseAuth,
        facebookLogin: FacebookLogin()
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
          categoriesPublishSubject: PublishSubject<List<ProductCategory>>()),
    ),
    Provider<SplashBloc>(
      builder: (_) => SplashBloc(
          userRepository: userRepository,
          locationRepository: locationRepository,
          appConfigRepository: appConfigRepository,
          diskStorage: diskStorage,
          session: session),
    ),
    Provider<LocationFilterBloc>(
      builder: (_) => LocationFilterBloc(
        locationRepository: locationRepository,
        diskStorage: diskStorage,
      ),
    ),
    Provider<NewListingBloc>(
      builder: (_) => NewListingBloc(
        locationRepository: locationRepository,
        listingRepository: listingRepository,
        diskStorage: diskStorage,
        userPublishSubject: PublishSubject<NewListingBlocUser>(),
        locationPublishSubject: PublishSubject<Location>(),
        savedProductPublishSubject: PublishSubject<Product>(),
        uploadStatusPublishSubject: PublishSubject<StreamEvent<double>>(),
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
      ),
    ),
    Provider<SettingsBloc>(
      builder: (_) => SettingsBloc(
        userRepository: userRepository,
        diskStorage: diskStorage,
        session: session,
        userPublishSubject: PublishSubject<StreamEvent<User>>(),
        userUpdatePublishSubject: PublishSubject<HttpResponse<User>>(),
      ),
    ),
    Provider<CustomerServiceDialogBloc>(
      builder: (_) => CustomerServiceDialogBloc(diskStorage: diskStorage),
    ),
    Provider<SignUpBloc>(
      builder: (_) => SignUpBloc(
        userRepository: userRepository,
        responsePublishSubject: PublishSubject<HttpResponse<ApiResponse>>(),
      ),
    ),
  ];

  runApp(new MyApp(dependencies: dependencies));
}
