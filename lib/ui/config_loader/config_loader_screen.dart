import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:wepostexpress/ui/config_loader/bloc/config_loader_bloc.dart';
import 'package:wepostexpress/ui/config_loader/bloc/config_loader_events.dart';
import 'package:wepostexpress/ui/config_loader/bloc/config_loader_states.dart';
import 'package:wepostexpress/ui/splash/splash_screen.dart';
import 'package:wepostexpress/utils/cache/cache_helper.dart';
import 'package:wepostexpress/utils/config/config.dart';
import 'package:wepostexpress/utils/constants/app_keys.dart';
import 'package:wepostexpress/utils/constants/constants.dart';
import 'package:wepostexpress/utils/di/di.dart';
import 'package:wepostexpress/utils/global/global_bloc.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ConfigLoaderScreen extends StatelessWidget {
    @override
    Widget build(BuildContext context) {
        return BlocProvider<ConfigLoaderBloc>(
            create: (BuildContext context) => di<ConfigLoaderBloc>()..add(FetchConfigLoaderEvent()),
            child: BlocListener<ConfigLoaderBloc, ConfigLoaderStates>(
                listener: (BuildContext context, ConfigLoaderStates state) async {
                    if (state is ErrorConfigLoaderState) {
                        showToast(state.error, false);
                    }
                    if (state is LoadingConfigLoaderState) {
                        final localConfig = await getConfigFromCache();
                        if (di<CacheHelper>().get('config') !=null) {
                            final config = await rootBundle.loadString('assets/config.json');
                            await di<CacheHelper>().put('config', utf8.decode(config.codeUnits));
                            await Config.init(utf8.decode(config.codeUnits));

                            print('localConfig');
                            print(localConfig.codeUnits);
                            final s = utf8.decode(localConfig.codeUnits);
                            final c = await Config.init(s);
                            di.registerSingleton<Config>(c);
                            BlocProvider.of<ConfigLoaderBloc>(context).add(FetchedConfigLoaderEvent());
                        } else{
                            final config = await rootBundle.loadString('assets/config.json');
                            await di<CacheHelper>().put('config', utf8.decode(config.codeUnits));
                            di.registerSingleton<Config>(await Config.init(utf8.decode(config.codeUnits)));

                            BlocProvider.of<ConfigLoaderBloc>(context).add(FetchedConfigLoaderEvent());
                        }
                    }
                    if (state is SuccessConfigLoaderState) {
                        // BlocProvider.of<GlobalBloc>(context).path = await di<CacheHelper>().get(AppKeys.APP_LOGO_PATH);
                        print('dddddddddddddddddddddddddd');
                        // print(await di<CacheHelper>().get(AppKeys.APP_LOGO_PATH));
                        // print(  BlocProvider.of<GlobalBloc>(context).path );

                        Navigator.pushReplacement(context,MaterialPageRoute(builder: (_)=> SplashScreen()));
                    }
                },
                child: Scaffold(
                    body: Center(
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
        );
    }
}
