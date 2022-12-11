import 'dart:io';

import 'package:wepostexpress/models/mission_model.dart';
import 'package:wepostexpress/models/reasons_model.dart';
import 'package:flutter/foundation.dart';

@immutable
abstract class MissionShipmentsEvents {
  const MissionShipmentsEvents();
}

class MissionShipmentsEvent extends MissionShipmentsEvents {}

class FetchMissionShipmentsEvent extends MissionShipmentsEvents {
  final String missionID;

  FetchMissionShipmentsEvent(this.missionID);
}

class FetchedMissionShipmentsEvent extends MissionShipmentsEvents {}

class DeleteShipmentFromMissionEvent extends MissionShipmentsEvents {
  final ReasonsModel reasonsModel;

  final String missionId;

  final String shipmentId;

  DeleteShipmentFromMissionEvent({
    this.reasonsModel,
    this.missionId,
    this.shipmentId,
  });
}

class ChangeMissionStatusEvent extends MissionShipmentsEvents {
  final MissionModel missionModel;
  final String otp_confirm;
  final String amount;
  final String to;
  final String checked_ids;
  final String shipment_id;
  final bool isPickup;
  final List<int> image;

  ChangeMissionStatusEvent(
      {
       this.missionModel,
       this.to,
       this.otp_confirm,
       this.amount,
       this.shipment_id,
       this.isPickup,
       this.checked_ids,
       this.image});
}

class CheckedShipmentMissionShipmentsEvent extends MissionShipmentsEvents {}
