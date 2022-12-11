import 'dart:convert' hide utf8;
import 'dart:io';

import 'package:dartz/dartz.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:http/http.dart' as http;
import 'package:wepostexpress/models/simple_model.dart';
import 'package:wepostexpress/models/user/user_model.dart';
import 'package:wepostexpress/utils/cache/cache_helper.dart';
import 'package:wepostexpress/utils/config/config.dart';
import 'package:wepostexpress/utils/di/di.dart';
import 'package:wepostexpress/utils/network/repository.dart';
import 'package:wepostexpress/utils/theme/theme_states.dart';

class ThemeBloc extends Cubit<ThemeStates> {
  final Repository repository;

  bool isDevMode = false;
  bool isProductFav = false;
  bool hasOpenedDemosBefore = false;

  SimpleModel simpleModel = SimpleModel();

  List languagesList = [];

  List currenciesList = [];

  ThemeMode themeMode = Config.get.themeMode;

  bool switchButton = Config.get.themeMode == ThemeMode.dark ? true : false;

  bool pushNotifications = false;

  String languageId = '';
  String language = '';

  String currency = '';

  bool isUser = false;

  bool isRtl = (Config.get.rtl != null && Config.get.rtl);

  UserModel userModel = UserModel();
  String notificationMessage = '';
  Map notificationData;
  String userToken = '';

  List<String> remoteFavourites = [];
  List<String> remoteDeals = [];

  List localFavourites = [];

  List bottomTitles = [];

  var config;

  ThemeBloc(this.repository) : super(InitialThemeState());


  static ThemeBloc get(BuildContext context) => BlocProvider.of(context);

  openedDemos([bool hasOpenedBefore = true]) async {
    this.hasOpenedDemosBefore = hasOpenedBefore;
    if (this.hasOpenedDemosBefore) {
      await di<CacheHelper>().put('openedDemos', true);
    }
    emit(HasOpenedDemosThemeState());
  }

  report() async {
    emit(LoadingReportState());
  }

  getConfig() {
    print('------- config re build');

    config = Config.get;
    emit(SuccessGetConfigState());
  }

  getLanguages() async {
    if (Config.get.baseURL != null) {
      emit(LoadingGetLanguagesState());

      var response = await http.get(Uri.parse('${Config.get.baseURL}${''}'));

      // print('responseBody : ${Config.get.basicUrls.languages}');
      print('responseBody : ${response.request.url}');
      print('responseBody : ${response.body}');

      languagesList = (json.decode(response.body) as List).map((e) {
        e['id'] = e['code'];
        return e;
      }).toList();

      emit(SuccessGetLanguagesState());
    }
  }

  setDirection(value) {
    di<CacheHelper>().put('isRtl', value);
    isRtl = value;

    emit(SuccessSetDirectionState());
  }

  getDirection() async {
    await di<CacheHelper>().has('isRtl').then((value) async {
      if (value) {
        await di<CacheHelper>().get('isRtl').then((value) async {
          if (value) {
            isRtl = true;
          } else {
            isRtl = false;
          }
        });
      } else {
        isRtl = Config.get.rtl != null && Config.get.rtl;
      }
    });

    emit(SuccessGetDirectionState());
  }

  Future<void> changeTheme(ThemeMode mode) async {
    themeMode = mode;
    print('bloc theme mode ' + mode.toString());

    switch (mode) {
      case ThemeMode.light:
        di<CacheHelper>().put('theme', 'light');
        switchButton = false;
        break;
      case ThemeMode.dark:
        di<CacheHelper>().put('theme', 'dark');
        switchButton = true;
        break;
      case ThemeMode.system:
        break;
    }
    emit(SuccessThemeState());
  }

  Future<void> showNotification({
    String message,
    Map data,
    String id,
  }) async {
    notificationMessage = message ?? '';
    notificationData = data;

    emit(SuccessShowNotificationState());
  }

  Future<void> isChange() async {
    emit(SuccessIsChangingState());
  }

  Future<void> getThemeMode() async {
    print('ThemeBloc.getThemeMode');
    print(Config.get.themeMode);
    if (Config.get.themeMode == ThemeMode.system) {
      themeMode = ThemeMode.system;
    } else {
      di<CacheHelper>().get('theme').then((value) {
        if (value != null) {
          String mode = value as String;

          print('mode from bloc $mode');

          switch (mode) {
            case 'light':
              themeMode = ThemeMode.light;
              // switchSystem = false;
              break;
            case 'dark':
              themeMode = ThemeMode.dark;
              // switchSystem = false;
              break;
            // case 'system':
            //   switchSystem = true;
            //   var brightness = SchedulerBinding.instance.window.platformBrightness;
            //   bool darkModeOn = brightness == Brightness.dark;
            //   if (darkModeOn) {
            //     themeMode = ThemeMode.dark;
            //   } else {
            //     themeMode = ThemeMode.light;
            //   }
            //   break;
            // default:
            //   themeMode = ThemeMode.light;
            //   break;
          }
        } else {
          themeMode = Config.get.themeMode;
        }
      });
    }

    emit(ThemeState());
  }

  Future<void> getSwitchButton() async {
    di<CacheHelper>().get('theme').then((value) {
      if (value != null) {
        String mode = value as String;

        print('mode from bloc $mode');

        switch (mode) {
          case 'light':
            switchButton = false;
            break;
          case 'dark':
            switchButton = true;
            break;
          default:
            switchButton = false;
            break;
        }
      } else {
        switch (Config.get.themeMode) {
          case ThemeMode.system:
            break;
          case ThemeMode.light:
            switchButton = false;
            break;
          case ThemeMode.dark:
            switchButton = true;
            break;
        }
      }
    });

    emit(ThemeState());
  }


  Future<void> getUser() async {
    await di<CacheHelper>().has('user').then((user) async {
      if (user) {
        isUser = true;

        await di<CacheHelper>().get('user').then((value) async {
          userModel = UserModel.fromJson(value);

          await di<CacheHelper>().get('userToken').then((value) async {
            userToken = value as String;
          });
        });
      } else {
        isUser = false;
        userToken = '';
        userModel = UserModel();
      }
    });

    print('isssssssssssss $isUser');

    emit(SuccessGetUserState());
  }

  getNotifications() async {
    await di<CacheHelper>().has('notificationsCache').then((value) async {
      if (value) {
        await di<CacheHelper>().get('notificationsCache').then((value) async {
          if (value) {
            pushNotifications = true;
          } else {
            pushNotifications = false;
          }
        });
      } else {
        pushNotifications = false;
      }
    });

    emit(SuccessGetUserState());
  }

  switchLanguage(value, id) {
    emit(LoadingGetLanguagesState());

    language = value.toString();
    languageId = id.toString();
    di<CacheHelper>().put('language', value.toString());
    di<CacheHelper>().put('languageId', id.toString());

    print('------> lang ${value.toString()}');

    //emit(SwitchLanguageState());
  }

  Future<bool> switchCurrency(value) {
    emit(LoadingGetCurrenciesState());

    currency = value.toString();

    return di<CacheHelper>().put('currency', value.toString());
  }

  List favourites = [];
  List deals = [];

  Future<void> fetch() async {
    try {
      final f = await di<CacheHelper>().get('favourites');
      if (f != null) {
        print('f runtime : ${f.runtimeType}');
        final list = f as List;
        favourites = list;
      } else {
        favourites = [];
      }
      emit(SuccessFillLocalFavState());
    } catch (e) {
      print(e);
      emit(ErrorThemeState(e.toString()));
    }
  }


  bool availableBlock = false;

  changeBlock({
    bool block,
  }) {
    emit(ChangeBlockState());

    availableBlock = block;
  }
}
