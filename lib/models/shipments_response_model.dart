import 'dart:convert';

import 'package:wepostexpress/models/shipment_model.dart';

class ShipmentResponseModel {
  ShipmentResponseModel({
    this.current_page,
    this.data,
    this.last_page
  });

  static fromJson(user) {
    List<ShipmentModel> ships=[];

    for(int index = 0; index < (user['data'] as List).length;index++  ){
      ships.add(ShipmentModel.fromJson(user['data'][index]));
    }

    return ShipmentResponseModel(
      current_page: user['current_page'].toString(),
      data: ships,
      last_page: user['last_page'].toString(),
    );
  }

  final String current_page;
  final List<ShipmentModel> data;
  final String last_page;
}

