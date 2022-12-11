import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:http/http.dart';

class CustomSvgLoader extends StatelessWidget {
  final String url;

  const CustomSvgLoader({Key key, @required this.url}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<Response>(
      future: get(Uri.parse(url)),
      builder: (context, response) {
        try {
          if (response.hasData) {
            final r = response.data;
            if (r?.statusCode == 200) {
              return SvgPicture.string(r.body);
            } else {
              throw 'not 200';
            }
          } else {
            throw response.error;
          }
        } catch (e, s) {
          print(e);
          print(s);
          return Container();
        }
      },
    );
  }
}
