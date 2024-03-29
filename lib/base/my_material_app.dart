import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:giv_flutter/config/i18n/l10n.dart';
import 'package:giv_flutter/config/i18n/string_localizations.dart';
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
import 'package:giv_flutter/features/splash/ui/splash.dart';
import 'package:giv_flutter/features/user_profile/bloc/user_profile_bloc.dart';
import 'package:giv_flutter/values/colors.dart';
import 'package:provider/provider.dart';

class MyMaterialApp extends StatefulWidget {
  @override
  _MyMaterialAppState createState() => _MyMaterialAppState();
}

class _MyMaterialAppState extends State<MyMaterialApp> {
  @override
  Widget build(BuildContext context) => MaterialApp(
        debugShowCheckedModeBanner: false,
        onGenerateTitle: (BuildContext context) =>
            StringLocalizations.of(context).get('app_name'),
        localizationsDelegates: [
          const StringLocalizationsDelegate(),
          ...GlobalMaterialLocalizations.delegates,
          GlobalWidgetsLocalizations.delegate,
        ],
        supportedLocales: L10n.supportedLocales,
        theme: new ThemeData(
          primaryColor: Colors.blue,
          backgroundColor: Colors.blue,
          colorScheme: ColorScheme.fromSwatch()
              .copyWith(secondary: CustomColors.accentColor),
        ),
        home: Consumer<SplashBloc>(
          builder: (context, bloc, child) => Splash(bloc: bloc),
        ),
      );

  @override
  void dispose() {
    Provider.of<LogInBloc>(context, listen: false).dispose();
    Provider.of<UserProfileBloc>(context, listen: false).dispose();
    Provider.of<SearchResultBloc>(context, listen: false).dispose();
    Provider.of<MyListingsBloc>(context, listen: false).dispose();
    Provider.of<HomeBloc>(context, listen: false).dispose();
    Provider.of<CategoriesBloc>(context, listen: false).dispose();
    Provider.of<LocationFilterBloc>(context, listen: false).dispose();
    Provider.of<NewListingBloc>(context, listen: false).dispose();
    Provider.of<ProductDetailBloc>(context, listen: false).dispose();
    Provider.of<SettingsBloc>(context, listen: false).dispose();
    Provider.of<SignUpBloc>(context, listen: false).dispose();
    Provider.of<SplashBloc>(context, listen: false).dispose();
    super.dispose();
  }
}
