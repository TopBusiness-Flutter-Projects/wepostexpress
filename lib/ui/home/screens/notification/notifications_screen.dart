import 'dart:ffi';

import 'package:wepostexpress/components/empty_content.dart';
import 'package:wepostexpress/ui/mission_shipments/mission_shipments_screen.dart';
import 'package:conditional_builder/conditional_builder.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:wepostexpress/components/my_svg.dart';
import 'package:wepostexpress/components/step_tracker.dart';
import 'package:wepostexpress/ui/home/screens/notification/bloc/notification_events.dart';
import 'package:wepostexpress/ui/home/screens/notification/bloc/notification_states.dart';
import 'package:wepostexpress/ui/shipment_details/shipment_details_screen.dart';
import 'package:wepostexpress/utils/config/config.dart';
import 'package:wepostexpress/utils/constants/constants.dart';
import 'package:wepostexpress/utils/constants/local_keys.dart';
import 'package:wepostexpress/utils/di/di.dart';
import 'package:wepostexpress/utils/global/global_bloc.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';

import 'bloc/notification_bloc.dart';

class NotificationsScreen extends StatelessWidget {
  DateFormat dateFormat = DateFormat('yyyy-MM-dd hh:mm');
  RefreshController _refreshController = RefreshController(initialRefresh: false);

  @override
  Widget build(BuildContext context) {
    return BlocProvider<NotificationBloc>(
      create: (BuildContext context) => di<NotificationBloc>()..add(FetchNotificationEvent()),
      child: BlocListener<NotificationBloc, NotificationStates>(
        listener: (BuildContext context, NotificationStates state) async {
          if (state is ErrorNotificationState) {
            showToast(state.error, false);
          }
        },
        child:  Scaffold(
          body: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                height: (MediaQuery.of(context).size.height * (15.67 / 100)),
                width: MediaQuery.of(context).size.width,
                padding: EdgeInsets.zero,
                color: rgboOrHex(Config.get.styling[Config.get.themeMode].primary),
                alignment: Alignment.topCenter,
                child: Stack(
                  alignment: Alignment.topCenter,
                  children: [
                    SvgPicture.asset(
                      'assets/icons/notifications_bg.svg',
                      fit: BoxFit.cover,
                      color: rgboOrHex(Config.get.styling[Config.get.themeMode].primary),
                      width: MediaQuery.of(context).size.width,
                      height: MediaQuery.of(context).size.width,
                    ),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Expanded(
                          child: Center(
                            child: Padding(
                              padding: EdgeInsets.all(40.0),
                              child: MySVG(
                                    size: MediaQuery.of(context).size.height * (11 / 100),
                                    svgPath: 'assets/icons/logo.svg',
                                  ),

                            ),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
              Expanded(
                child: BlocBuilder<NotificationBloc,NotificationStates>(
                  builder:(context, state) =>  ConditionalBuilder(
                    condition: state is !LoadingNotificationState,
                    builder: (context) =>  buildNotificationList(context),
                    fallback: (context) => Center(
                      child: Padding(
                        padding: EdgeInsets.all(40.0),
                        child: Column(
                          mainAxisSize: MainAxisSize.max,
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            CircularProgressIndicator(),
                          ],
                        ),
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  SmartRefresher buildNotificationList(BuildContext context) {
    return SmartRefresher(
                    controller: _refreshController,
                    enablePullDown: true,
                    enablePullUp: false,
                    onRefresh: (){
                      BlocProvider.of<NotificationBloc>(context).add(FetchNotificationEvent());
                      _refreshController.loadComplete();
                    },

                    child: Container(
                      color: Color(0xffF7F7FB),
                      child: ConditionalBuilder(
                        condition: BlocProvider.of<NotificationBloc>(context).notifications.length>0,
                        builder: (context) => SingleChildScrollView(child: buildNotification(context)),
                        fallback: (context) => EmptyContent(
                          svgIconPath: 'assets/icons/empty.svg',
                          message: tr(LocalKeys.noDataFound),

                        ),
                      ),
                    ),
                  );
  }

  Widget buildNotification(BuildContext blocContext) {
    return ListView.builder(
      shrinkWrap: true,
      physics: NeverScrollableScrollPhysics(),
      itemCount: BlocProvider.of<NotificationBloc>(blocContext).notifications.length,
      itemBuilder: (BuildContext context, int index) {
        return Card(
          elevation: 10,
          shadowColor: Color(0xffF7F7FB),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(15),
          ),
          margin: EdgeInsets.symmetric(
              horizontal: MediaQuery.of(context).size.width * (4.2 / 100),
              vertical: MediaQuery.of(context).size.height * (2.4 / 100)),
          clipBehavior:Clip.antiAlias ,
          child: InkWell(
            onTap: (){
              if(BlocProvider.of<NotificationBloc>(blocContext).notifications[index].message_type!=null &&BlocProvider.of<NotificationBloc>(blocContext).notifications[index].message_type== 'mission'){
                Navigator.push(context,MaterialPageRoute(builder: (_)=> MissionShipmentsScreen(BlocProvider.of<NotificationBloc>(blocContext).notifications[index].id)));
              }else{
                Navigator.push(context,MaterialPageRoute(builder: (_)=> ShipmentDetailsScreen(code: BlocProvider.of<NotificationBloc>(blocContext).notifications[index].code,)));
              }
            },
            child:Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    SizedBox(
                      width: MediaQuery.of(context).size.width * (4.2 / 100),
                    ),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          SizedBox(
                            height: MediaQuery.of(context).size.height * (1.4 / 100),
                          ),
                          Text(
                            BlocProvider.of<NotificationBloc>(blocContext).notifications[index].code??'',
                            style: TextStyle(
                              color: rgboOrHex(
                                  Config.get.styling[Config.get.themeMode].primary),
                              fontSize: 16,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                        ],
                      ),
                    ),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.end,
                        children: [
                          SizedBox(
                            height: MediaQuery.of(context).size.height * (1.4 / 100),
                          ),
                          Text(
                            BlocProvider.of<NotificationBloc>(blocContext).notifications[index].created_at!=null?
                            dateFormat.format(dateFormat.parse(BlocProvider.of<NotificationBloc>(blocContext).notifications[index].created_at))
                            :'',
                            style: TextStyle(
                              color: rgboOrHex(
                                  Config.get.styling[Config.get.themeMode].primary),
                              fontSize: 12,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                        ],
                      ),
                    ),
                    SizedBox(
                      width: MediaQuery.of(context).size.height * (1.4 / 100),
                    ),
                    Container(
                      decoration: BoxDecoration(
                        color: Colors.redAccent,
                        borderRadius: BorderRadius.only(
                            topRight: Radius.circular(15.0), bottomLeft: Radius.circular(15.0)),
                      ),
                      padding: EdgeInsets.symmetric(
                        horizontal: MediaQuery.of(context).size.width * (2.6 / 100),
                        vertical: MediaQuery.of(context).size.height * (0.80 / 100),
                      ),
                      child: Icon(Icons.notifications,color: Colors.white,),
                    ),
                  ],
                ),
                SizedBox(
                  height: (MediaQuery.of(context).size.height * (1.2 / 100)) ,
                ),
               Container(
                 height: 0.5,
                 width: double.infinity,
                 color: rgboOrHex(Config.get.styling[Config.get.themeMode].secondaryVariant),
                 margin: EdgeInsets.symmetric(horizontal: MediaQuery.of(context).size.width * (4.2 / 100)),
               ),
                SizedBox(
                  height: MediaQuery.of(context).size.width * (4.2 / 100),
                ),
                Row(
                  children: [
                    SizedBox(
                      width: MediaQuery.of(context).size.width * (4.2 / 100),
                    ),
                    Expanded(
                      child: Text(
                        BlocProvider.of<NotificationBloc>(blocContext).notifications[index].content,
                        maxLines: null,
                        style: TextStyle(
                          // color: rgboOrHex(Config.get.styling[Config.get.themeMode].buttonTextColor),
                          fontSize: 14,
                          fontWeight: FontWeight.w400,
                        ),
                      ),
                    ),
                  ],
                ),
                SizedBox(
                  height: MediaQuery.of(context).size.width * (4.2 / 100),
                ),

              ],
            ),
          ),
        );
      },
    );
  }
}
