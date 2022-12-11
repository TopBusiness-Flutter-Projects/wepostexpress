import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:wepostexpress/components/my_svg.dart';
import 'package:wepostexpress/components/step_tracker.dart';
import 'package:wepostexpress/ui/home/bloc/home_bloc.dart';
import 'package:wepostexpress/ui/home/bloc/home_events.dart';
import 'package:wepostexpress/ui/home/bloc/home_states.dart';
import 'package:wepostexpress/ui/login/login_screen.dart';
import 'package:wepostexpress/utils/config/config.dart';
import 'package:wepostexpress/utils/constants/constants.dart';
import 'package:wepostexpress/utils/constants/local_keys.dart';
import 'package:wepostexpress/utils/di/di.dart';
import 'package:wepostexpress/utils/global/global_bloc.dart';
import 'package:wepostexpress/utils/network/repository.dart';
import 'package:modal_bottom_sheet/modal_bottom_sheet.dart';

class ProfileScreen extends StatefulWidget {
  @override
  _ProfileScreenState createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  @override
  void initState() {
    BlocProvider.of<HomeBloc>(context).add(FetchUserWalletEvent());

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<HomeBloc,HomeStates>(
      listener: (context, state) {
        if(state is LogoutSuccessfullyHomeState){
          Navigator.pushReplacement(context,MaterialPageRoute(builder: (_)=>LoginScreen()));
        }
        return ;
      },
      builder:(context, state) =>  Scaffold(
        appBar: AppBar(
          leadingWidth: 0,
          leading: Container(),
          backgroundColor: rgboOrHex(Config.get.styling[Config.get.themeMode].primary),
          title: Text(
            tr(LocalKeys.profile),
            style: TextStyle(
              color: rgboOrHex(Config.get.styling[Config.get.themeMode].buttonTextColor),
              fontWeight: FontWeight.w600,
            ),
          ),
        ),
        body: Container(
          width: double.infinity,
          child: Column(
            children: [
              Expanded(
                child: Column(
                  mainAxisSize: MainAxisSize.max,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    SizedBox(
                      height: MediaQuery.of(context).size.height * (1 / 100),
                    ),
                    Container(
                      decoration: BoxDecoration(
                              borderRadius: BorderRadius.all(Radius.circular(500)),
                              border: Border.all(width: 1,)
                      ),
                      child: CircleAvatar(
                        radius: 80,
                        backgroundColor: Colors.transparent,
                        child: Icon(Icons.person,
                          size: 150,
                          color: rgboOrHex(Config.get.styling[Config.get.themeMode].primary),
                        ),
                      ),
                    ),
                    SizedBox(
                      height: MediaQuery.of(context).size.height * (2 / 100),
                    ),
                    Container(
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.all(Radius.circular(50)),
                        color: rgboOrHex(Config.get.styling[Config.get.themeMode].primary).withOpacity(0.1),
                      ),
                      child: Padding(
                        padding: EdgeInsets.symmetric(horizontal: 8.0,vertical: 4),
                        child: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Icon(
                              Icons.account_circle_rounded,
                              size: 20,
                              color: rgboOrHex(Config.get.styling[Config.get.themeMode].primary),
                            ),
                            SizedBox(width: 5,),
                            Text(
                              di<Repository>().user.name,
                              style: TextStyle(
                                      color: rgboOrHex(Config.get.styling[Config.get.themeMode].primary),
                                      fontWeight: FontWeight.bold,
                                      fontSize: 16
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                    SizedBox(
                      height: MediaQuery.of(context).size.height * (2 / 100),
                    ),
                    Container(
                      decoration: BoxDecoration(
                              borderRadius: BorderRadius.all(Radius.circular(50)),
                              border: Border.all(width: 0.5,)
                      ),
                      child: Padding(
                        padding: EdgeInsets.symmetric(horizontal: 8.0,vertical: 4),
                        child: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Icon(
                              Icons.email,
                              size: 20,
                              // color: rgboOrHex(Config.get.styling[Config.get.themeMode].secondaryVariant),
                            ),
                            SizedBox(width: 5,),
                            Text(
                              di<Repository>().user.email,
                              style: TextStyle(
                                      color: rgboOrHex(Config.get.styling[Config.get.themeMode].secondaryVariant),
                                      fontWeight: FontWeight.w500,
                                      fontSize: 16
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                    SizedBox(
                      height: MediaQuery.of(context).size.height * (2 / 100),
                    ),
                    Container(
                      decoration: BoxDecoration(
                              borderRadius: BorderRadius.all(Radius.circular(50)),
                              border: Border.all(width: 0.5,)
                      ),
                      child: Padding(
                        padding: EdgeInsets.symmetric(horizontal: 8.0,vertical: 4),
                        child: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Icon(
                              Icons.smartphone_rounded,
                              size: 20,
                              // color: rgboOrHex(Config.get.styling[Config.get.themeMode].secondaryVariant),
                            ),
                            SizedBox(width: 5,),
                            Text(
                              di<Repository>().user.responsible_mobile??'',
                              style: TextStyle(
                                      color: rgboOrHex(Config.get.styling[Config.get.themeMode].secondaryVariant),
                                      fontWeight: FontWeight.w500,
                                      fontSize: 16
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                    SizedBox(
                      height: MediaQuery.of(context).size.height * (2 / 100),
                    ),
                    Container(
                      decoration: BoxDecoration(
                              borderRadius: BorderRadius.all(Radius.circular(50)),
                              border: Border.all(width: 0.5,)
                      ),
                      child: Padding(
                        padding: EdgeInsets.symmetric(horizontal: 8.0,vertical: 4),
                        child: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Icon(
                              Icons.account_balance_wallet,
                              size: 20,
                              // color: rgboOrHex(Config.get.styling[Config.get.themeMode].secondaryVariant),
                            ),
                            SizedBox(width: 5,),
                            Text(
                              (di<Repository>().user.balance != null && di<Repository>().user.balance != 'null')?di<Repository>().user.balance:'0',
                              style: TextStyle(
                                      color: rgboOrHex(Config.get.styling[Config.get.themeMode].secondaryVariant),
                                      fontWeight: FontWeight.w500,
                                      fontSize: 16
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                    SizedBox(
                      height: MediaQuery.of(context).size.height * (4 / 100),
                    ),
                    Container(
                      margin: EdgeInsets.symmetric(horizontal: MediaQuery.of(context).size.width * (10 / 100)),
                      child: Text(
                        tr(LocalKeys.captain_credit_message),
                        style: TextStyle(fontSize: 16,fontWeight: FontWeight.w400,letterSpacing:0.7),
                      ),
                    ),
                  ],
                ),
              ),
              Container(
                width: double.infinity,
                color: rgboOrHex(Config.get.styling[Config.get.themeMode].secondaryVariant).withOpacity(0.20),
                height: 1,
              ),
              SizedBox(
                height: MediaQuery.of(context).size.height * (1 / 100),
              ),
              InkWell(
                onTap: () {
                  return showList(context);
                },
                child: Padding(
                  padding: EdgeInsets.symmetric(
                          horizontal: MediaQuery.of(context).size.width * (6.4 / 100)),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      SizedBox(
                        height: MediaQuery.of(context).size.height * (1 / 100),
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Expanded(
                            child: Text(
                              tr(LocalKeys.language),
                              style: TextStyle(fontSize: 14),
                            ),
                          ),
                          Text(
                            tr(LocalKeys.english),
                            style: TextStyle(fontSize: 14),
                          ),
                          Icon(
                            Icons.arrow_drop_down,
                            size: 24,
                          ),
                        ],
                      ),
                      SizedBox(
                        height: MediaQuery.of(context).size.height * (1 / 100),
                      ),
                    ],
                  ),
                ),
              ),
              SizedBox(
                height: MediaQuery.of(context).size.height * (1 / 100),
              ),
              InkWell(
                onTap: () {
                  BlocProvider.of<HomeBloc>(context).add(LogoutHomeEvent());
                },
                child: Padding(
                  padding: EdgeInsets.symmetric(
                          horizontal: MediaQuery.of(context).size.width * (6.4 / 100)),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      SizedBox(
                        height: MediaQuery.of(context).size.height * (1 / 100),
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            tr(LocalKeys.logout),
                            style: TextStyle(fontSize: 14),
                          ),
                          Icon(
                            Icons.logout,
                            size: 24,
                          ),
                        ],
                      ),
                      SizedBox(
                        height: MediaQuery.of(context).size.height * (1 / 100),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  showList(BuildContext context) async {
    final blocContext = context;
    await showMaterialModalBottomSheet(
      backgroundColor: Colors.transparent,
      context: context,
      builder: (context) => Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.only(
            topRight: Radius.circular(20),
            topLeft: Radius.circular(20),
          ),
          color: Colors.white,
        ),
        child: SingleChildScrollView(
          child: Column(
            children: [
              MaterialButton(
                onPressed: () => Navigator.pop(context),
                padding: EdgeInsets.symmetric(
                        horizontal: MediaQuery.of(context).size.width * (6.4 / 100),
                        vertical: MediaQuery.of(context).size.width * (3.4 / 100)),
                child: Container(
                  width: double.infinity,
                  child: Text(tr(LocalKeys.english)),
                ),
              ),
              MaterialButton(
                color: rgboOrHex(Config.get.styling[Config.get.themeMode].dividerColor),
                elevation: 0,
                onPressed: () => Navigator.pop(context),
                padding: EdgeInsets.symmetric(
                        horizontal: MediaQuery.of(context).size.width * (6.4 / 100),
                        vertical: MediaQuery.of(context).size.width * (3.4 / 100)),
                child: Container(
                  width: double.infinity,
                  child: Text(tr(LocalKeys.cancel)),
                ),
              ),
              SizedBox(
                height: MediaQuery.of(context).size.width * (3.4 / 100),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
