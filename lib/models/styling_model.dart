import 'package:flutter/material.dart';

class StylingModel {
    const StylingModel({
        this.json,
    });

    final Map json;

    String get bestAnswerColor => json['bestAnswerColor'] ?? '26aa6c';

    String get removeBestAnswerColor => json['removeBestAnswerColor'] ?? 'AA0000';

    String get addBestAnswerColor => json['addBestAnswerColor'] ?? primary;

    String get settingBackgroundColor => json['settingBackgroundColor'];

    String get settingTextColor => json['settingTextColor'];

    String get errorColor => json['errorColor']??'ff0000';

    String get errorTextColor => json['errorTextColor']??'ffffff';

    String get successColor => json['successColor']??'4caf50';

    String get successTextColor => json['successTextColor']??'ffffff';

    String get appBarBackgroundColor => json['appBarBackgroundColor']??'ffffff';

    String get tabBarBackgroundColor => json['tabBarBackgroundColor']??'ffffff';

    String get bottomBarBackgroundColor => json['bottomBarBackgroundColor']??'ffffff';

    String get appBarColor => json['appBarColor']??'000000';

    String get tabBarActiveTextColor => json['tabBarActiveTextColor']??'0000ff';

    String get tabBarIndicatorColor => json['tabBarIndicatorColor']??'0000ff';

    String get tabBarTextColor => json['tabBarTextColor']??'000000';

    String get bottomBarActiveColor => json['bottomBarActiveColor']??'0000ff';

    String get bottomBarInActiveColor => json['bottomBarInActiveColor']??'505050';

    String get primary => json['primary'] ?? '#F88C00';

    String get secondary => json['secondary'] ?? '#000000';

    String get secondaryVariant => json['secondaryVariant'] ?? '#666666';

    String get background => json['background'] ?? '#FFFFFF';

    String get sidemenutextcolor => json['sidemenutextcolor'] ?? secondary;

    String get scaffoldBackgroundColor => json['scaffoldBackgroundColor'] ?? '#FFFFFF';

    String get buttonTextColor => json['buttonTextColor'] ?? 'FFFFFF';

    String get dividerColor => json['dividerColor'] ?? '#EEEEEE';

    String get shadowColor => json['shadowColor']??'101010';

    String get buttonsbackgroudcolor => json['buttonsbackgroudcolor']??'0000ff';

    String get inputsbackgroundcolor => json['inputsbackgroundcolor'] ?? '#F6F6F6';
}
