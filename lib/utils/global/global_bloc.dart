import 'package:connectivity/connectivity.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:wepostexpress/ui/home/bloc/home_events.dart';
import 'package:wepostexpress/ui/home/bloc/home_states.dart';
import 'package:wepostexpress/ui/login/bloc/login_events.dart';
import 'package:wepostexpress/ui/login/bloc/login_states.dart';
import 'package:wepostexpress/ui/splash/bloc/splash_events.dart';
import 'package:wepostexpress/ui/splash/bloc/splash_states.dart';
import 'package:wepostexpress/utils/cache/cache_helper.dart';
import 'package:wepostexpress/utils/constants/app_keys.dart';
import 'package:wepostexpress/utils/di/di.dart';
import 'package:wepostexpress/utils/global/global_events.dart';
import 'package:wepostexpress/utils/global/global_states.dart';
import 'package:wepostexpress/utils/network/repository.dart';

class GlobalBloc extends Bloc<GlobalEvents, GlobalStates> {
  final Repository _repository;
  final connectivity = Connectivity();
  bool online = true;
  bool loading = false;
  bool popupOpened = false;

  // String path = '' ;


  GlobalBloc(this._repository) : super(InitialGlobalState());

  static GlobalBloc get(BuildContext context) => BlocProvider.of(context);

  @override
  Stream<GlobalStates> mapEventToState(GlobalEvents event) async*
  {
    if (event is FetchGlobalLogoEvent) {
      // path = await di<CacheHelper>().get(AppKeys.APP_LOGO_PATH);
      // print('BlocProvider.of<GlobalBloc>(context).path11111');
      yield SuccessGlobalState();
    }
    if (event is ConnectionChangedGlobalEvent) {
      yield ConnectionChangedGlobalState(event.isOnline);
    }
  }

  checkConnectivity() {
    print('bbbbbbbbbbbbbbb');

    connectivity.checkConnectivity().then((value) {
      print('dddddddddd');
      if (value == ConnectivityResult.none) {
        online = false;
      } else {
        online = true;
      }
      loading = false;
      add(ConnectionChangedGlobalEvent(online));
    });
    connectivity.onConnectivityChanged.listen((event) {
      print('dddddddddd2');
      if (event == ConnectivityResult.none) {
        online = false;
      } else {
        online = true;
      }
      loading = false;
      add(ConnectionChangedGlobalEvent(online));
    });
  }


}
