import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:wepostexpress/utils/config/config.dart';
import 'package:wepostexpress/utils/constants/constants.dart';

class StepTracker extends StatefulWidget {
  StepTracker({@required this.title,  this.icon, @required this.isLast});

  final String title;
  final bool isLast;
  final IconData icon;

  @override
  _StepTrackerState createState() => _StepTrackerState();
}

class _StepTrackerState extends State<StepTracker> {
  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsetsDirectional.only(top: 4.5, end: 20),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.start,
        children: <Widget>[
          Column(
            children: <Widget>[
              Container(
                padding: const EdgeInsets.only(bottom: 4.5),
                color: Colors.white,
                child: Stack(
                  alignment: Alignment.center,
                  children: [
                    ClipOval(
                      child: SizedBox.fromSize(
                        size: Size.square(13),
                        child: Container(
                          color:
                              rgboOrHex(Config.get.styling[Config.get.themeMode].secondaryVariant),
                        ),
                      ),
                    ),
                    if (widget.isLast)
                      ClipOval(
                        child: SizedBox.fromSize(
                          size: Size.square(7),
                          child: Container(
                            color: Color(0xffffffff),
                          ),
                        ),
                      ),
                  ],
                ),
              ),
              if (!widget.isLast)
                Container(
                  width: 1,
                  child: ListView.builder(
                    itemCount: 3,
                    shrinkWrap: true,
                    itemBuilder: (context, index) => Column(
                      children: [
                        if (index != 4 && index != 0)
                          SizedBox(
                            height: 5,
                          ),
                        Container(
                          height: (MediaQuery.of(context).size.height * (2.2 / 100)) / 3,
                          width: 3,
                          color: Color(0xff4C1FA2),
                        ),
                      ],
                    ),
                  ),
                ),
            ],
          ),
          SizedBox(
            width: MediaQuery.of(context).size.width * (1.2 / 100),
          ),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Text(
                  widget.title,
                  strutStyle: StrutStyle(
                    fontSize: 9.3 * 1.5,
                    height: 1,
                    fontWeight: FontWeight.bold,
                    leading: 0,
                    forceStrutHeight: true,
                  ),
                  style: TextStyle(
                    fontSize: 9.3 * 1.5,
                    height: 1.5,
                    color: rgboOrHex(Config.get.styling[Config.get.themeMode].secondaryVariant),
                    fontWeight: FontWeight.bold,
                  ),
                ),
                SizedBox(height: 9),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
