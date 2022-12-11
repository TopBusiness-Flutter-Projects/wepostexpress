import 'dart:convert' hide utf8;

import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:get_it/get_it.dart';
import 'package:wepostexpress/models/logo_model.dart';
import 'package:wepostexpress/models/onboard_model.dart';
import 'package:wepostexpress/models/settings_model.dart';
import 'package:wepostexpress/models/styling_model.dart';
import 'package:wepostexpress/utils/cache/cache_helper.dart';
import 'package:wepostexpress/utils/constants/constants.dart';
import 'package:wepostexpress/utils/di/di.dart';

class Config {
  Config({
    @required this.config,
  });
  static Future<Config> init(String json) async {
    final baseUrl = await di<CacheHelper>().get('staticConfigBaseUrl') as String;
    if (baseUrl != null && baseUrl.isNotEmpty) {
      Map map = jsonDecode(json);
      map['baseUrl'] = baseUrl;
      json = jsonEncode(map);
    }
    // print('the json : $json');
    Map map = jsonDecode(json);
    // print('dasd');
    // print(map);
    if (map.containsKey('styling')) {
      if (map['styling'].containsKey(ThemeMode.dark.toString()) == false) {
        map['styling'].addAll({
          ThemeMode.dark.toString(): map['styling'][ThemeMode.light.toString()],
        });
      }
      if (map['themeMode'] == 'ThemeMode.system') {
        var brightness = SchedulerBinding.instance.window.platformBrightness;
        bool darkModeOn = brightness == Brightness.dark;
        if (darkModeOn) {
          map['styling'].addAll({
            ThemeMode.system.toString(): map['styling'][ThemeMode.dark.toString()],
          });
        } else {
          map['styling'].addAll({
            ThemeMode.system.toString(): map['styling'][ThemeMode.light.toString()],
          });
        }
      }
      json = jsonEncode(map);
    }
    if(map.containsKey('logo')) {
      if(map['logo'].containsKey('dark')==false){
        map['logo'].addAll({
          'dark':map['logo']['light'],
        });
        json = jsonEncode(map);
      }
    }
    json = jsonEncode(map);
    return Config(config: jsonDecode(json));
  }

  static Config get get => GetIt.I<Config>();

  final Map config;

  String get baseURL => config['baseUrl']+"/api/";
  bool get report => config['report']=='true';
  SettingsModel get settingsPage => config['settingsPage'] == null ? null : SettingsModel(json: config['settingsPage']);

  DefaultValues get defaultValues => config['default'] == null ? null : DefaultValues(json: config['default']);

  // LogoModel get logo => config['logo'] == null ? null : LogoModel(json: config['logo']);
  Map<ThemeMode, StylingModel> get styling => config['styling'] == null
          ? {
    ThemeMode.light: StylingModel(json: {}),
    ThemeMode.dark: StylingModel(json: {}),
  }
          : (config['styling'] as Map)
          .map((key, value) => MapEntry(ThemeMode.values.firstWhere((e) => key.toString() == (e.toString())), StylingModel(json: value)));

  ThemeMode get themeMode => config['themeMode'] == null
          ? ThemeMode.dark
          : ThemeMode.values.firstWhere((e) => config['themeMode'].toString()==(e.toString()), orElse: () => ThemeMode.dark);

  Map<String,dynamic> get translations => config['translations'];
  List<OnboardModel> get onboardModels {
    print('sadasdas');
    print(config['onboardModels']);
    return config['onboardModels'] == null
            ? null
            : (config['onboardModels'] as List).map((e) => OnboardModel(json: e)).toList();
  }

  String get version => config['version'] == null ? null : config['version'].toString();

  String get commentsApi => config['commentsApi'];

  String get lang {
    if(config['lang']!=null){
      if(config['lang']=='eg'||config['lang']=='sa'){
        return 'ar';
      }
      return config['lang'];
    }
    return 'en';
  }

  String get rawLang {
    if(config['lang']!=null){
      return config['lang'];
    }
    return 'en';
  }

  bool get expired => config['expired'] == null ? false : config['expired'] == 'true';
  String get expiredTitle => config['expiredTitle'];
  String get expiredBody => config['expiredBody'];
  String get expiredColor => config['expiredColor'];
  String get expiredGotoUrl => config['expiredGotoUrl'];
  String get expiredImage => config['expiredImage'];
  String get expiredButtonTitle => config['expiredButtonTitle'];

  bool get inputsWithBackground => config['inputsWithBackground'] == null ? false : config['inputsWithBackground'] == 'true';

  // bool statusBarWhiteForeground(ThemeMode mode) {
  //   final col = rgboOrHex(styling[mode]?.appBarBackgroundColor);
  //   if (col == null) {
  //     return null;
  //   }
  //   if (col.computeLuminance() >= 0.5) {
  //     return null;
  //   } else {
  //     return true;
  //   }
  //   // return config['statusBarWhiteForeground'] == null ? null : config['statusBarWhiteForeground'] == 'true';
  // }

  // String get baseUrl => '${config['baseUrl']}/';
  // String get baseUrlWithoutSlash => '${config['baseUrl']}';

  String get searchApi => config['searchApi'];

  String get commentAdd => config['commentAdd'];

  // String get appName => config['appName'];

  String get copyrights => config['copyrights'];

  bool get comments =>
          config['comments'] == null ? false : config['comments'] is String
                  ? config['comments'] == 'true'
                  : config['comments'] is bool
                  ? config['comments'] == true
                  : false;

  bool get rtl =>
          // null;
  config['rtl'] == null ? null : config['rtl'] == 'true';

  bool get registerModule => config['registerModule'] == null ? false : config['registerModule'] == 'true';

  bool get advancedSearch => config['advancedSearch'] == null ? false : config['advancedSearch'] == 'true';
}
class DefaultValues {
  bool get registerTerms => json['registerTerms'] == 'true';

  bool get addQuestionsTerms => json['addQuestionsTerms'] == 'true';
  bool get addQuestionsRemember => json['addQuestionsRemember'] == 'true';
  bool get addQuestionsPrivate => json['addQuestionsPrivate'] == 'true';
  bool get addQuestionsVideos => json['addQuestionsVideos'] == 'true';
  bool get addQuestionsAnonymous => json['addQuestionsAnonymous'] == 'true';
  bool get addQuestionsPoll => json['addQuestionsPoll'] == 'true';
  bool get addQuestionsImagePoll => json['addQuestionsImagePoll'] == 'true';

  bool get addBlogTerms => json['addBlogTerms'] == 'true';

  bool get addAnswerTerms => json['addAnswerTerms'] == 'true';
  bool get addAnswerPrivate => json['addAnswerPrivate'] == 'true';
  bool get addAnswerAnonymous => json['addAnswerAnonymous'] == 'true';
  bool get addAnswerVideo => json['addAnswerVideo'] == 'true';

  bool get addCommentTerms => json['addCommentTerms'] == 'true';

  final Map json;

  DefaultValues({
    @required this.json,
  });
}
