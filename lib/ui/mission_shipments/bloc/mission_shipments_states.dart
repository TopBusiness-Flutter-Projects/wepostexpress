import 'package:flutter/foundation.dart';

@immutable
abstract class MissionShipmentsStates {
  const MissionShipmentsStates();
}

class InitialMissionShipmentsState extends MissionShipmentsStates {}

class LoadingMissionShipmentsState extends MissionShipmentsStates {}
class LoadingCreatingMissionState extends MissionShipmentsStates {}

class SuccessMissionShipmentsState extends MissionShipmentsStates {}
class ShipmentCheckedMissionShipmentsState extends MissionShipmentsStates {}
class ShipmentRemovedSuccessfullyMissionShipmentsState extends MissionShipmentsStates {}
class ShipmentChangedSuccessfullyMissionShipmentsState extends MissionShipmentsStates {}
class MissionCreatedSuccessfullyMissionState extends MissionShipmentsStates {}

class ErrorMissionShipmentsState extends MissionShipmentsStates {
  final String error;

  ErrorMissionShipmentsState(this.error);
}