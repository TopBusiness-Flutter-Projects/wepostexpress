
import 'package:conditional_builder/conditional_builder.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

import '../utils/config/config.dart';
import '../utils/constants/constants.dart';

class EmptyContent extends StatelessWidget {
  EmptyContent({
    Key key,
    this.svgIconPath,
    this.withCircle,
    this.hasEmptyHeight=false,
    this.icon = Icons.access_alarm,
    @required this.message ,
  }) : super(key: key);
  final IconData icon;
  final String svgIconPath;
  final String message;
  final bool hasEmptyHeight ;
  bool withCircle =false;

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.white,
      width: double.infinity,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        mainAxisSize: MainAxisSize.max,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: <Widget>[
          if(hasEmptyHeight)
            SizedBox(height: MediaQuery.of(context).size.height * 0.15,),
          ConditionalBuilder(
            condition: svgIconPath == null,
            builder: (context) => Icon(icon, size: 50, color: Color(0xffDDDDDD)),
            fallback: (context) => Container(
              padding: EdgeInsets.all(withCircle!= null && withCircle?(21):0),
              decoration: withCircle!= null && withCircle ?BoxDecoration(
                borderRadius: BorderRadius.circular(100),
                color: Color(0xff46017b).withOpacity(0.07),
              ):BoxDecoration(),
              child: SvgPicture.asset(
                svgIconPath,
                width: 60,
                height: 60,
              ),
            ),
          ),
          SizedBox(
            height: 10,
          ),
          Text(
            message,
            style: TextStyle(fontSize: 16.0, color: rgboOrHex(Config.get.styling[Config.get.themeMode].secondaryVariant)),
          ),
          if(hasEmptyHeight)
            SizedBox(height: MediaQuery.of(context).size.height * 0.15,),       ],
      ),
    );
  }
}
