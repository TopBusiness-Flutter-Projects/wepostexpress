import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:wepostexpress/models/package_model.dart';

import 'new_order/address_new_order.dart';

class CreateOrderModel {
  CreateOrderModel(
      {
          @required this.shipment_type,
      @required this.shipment_branch_id,
      @required this.shipment_shipping_date,
      @required this.shipment_client_phone,
      @required this.shipment_client_address,
      @required this.shipment_reciver_name,
      @required this.shipment_reciver_phone,
      @required this.shipment_reciver_address,
      @required this.shipment_from_country_id,
      @required this.shipment_to_country_id,
      @required this.shipment_from_state_id,
      @required this.shipment_to_state_id,
      @required this.shipment_payment_type,
      @required this.shipment_payment_method_id,
      @required this.packages});

  @override
  String toString() {
    return jsonEncode(toJson());
  }

  toJson() {
      Map<String,String> shipmentPackages={};
      print('shipment_client_phone');
      print(shipment_client_phone);
      for (var index = 0; index <packages.length; index++) {
          print('shipmentsssss');
          print(packages[index].packageModel.toJson());
        shipmentPackages.addAll({
            'Package[$index][package_id]': packages[index].packageModel.id,
            'Package[$index][weight]': packages[index].weight,
        });
      }
      shipmentPackages.addAll({
          'Shipment[type]': shipment_type,
          'Shipment[branch_id]': shipment_branch_id,
          'Shipment[shipping_date]': shipment_shipping_date,
          'Shipment[client_phone]': shipment_client_phone,
          'Shipment[client_address]': shipment_client_address,
          'Shipment[reciver_name]': shipment_reciver_name,
          'Shipment[reciver_phone]': shipment_reciver_phone,
          'Shipment[reciver_address]': shipment_reciver_address,
          'Shipment[from_country_id]': shipment_from_country_id,
          'Shipment[to_country_id]': shipment_to_country_id,
          'Shipment[from_state_id]': shipment_from_state_id,
          'Shipment[to_state_id]': shipment_to_state_id,
          'Shipment[payment_type]': shipment_payment_type,
          'Shipment[payment_method_id]': shipment_payment_method_id,
      });
    return shipmentPackages;
  }

  // static fromJson(user) {
  //   return CreateOrderModel();
  // }

  final String shipment_type;
  final String shipment_branch_id;
  final String shipment_shipping_date;
  final String shipment_client_phone;
  final String shipment_client_address;
  final String shipment_reciver_name;
  final String shipment_reciver_phone;
  final String shipment_reciver_address;
  final String shipment_from_country_id;
  final String shipment_to_country_id;
  final String shipment_from_state_id;
  final String shipment_to_state_id;
  final String shipment_payment_type;
  final String shipment_payment_method_id;
  final List<AddressOrderModel> packages;
}
