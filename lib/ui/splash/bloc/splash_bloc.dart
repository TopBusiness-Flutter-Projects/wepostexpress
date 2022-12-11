import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:wepostexpress/ui/splash/bloc/splash_events.dart';
import 'package:wepostexpress/ui/splash/bloc/splash_states.dart';
import 'package:wepostexpress/utils/cache/cache_helper.dart';
import 'package:wepostexpress/utils/config/config.dart';
import 'package:wepostexpress/utils/constants/app_keys.dart';
import 'package:wepostexpress/utils/di/di.dart';
import 'package:wepostexpress/utils/network/repository.dart';

class SplashBloc extends Bloc<SplashEvents, SplashStates> {
  final Repository _repository;


  SplashBloc(this._repository) : super(InitialSplashState());

  static SplashBloc get(BuildContext context) => BlocProvider.of(context);

  @override
  Stream<SplashStates> mapEventToState(SplashEvents event) async*
  {
    if (event is FetchSplashEvent) {
      // final path = await di<CacheHelper>().get(AppKeys.APP_LOGO_PATH) ;
      // print('dasdsadadasdsadadasdsada');
      // print(path);
      // if(path==null){
      //   yield NavigateToConfigLoader();
      // }else{
        yield SuccessSplashState();

      // }
    }
  }


}
