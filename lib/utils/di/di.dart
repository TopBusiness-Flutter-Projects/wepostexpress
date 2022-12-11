import 'dart:convert';
import 'package:flutter/services.dart';
import 'package:wepostexpress/ui/config_loader/bloc/config_loader_bloc.dart';
import 'package:wepostexpress/ui/home/bloc/home_bloc.dart';
import 'package:wepostexpress/ui/home/screens/notification/bloc/notification_bloc.dart';
import 'package:wepostexpress/ui/login/bloc/login_bloc.dart';
import 'package:wepostexpress/ui/mission_shipments/bloc/mission_shipments_bloc.dart';
import 'package:wepostexpress/ui/search/bloc/search_bloc.dart';
import 'package:wepostexpress/ui/shipment_details/bloc/shipment_details_bloc.dart';
import 'package:wepostexpress/ui/splash/bloc/splash_bloc.dart';
import 'package:wepostexpress/utils/cache/cache_helper.dart';
import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';
import 'package:wepostexpress/utils/config/config.dart';
import 'package:wepostexpress/utils/global/global_bloc.dart';
import 'package:wepostexpress/utils/network/remote/api_helper.dart';
import 'package:wepostexpress/utils/network/remote/dio_helper.dart';
import 'package:wepostexpress/utils/network/repository.dart';
import 'package:wepostexpress/utils/theme/theme_bloc.dart';
import 'package:shared_preferences/shared_preferences.dart';

final di = GetIt.I..allowReassignment = true;

Future init() async {

    final sp = await SharedPreferences.getInstance();
    di.registerSingleton<CacheHelper>(CacheHelper(sp));
    Config sc = await Config.init(await rootBundle.loadString('assets/config.json'));
    di.registerSingleton<Config>(sc);

    di.registerLazySingleton<ApiHelper>(
                () => ApiImpl(),
    );
    di.registerLazySingleton<DioHelper>(
                () => DioImpl(),
    );

    di.registerLazySingleton<Repository>(
                () => RepoImpl(
            apiHelper: di<ApiHelper>(),
            dioHelper: di<DioHelper>(),
            cacheHelper: di<CacheHelper>(),
        ),
    );

    var theme = ThemeMode.light;
    if (sp.containsKey('dark')) theme = (jsonDecode(sp.getString('dark')) as bool) ? ThemeMode.dark : ThemeMode.light;

    di.registerFactory<SplashBloc>(() => SplashBloc(di<Repository>()));
    di.registerFactory<LoginBloc>(() => LoginBloc(di<Repository>()));
    di.registerFactory<ConfigLoaderBloc>(() => ConfigLoaderBloc(di<Repository>()));
    di.registerFactory<ThemeBloc>(() => ThemeBloc(di<Repository>()));
    di.registerFactory<HomeBloc>(() => HomeBloc(di<Repository>()));
    di.registerFactory<NotificationBloc>(() => NotificationBloc(di<Repository>()));
    di.registerFactory<GlobalBloc>(() => GlobalBloc(di<Repository>()));
    di.registerFactory<SearchBloc>(() => SearchBloc(di<Repository>()));
    di.registerFactory<MissionShipmentsBloc>(() => MissionShipmentsBloc(di<Repository>()));
    di.registerFactory<ShipmentDetailsBloc>(() => ShipmentDetailsBloc(di<Repository>()));
}
