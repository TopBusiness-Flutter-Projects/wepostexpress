import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_hex_color/flutter_hex_color.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:wepostexpress/utils/cache/cache_helper.dart';
import 'package:wepostexpress/utils/constants/local_keys.dart';
import 'package:wepostexpress/utils/di/di.dart';

void printFullText(String text) {
  final pattern = new RegExp('.{1,800}'); // 800 is the size of each chunk
  pattern.allMatches(text).forEach((match) => print(match.group(0)));
}

toPx(double size){
  return size *1.5;
}

Future recordError(dynamic exception, StackTrace stack, {FlutterErrorDetails details}) async {
  // String device = 'Not Specified';
  // final String packageInfo = await PackageInfo.fromPlatform()
  //         .then((value) => '${value.version}+${value.buildNumber}');
  // if (Platform.isAndroid) {
  //   final dev = await DeviceInfoPlugin().androidInfo;
  //   final map = {
  //     'model': dev.model,
  //     'brand': dev.brand,
  //     'device': dev.device,
  //     'version-release': dev.version.release,
  //     'version-sdkInt': dev.version.sdkInt,
  //   };
  //   device = jsonEncode(map);
  // } else {
  //   final dev = await DeviceInfoPlugin().iosInfo;
  //   final map = {
  //     'name': dev.name,
  //     'model': dev.model,
  //     'systemName': dev.systemName,
  //     'systemVersion': dev.systemVersion,
  //     'localizedModel': dev.localizedModel,
  //   };
  //   device = jsonEncode(map);
  // }
  // todo record error
  // await FirebaseCrashlytics.instance
  //         .recordError(exception, stack, printDetails: true);
  // print('record Error : $exception');
  // final e = exception.toString();
  // final c = jsonEncode(Config.get.config);
  // await sendEmailAppbear(
  //         '''Version:$packageInfo\nDevice:$device\nError:$e\nStack:$stack\nDetails:$details\nConfig:$c''',
  //         errorEmailSubject,
  //         recipient: errorEmail);
}

Color rgboOrHex(String s) {
  try {
    if (s == null || s == '') {
      return Color(0xff000000);
    }
    Color color;
    if (s.contains('rgba')) {
      color = parseRGBO(s);
    } else {
      // print('the s 1: $s');
      if (s.length == 3) {
        s = '${s[0]}${s[0]}${s[1]}${s[1]}${s[2]}${s[2]}';
      }
      if (s.length == 4 && s[0] == '#') {
        s = '${s[0]}${s[1]}${s[1]}${s[2]}${s[2]}${s[3]}${s[3]}';
      }
      // print('the s : $s');
      color = HexColor(s);
    }
    return color;
  } catch (e) {
    print('the s : $s');
    print(e);
//    print(s);
    return Color(0xff000000);
  }
}

Color parseRGBO(String s) {
  s = s.substring(s.indexOf('(') + 1, s.indexOf(')'));
  // print('argb $s');
  int r = int.parse(s.split(',')[0]);
  int g = int.parse(s.split(',')[1]);
  int b = int.parse(s.split(',')[2]);
  double o = double.parse(s.split(',')[3]);
  return Color.fromRGBO(r, g, b, o);
}

showToast(String text, [bool success = true]) => Fluttertoast.showToast(
      msg: text,
      toastLength: Toast.LENGTH_LONG,
      backgroundColor: success ? Colors.green : Colors.red,
      gravity: ToastGravity.BOTTOM,
    );

showProgressDialog(BuildContext context) => showDialog(context: context,
  barrierDismissible: false,
  builder: (context) => WillPopScope(
    onWillPop:  ()async => true,
    child: Dialog(
      elevation: 0,
      backgroundColor: Colors.transparent,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            padding: EdgeInsets.all( 20),
            decoration: BoxDecoration(
                    color: Colors.white,
                    boxShadow: kElevationToShadow[24],
                    shape: BoxShape.rectangle,
                    borderRadius: BorderRadius.circular(5)
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              mainAxisSize: MainAxisSize.min,
              children: [
              Container(
                width: 24,
                height: 24,
                child: CircularProgressIndicator(
                  strokeWidth: 2,
                ),
              ),
              SizedBox(width: 10,),
              Text(tr(LocalKeys.please_wait)),
            ],),
          ),
        ],
      ),
    ),
  ),);

Future<String> getConfigFromCache() async {
  String c = await di<CacheHelper>().get('config');
  return c;
}

bool stringNotNullOrEmpty(String string) {
  return string != null && string.isNotEmpty && string != 'null';
}

bool isSvg(String url) {
  if (url?.endsWith('svg') ?? false) {
    return true;
  } else {
    return false;
  }
}
