import 'dart:io';

import 'package:conditional_builder/conditional_builder.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:wepostexpress/utils/config/config.dart';
import 'package:wepostexpress/utils/constants/constants.dart';

class MySVG extends StatelessWidget {
  MySVG({this.svgPath, this.size,this.fromFiles,this.imagePath});

  String svgPath;
  double size;
  String imagePath;
  bool fromFiles = false;

  @override
  Widget build(BuildContext context) {
    return Container(
      child: ConditionalBuilder(
        condition: fromFiles == null ||!fromFiles,
        builder: (context) => ConditionalBuilder(
          condition: svgPath == null && !isSvg(
                  ''//Config.get.logo.dark
          ),
          builder: (context) => Image(
            image: NetworkImage(
                    ''//Config.get.logo.dark,
            ),
            height: size ?? 60,
            fit: BoxFit.contain,
          ),
          fallback: (context) => svgPath != null
                  ? SvgPicture.asset(svgPath)
                  : SvgPicture.network(
            '',//Config.get.logo.dark,
            height: 60,
          ),
        ),
        fallback: (context) => Image(image: FileImage(File(imagePath??''))),
      ),
    );
  }
}
