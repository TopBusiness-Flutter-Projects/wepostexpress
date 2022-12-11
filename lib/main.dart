import 'package:easy_localization/easy_localization.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:wepostexpress/firebase_options.dart';
import 'package:wepostexpress/ui/config_loader/bloc/config_loader_bloc.dart';
import 'package:wepostexpress/ui/home/bloc/home_bloc.dart';
import 'package:wepostexpress/ui/home/screens/notification/bloc/notification_bloc.dart';
import 'package:wepostexpress/ui/login/bloc/login_bloc.dart';
import 'package:wepostexpress/ui/mission_shipments/bloc/mission_shipments_bloc.dart';
import 'package:wepostexpress/ui/search/bloc/search_bloc.dart';
import 'package:wepostexpress/ui/shipment_details/bloc/shipment_details_bloc.dart';
import 'package:wepostexpress/ui/splash/bloc/splash_bloc.dart';
import 'package:wepostexpress/ui/splash/splash_screen.dart';
import 'package:wepostexpress/utils/constants/constant_keys.dart';
import 'package:wepostexpress/utils/constants/local_keys.dart';
import 'package:wepostexpress/utils/di/di.dart';
import 'package:wepostexpress/utils/global/global_bloc.dart';
import 'package:wepostexpress/utils/network/repository.dart';
import 'package:wepostexpress/utils/theme/theme_bloc.dart';


void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await EasyLocalization.ensureInitialized();
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
  await init();

  runApp(
    EasyLocalization(
        supportedLocales: [
          Locale(LocalKeys.en),
        ],
        path: 'assets/langs',
        useOnlyLangCode: true,
        fallbackLocale: Locale('en',),
        child: MyApp()),
  );
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
        providers: [
            BlocProvider<ConfigLoaderBloc>(create: (BuildContext context) => ConfigLoaderBloc(di<Repository>())),
            BlocProvider<LoginBloc>(create: (BuildContext context) => LoginBloc(di<Repository>())),
            BlocProvider<SplashBloc>(create: (BuildContext context) => SplashBloc(di<Repository>())),
            BlocProvider<ThemeBloc>(create: (BuildContext context) => di<ThemeBloc>()),
            BlocProvider<HomeBloc>(create: (BuildContext context) => di<HomeBloc>()),
            BlocProvider<GlobalBloc>(create: (BuildContext context) => di<GlobalBloc>()),
            BlocProvider<NotificationBloc>(create: (BuildContext context) => di<NotificationBloc>()),
            BlocProvider<SearchBloc>(create: (BuildContext context) => di<SearchBloc>()),
            BlocProvider<MissionShipmentsBloc>(create: (BuildContext context) => di<MissionShipmentsBloc>()),
            BlocProvider<ShipmentDetailsBloc>(create: (BuildContext context) => di<ShipmentDetailsBloc>()),
        ],
        child: BlocProvider<GlobalBloc>(
                create: (context) => di<GlobalBloc>(),
          child: MaterialApp(
              debugShowCheckedModeBanner: false,
          localizationsDelegates: [
            EasyLocalization.of(context).delegate,
            GlobalMaterialLocalizations.delegate,
            GlobalWidgetsLocalizations.delegate,
            GlobalMaterialLocalizations.delegate,
            GlobalWidgetsLocalizations.delegate,
            GlobalCupertinoLocalizations.delegate,
            DefaultCupertinoLocalizations.delegate
          ],
          locale: EasyLocalization.of(context).locale,
          supportedLocales: EasyLocalization.of(context).supportedLocales,
          home: DefaultTextStyle(
            style: TextStyle(
              fontFamily: FONT_MONTSERRAT,
            ),
            child:  SplashScreen(),
          ),
      ),
        ),
    );
  }
}
