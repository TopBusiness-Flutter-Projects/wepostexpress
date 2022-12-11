import 'package:flutter/cupertino.dart';

class SettingsModel {
    SettingsModel({
        @required this.json,
    });

    final Map json;

    String get aboutUs => json['aboutUs'];

    String get editProfile => json['editProfile'];

    String get blogs => json['blogs'];

    String get privacyPolicy => json['privacyPolicy'];

    // String get privacyPolicyURL => json['privacyPolicyURL'];

    String get termsAndConditions => json['termsAndConditions'];

    // String get termsAndConditionsURL => json['termsAndConditionsURL'];

    bool get textSize => json['textSize'] == null ? null : json['textSize'] == 'true';


    bool get pullScreen => json['pullScreen'] == null ? null : json['pullScreen'] == 'true';

    bool get darkMode => json['darkMode'] == null ? null : json['darkMode'] == 'true';

    bool get rateApp => json['rateApp'] == null ? null : json['rateApp'] == 'true';

    bool get rtl => json['rtl'] == null ? null : json['rtl'] == 'true';

    // bool get shortCodes => json['shortCodes'] == null ? null : json['shortCodes'] == 'true';

    bool get demos => json['demos'] == null ? null : json['demos'] == 'true';

    String get contactUs => json['contactUs'];

    String get badges => json['badges'];

    String get faq => json['faq'];

    bool get orders => json['orders'] == null ? null : json['orders'] == 'true';

    bool get pushNotifications => json['pushNotifications'] == null ? null : json['pushNotifications'] == 'true';

    bool get changeLanguage => json['changeLanguage'] == null ? null : json['changeLanguage'] == 'true';

    bool get changeCurrency => json['changeCurrency'] == null ? null : json['changeCurrency'] == 'true';

    bool get copyrights => json['copyrights'] == null ? null : json['copyrights'] == 'true';

    bool get baseUrl =>
            null;
// json['baseUrl'] == null ? null : json['baseUrl'] == 'true';
}
