import 'package:wepostexpress/utils/global/global_bloc.dart';
import 'package:wepostexpress/utils/global/global_states.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:wepostexpress/components/main_button.dart';
import 'package:wepostexpress/components/my_svg.dart';
import 'package:wepostexpress/ui/home/bloc/home_bloc.dart';
import 'package:wepostexpress/ui/home/bloc/home_events.dart';
import 'package:wepostexpress/ui/home/bloc/home_states.dart';
import 'package:wepostexpress/ui/home/screens/notification/notifications_screen.dart';
import 'package:wepostexpress/ui/home/screens/profile/profile_screen.dart';
import 'package:wepostexpress/ui/home/screens/single_home/single_home_screen.dart';
import 'package:wepostexpress/ui/login/bloc/login_bloc.dart';
import 'package:wepostexpress/ui/login/bloc/login_events.dart';
import 'package:wepostexpress/ui/login/bloc/login_states.dart';
import 'package:wepostexpress/utils/config/config.dart';
import 'package:wepostexpress/utils/constants/constants.dart';
import 'package:wepostexpress/utils/constants/local_keys.dart';
import 'package:wepostexpress/utils/di/di.dart';
import 'package:modal_bottom_sheet/modal_bottom_sheet.dart';

class HomeScreen extends StatelessWidget {
  final PageController pageController = PageController();
  HomeScreen();

  @override
  Widget build(BuildContext context) {
    return BlocProvider<HomeBloc>(
      create: (BuildContext context) {
        BlocProvider.of<GlobalBloc>(context).checkConnectivity();
        return (di<HomeBloc>()..add(FetchHomeEvent(forFirstTime: true)));
      },
      child: BlocListener<GlobalBloc, GlobalStates>(
        listener: (c, state) {
          if(state is ConnectionChangedGlobalState){
            print(state.isOnline);
            if(state.isOnline){
              if(BlocProvider.of<GlobalBloc>(context).popupOpened){
                Navigator.pop(context);
                BlocProvider.of<GlobalBloc>(context).popupOpened= false;
              }
            }else{
              if(!BlocProvider.of<GlobalBloc>(context).popupOpened){
                BlocProvider.of<GlobalBloc>(context).popupOpened= true;
                return showConnectionDialog(c);
              }
            }
          }

        },
        child: BlocListener<HomeBloc, HomeStates>(
          listener: (BuildContext context, HomeStates state) async {
            if (state is ErrorHomeState) {
              showToast(state.error, false);
            }
          },
          child: Scaffold(
            bottomNavigationBar: BlocBuilder<HomeBloc,HomeStates>(
              builder: (context, state) => BottomNavigationBar(
                onTap: (index) {
                  BlocProvider.of<HomeBloc>(context).currentIndex = index;
                  pageController.animateToPage(index, duration: Duration(milliseconds: 10), curve: Curves.bounceIn);
                  BlocProvider.of<HomeBloc>(context).add(HomePageChangedEvent());
                },
                currentIndex: BlocProvider.of<HomeBloc>(context).currentIndex,
                items: [
                BottomNavigationBarItem(icon: Icon(Icons.home_outlined),label: tr(LocalKeys.home)),
                BottomNavigationBarItem(icon: Icon(Icons.notifications),label: tr(LocalKeys.notifications)),
                BottomNavigationBarItem(icon: Icon(Icons.account_box_rounded),label: tr(LocalKeys.profile)),
              ],

              ),
            ),
            body: SafeArea(
              child: Builder(
                builder: (context) => BlocBuilder<HomeBloc,HomeStates>(
                  builder: (context, state) => PageView(
                    controller: pageController,
                    physics: NeverScrollableScrollPhysics(),
                    allowImplicitScrolling: false,
                    onPageChanged: (index){
                    },
                    children: [
                      HomeSingleScreen(),
                        NotificationsScreen(),
                        ProfileScreen(),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  showConnectionDialog(BuildContext context) async {
    final blocContext = context;
    return await showMaterialModalBottomSheet(
      enableDrag: false,
      isDismissible: false,
      backgroundColor: Colors.transparent,
      context: context,
      builder: (context) => WillPopScope(
        onWillPop: () async {
          return false;
        },
        child: Scaffold(
          body: SafeArea(
            child: Container(
                    width: double.infinity,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.only(
                        topRight: Radius.circular(20),
                        topLeft: Radius.circular(20),
                      ),
                      color: Colors.white,
                    ),
                    child: SafeArea(
                      child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              mainAxisSize: MainAxisSize.max, children: <Widget>[
                        Column(crossAxisAlignment: CrossAxisAlignment.center, children: <Widget>[
                          MySVG(
                            size: 11,
                            svgPath: 'assets/icons/logo.svg'
                          ),
                          SizedBox(height: MediaQuery.of(context).size.height * 0.10),
                          SizedBox(
                            height: MediaQuery.of(context).size.width * 0.50,
                            child: MySVG(
                              size: 11,
                              svgPath: 'assets/icons/no-internet.svg',
                            ),
                          ),
                          SizedBox(height: MediaQuery.of(context).size.height * 0.05),
                          Text(
                            tr(LocalKeys.noConnection),
                            style: TextStyle(
                              fontSize: 18,
                            ),
                          ),
                          SizedBox(height: MediaQuery.of(context).size.height * 0.05),
                          Padding(
                            padding: EdgeInsets.symmetric(horizontal: MediaQuery.of(context).size.width * 0.10),
                            child: MainButton(onPressed: (){
                              BlocProvider.of<GlobalBloc>(context).checkConnectivity();
                            }, text: tr(LocalKeys.refresh), color: rgboOrHex(Config.get.styling[Config.get.themeMode].primary), textColor: rgboOrHex(Config.get.styling[Config.get.themeMode].buttonTextColor)),
                          )
                        ],
                        ),
                        // SizedBox(height: 82.7 * 1.5),
                      ]),
                    )
            ),
          ),
        ),
      ),
    ).then((value) {
      BlocProvider.of<GlobalBloc>(context).popupOpened= false;
      return null;
    });
  }

}
