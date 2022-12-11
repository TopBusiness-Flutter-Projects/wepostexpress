import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:wepostexpress/models/shipment_model.dart';

import 'new_order/address_new_order.dart';

class CreateMissionModel {
  CreateMissionModel({
      @required this.clientToBranchId,
      @required this.clientAddress,
      @required this.clientId,
      @required this.checkedShipments,
      @required this.type,
      });

  @override
  String toString() {
    return jsonEncode(toJson());
  }

  toJson() {
    Map<String, String> shipmentPackages = {};

    for (var index = 0; index < checkedShipments.length; index++) {
      shipmentPackages.addAll({
        'checked_ids[$index]': checkedShipments[index].id,
      });
    }

    shipmentPackages.addAll({
      'type': type,
      'Mission[client_id]': clientId,
      'Mission[address]': clientAddress,
      'Mission[to_branch_id]': clientToBranchId,
    });
    return shipmentPackages;
  }

  // static fromJson(user) {
  //   return CreateMissionModel();
  // }

  final String type;
  final String clientId;
  final String clientAddress;
  final String clientToBranchId;
  final List<ShipmentModel> checkedShipments;
}