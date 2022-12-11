import 'dart:io';

import 'package:wepostexpress/models/currency_model.dart';
import 'package:wepostexpress/models/mission_confirmation_type_model.dart';
import 'package:wepostexpress/models/mission_model.dart';
import 'package:wepostexpress/models/reasons_model.dart';
import 'package:wepostexpress/models/user/user_model.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:wepostexpress/models/create_mission_model.dart';
import 'package:wepostexpress/models/payment_method_model.dart';
import 'package:wepostexpress/models/shipment_model.dart';
import 'package:wepostexpress/ui/config_loader/bloc/config_loader_events.dart';
import 'package:wepostexpress/ui/config_loader/bloc/config_loader_states.dart';
import 'package:wepostexpress/ui/mission_shipments/bloc/mission_shipments_events.dart';
import 'package:wepostexpress/ui/mission_shipments/bloc/mission_shipments_states.dart';
import 'package:wepostexpress/ui/splash/bloc/splash_events.dart';
import 'package:wepostexpress/ui/splash/bloc/splash_states.dart';
import 'package:wepostexpress/utils/cache/cache_helper.dart';
import 'package:wepostexpress/utils/config/config.dart';
import 'package:wepostexpress/utils/constants/app_keys.dart';
import 'package:wepostexpress/utils/di/di.dart';
import 'package:wepostexpress/utils/network/repository.dart';

class MissionShipmentsBloc extends Bloc<MissionShipmentsEvents, MissionShipmentsStates> {
  final Repository _repository;
  List<ShipmentModel> shipments=[];
  List<ShipmentModel> checkedShipments=[];
  List<PaymentMethodModel> paymentTypes= [];
  List<ReasonsModel> reasons= [];
  MissionConfirmationType missionConfirmationType;
  File image;
  MissionModel missionModel;
  bool errorOccurred= false ;
  CurrencyModel currencyModel ;
  List<UserModel> branches= [];

  MissionShipmentsBloc(this._repository) : super(InitialMissionShipmentsState());

  static MissionShipmentsBloc get(BuildContext context) => BlocProvider.of(context);

  @override
  Stream<MissionShipmentsStates> mapEventToState(MissionShipmentsEvents event) async*
  {
    if(event is CheckedShipmentMissionShipmentsEvent){
      yield ShipmentCheckedMissionShipmentsState();
    }

    if(event is DeleteShipmentFromMissionEvent){
      yield LoadingMissionShipmentsState();
      final f =await  _repository.deleteShipmentFromMission(event.reasonsModel,event.missionId,event.shipmentId);

      yield* f.fold((l) async*{
        yield ErrorMissionShipmentsState(l);
      }, (r) async*{
        print('ddddddddd');
        yield ShipmentRemovedSuccessfullyMissionShipmentsState();
      });
    }

    if(event is ChangeMissionStatusEvent){
      yield LoadingMissionShipmentsState();

      if(event.isPickup){
        final f =await  _repository.changeMissionStatus(
                image: event.image,
                to: event.to,
                shipment_id: event.shipment_id,
                amount: event.missionModel.amount,
                checked_ids: event.missionModel.id,
                otp_confirm: '');

        yield* f.fold((l) async*{
          yield ErrorMissionShipmentsState(l);
        }, (r) async*{
          print('ddddddddd');
          yield ShipmentChangedSuccessfullyMissionShipmentsState();
        });
      }else{
        final f =await  _repository.changeMissionStatus(
                to: event.to,
                shipment_id: event.shipment_id,
                image: event.image,
                amount: event.missionModel.amount,
                checked_ids: event.missionModel.id,
                otp_confirm: event.otp_confirm);

        yield* f.fold((l) async*{
          yield ErrorMissionShipmentsState(l);
        }, (r) async*{
          print('ddddddddd');
          yield ShipmentChangedSuccessfullyMissionShipmentsState();
        });
      }
    }

    if (event is FetchMissionShipmentsEvent) {
      yield LoadingMissionShipmentsState();

      final getPaymentTypesResponse = await _repository.getPaymentTypes();
      getPaymentTypesResponse.fold((l)async* {
        yield ErrorMissionShipmentsState(l);
      }, (r) {
        paymentTypes = r;
      });

      final getReasonsResponse = await _repository.getReasons();
      getReasonsResponse.fold((l)async* {
        yield ErrorMissionShipmentsState(l);
      }, (r) {
        return reasons = r;
      });

      final f =await  _repository.getMissionShipments(id: event.missionID);
      final getSingleMission =await  _repository.getSingleMission(id: event.missionID);
      final missionType =await  _repository.getMissionConfirmation();
      final getCurrenciesResponse = await  _repository.getCurrencies();
      getCurrenciesResponse.fold((l)async* {
        yield ErrorMissionShipmentsState(l);
      }, (r) {
        return currencyModel = r;
      });

      if(branches.length == 0){
        final getBranches = await  _repository.getBranches();
        yield* getBranches.fold((l)async* {
          errorOccurred = true;
          yield ErrorMissionShipmentsState(l);
        }, (r)async *{
          branches = r;
        });
      }

      yield* missionType.fold((l) async*{
        yield ErrorMissionShipmentsState(l);
      }, (r) async*{
        print('missionConfirmationType');
        print(r);
        missionConfirmationType = r;
      });
      yield* getSingleMission.fold((l) async*{
        yield ErrorMissionShipmentsState(l);
      }, (r) async*{
        print('missionModelmissionModel');
        print(r);
        missionModel = r;
      });

      yield* f.fold((l) async*{
        yield ErrorMissionShipmentsState(l);
      }, (r) async*{
        shipments = r;
        print('rrrr.length');
        print(paymentTypes.length);
        print(shipments.length);
        yield SuccessMissionShipmentsState();
      });
    }
  }
}
