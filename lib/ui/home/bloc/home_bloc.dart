import 'dart:convert';

import 'package:wepostexpress/models/currency_model.dart';
import 'package:wepostexpress/models/user/user_model.dart';
import 'package:wepostexpress/utils/cache/cache_helper.dart';
import 'package:wepostexpress/utils/di/di.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:wepostexpress/models/mission_model.dart';
import 'package:wepostexpress/models/notification_model.dart';
import 'package:wepostexpress/models/shipment_model.dart';
import 'package:wepostexpress/models/shipments_response_model.dart';
import 'package:wepostexpress/ui/home/bloc/home_events.dart';
import 'package:wepostexpress/ui/home/bloc/home_states.dart';
import 'package:wepostexpress/ui/login/bloc/login_events.dart';
import 'package:wepostexpress/ui/login/bloc/login_states.dart';
import 'package:wepostexpress/ui/splash/bloc/splash_events.dart';
import 'package:wepostexpress/ui/splash/bloc/splash_states.dart';
import 'package:wepostexpress/utils/network/repository.dart';
import 'package:wepostexpress/utils/constants/app_keys.dart';
import 'package:shared_preferences/shared_preferences.dart';

class HomeBloc extends Bloc<HomeEvents, HomeStates> {
  final Repository _repository;
  CacheHelper cacheHelper = di<CacheHelper>();
  int currentIndex = 0 ;
  int shipmentPages = 0 ;
  List<MissionModel> currentMissions=[];
  List<MissionModel> receivedMissions=[];
  List<MissionModel> doneMissions=[];
  bool errorOccurred= false ;
  CurrencyModel currencyModel ;
  List<UserModel> branches= [];

  HomeBloc(this._repository) : super(InitialHomeState());

  static HomeBloc get(BuildContext context) => BlocProvider.of(context);

  @override
  Stream<HomeStates> mapEventToState(HomeEvents event) async*
  {
    if (event is FetchUserWalletEvent) {
      final f =await  _repository.getUserWallet();

      yield* f.fold((l) async*{
        errorOccurred = true;
        yield ErrorHomeState(l);
      }, (r) async*{

        yield SuccessWalletHomeState();
      });
    }

    if (event is FetchHomeEvent) {
      print('ssssssss');
      yield LoadingHomeState();
      final currentMissionsResponse =await  _repository.getMissions(AppKeys.APPROVED_STATUS_MISSION);
      final receivedMissionsResponse =await  _repository.getMissions(AppKeys.RECEIVED_STATUS_MISSION);
      final doneMissionsResponse =await  _repository.getMissions(AppKeys.DONE_STATUS_MISSION);
      final getCurrenciesResponse = await  _repository.getCurrencies();
      getCurrenciesResponse.fold((l)async* {
        yield ErrorHomeState(l);
      }, (r) {
        return currencyModel = r;
      });

      final getBranches = await  _repository.getBranches();
      yield* getBranches.fold((l)async* {
        errorOccurred = true;
        yield ErrorHomeState(l);
      }, (r)async *{
        branches = r;
      });

      final f = await cacheHelper.get(AppKeys.currentMissions);
      Map<String,dynamic> currentMap;
      if(f != null){
        print('fffffffffffff');
        print(f);
        currentMap =  await jsonDecode(f);
      }

      yield* currentMissionsResponse.fold((l) async*{
       yield ErrorHomeState(l);
      }, (r) async*{
        print('currentMissionsResponse');
        print(currentMissions.length);
        print(currentMissions);
        currentMissions = [...r];
      });

      yield* receivedMissionsResponse.fold((l) async*{
       yield ErrorHomeState(l);
      }, (r) async*{
        receivedMissions = r;
      });

      yield* doneMissionsResponse.fold((l) async*{
       yield ErrorHomeState(l);
      }, (r) async*{
        doneMissions = r;
      });
      if(currentMap !=null){
        print('currentMap');
        print(currentMap);
        print(currentMissions);
        Map<int, MissionModel> currentMissionsMap= {};
        List<MissionModel> currentMissionsList= [];
        List<MissionModel> currentMissionsListNot= [];
        for(int index =0; index < currentMissions.length; index ++){
          if(currentMap.containsKey(currentMissions[index].id)){
            print('addaddaddaddaddadd');
            print( currentMissionsMap);
            print( currentMissions[index]);
            print( currentMissions);
            print( currentMissions.length);
            currentMissionsMap.addAll({int.parse(currentMap[currentMissions[index].id]): currentMissions[index]});
          }else{
            currentMissionsListNot.add(currentMissions[index]);
          }
        }
        print('currentMissionsMap');
        currentMissionsMap.keys.toList(growable: false)..sort((k1, k2) => k1.compareTo(k2));
        print(currentMissionsMap);
        currentMissionsMap.forEach((key, value) {
          currentMissionsList.add(value);
        });
        print('currentMissionsList currentMissionsMap');
        print(currentMissionsMap);
        print(currentMissionsList);

        currentMissions = [
          ...currentMissionsList,
          ...currentMissionsListNot,
        ];
      }
      await saveCurrentList(currentMissions);
      yield SuccessHomeState();
    }

    if (event is FetchMoreHomeEvent) {
      shipmentPages+=1;
      yield LoadingMoreShipmentsHomeState();
    }

    if (event is HomePageChangedEvent) {
      yield SuccessChangedPageState();
    }

    if (event is HomePageListChangedEvent) {
      await saveCurrentList(currentMissions);
      yield SuccessListChangedPageState();
    }

    if (event is LogoutHomeEvent) {
      await _repository.logout();
      yield LogoutSuccessfullyHomeState();
    }
  }

  Future saveCurrentList(List<MissionModel> currentMissions)async {
    Map<String,String> currentMap= {};
    for(int  index = 0; index < currentMissions.length; index ++){
      if(currentMissions[index] !=null){
        currentMap.addAll({currentMissions[index].id: '$index'});
      }
    }
    await cacheHelper.put(AppKeys.currentMissions, jsonEncode(currentMap));
  }
}
