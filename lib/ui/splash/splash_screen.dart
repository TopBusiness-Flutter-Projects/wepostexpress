import 'dart:async';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:wepostexpress/components/my_svg.dart';
import 'package:wepostexpress/models/user/user_model.dart';
import 'package:wepostexpress/ui/config_loader/config_loader_screen.dart';
import 'package:wepostexpress/ui/home/home_screen.dart';
import 'package:wepostexpress/ui/login/login_screen.dart';
import 'package:wepostexpress/ui/splash/bloc/splash_bloc.dart';
import 'package:wepostexpress/ui/splash/bloc/splash_events.dart';
import 'package:wepostexpress/ui/splash/bloc/splash_states.dart';
import 'package:wepostexpress/utils/cache/cache_helper.dart';
import 'package:wepostexpress/utils/config/config.dart';
import 'package:wepostexpress/utils/constants/app_keys.dart';
import 'package:wepostexpress/utils/constants/constants.dart';
import 'package:wepostexpress/utils/di/di.dart';
import 'package:wepostexpress/utils/global/global_bloc.dart';
import 'package:wepostexpress/utils/global/global_states.dart';
import 'package:wepostexpress/utils/network/repository.dart';

class SplashScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return BlocProvider<SplashBloc>(
      create: (BuildContext context) => di<SplashBloc>()..add(FetchSplashEvent()),
      child: BlocListener<SplashBloc, SplashStates>(
        listener: (BuildContext context, SplashStates state) async {
          if (state is ErrorSplashState) {
            showToast(state.error, false);
          }
          if (state is NavigateToConfigLoader) {
            Navigator.push(context, MaterialPageRoute(builder: (_) => ConfigLoaderScreen()));
          }
          if (state is SuccessSplashState) {
            Timer(Duration(seconds: 1), () async {
              final userData = await di<CacheHelper>().get(AppKeys.userData);
              if (userData != null ) {
                di<Repository>().user = UserModel.fromJson(userData);
                print('userData');
                print(di<Repository>().user);
                Navigator.pushReplacement(context, MaterialPageRoute(builder: (_) => HomeScreen()));
              } else {
                Navigator.pushReplacement(context, MaterialPageRoute(builder: (_) => LoginScreen()));
              }

            });
          }
        },
        child: Scaffold(
          backgroundColor:
              rgboOrHex(Config.get.styling[Config.get.themeMode].primary),
          body: Stack(
            children: [
              Column(
                children: [
                  Expanded(
                      child: MySVG(
                    svgPath: 'assets/icons/splash_background.svg',
                  )),
                  Spacer(),
                ],
              ),
              BlocBuilder<GlobalBloc, GlobalStates>(
                builder: (context, state) => Center(
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
        ),
      ),
    );
  }
}
