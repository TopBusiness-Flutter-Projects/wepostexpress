import 'dart:convert';

import 'package:wepostexpress/models/shipment_model.dart';

import 'package:wepostexpress/models/shipment_model.dart';

import 'package:wepostexpress/models/shipment_model.dart';

class ShipmentSettingsModel {
  ShipmentSettingsModel({
      this.id, this.key, this.value, this.created_at, this.updated_at});



    @override
    String toString() {
        return jsonEncode(toJson());
    }

    toJson() {
        return {
            'id': id,
            'key': key,
            'value': value,
            'created_at': created_at,
            'updated_at': updated_at,
        };
    }

    static fromJson(user) {
        return ShipmentSettingsModel(
            id: user['id'].toString(),
            key: user['key'],
            value: user['value'],
            created_at: user['created_at'],
            updated_at: user['updated_at'],
        );
    }

    final String id;
    final String key;
    final String value;
    final String created_at;
    final String updated_at;
}
/*
  {
        "id": 9,
        "key": "is_date_required",
        "value": "0",
        "created_at": null,
        "updated_at": "2021-06-27 12:19:59"
    },
*/