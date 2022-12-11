import 'dart:convert';
import 'dart:io';

import 'package:wepostexpress/models/details_model.dart';

class SinglePackageShipmentModel {
    SinglePackageShipmentModel(
            {this.id,
      this.created_at,
      this.updated_at,
      this.package_id,
      this.shipment_id,
      this.description,
      this.weight,
      this.length,
      this.width,
      this.height,
      this.qty,
      this.package});

    @override
    String toString() {
        return jsonEncode(toJson());
    }

    toJson() {
        return {
            'id': id,
            'created_at': created_at,
            'updated_at': updated_at,
            'package_id': package_id,
            'shipment_id': shipment_id,
            'description': description,
            'weight': weight,
            'length': length,
            'width': width,
            'height': height,
            'qty': qty,
            'package': package,
        };
    }

    static fromJson(user) {
        return SinglePackageShipmentModel(
            id: (user['id']??'').toString(),
            created_at: user['created_at'],
            updated_at: user['updated_at'],
            package_id: (user['package_id']??'').toString(),
            shipment_id: (user['shipment_id']??'').toString(),
            description: user['description'],
            weight: (user['weight']??'').toString(),
            length: (user['length']??'').toString(),
            width: (user['width']??'').toString(),
            height: (user['height']??'').toString(),
            qty: (user['qty']??'').toString(),
            package: PackageSubModel.fromJson(user['package']),
        );
    }

    final String id;
    final String created_at;
    final String updated_at;
    final String package_id;
    final String shipment_id;
    final String description;
    final String weight;
    final String length;
    final String width;
    final String height;
    final String qty;
    final PackageSubModel package;
}

class PackageSubModel {
    PackageSubModel({this.id, this.name, this.created_at, this.updated_at, this.cost});

    @override
    String toString() {
        return jsonEncode(toJson());
    }

    toJson() {
        return {
            'id': id,
            'name': name,
            'created_at': created_at,
            'updated_at': updated_at,
            'cost': cost,
        };
    }

    static fromJson(user) {
        return PackageSubModel(
            id: user['id'].toString(),
            name: user['name'],
            created_at: user['created_at'],
            updated_at: user['updated_at'],
            cost: user['cost'].toString(),
        );
    }

    final String id;
    final String name;
    final String created_at;
    final String updated_at;
    final String cost;
}
