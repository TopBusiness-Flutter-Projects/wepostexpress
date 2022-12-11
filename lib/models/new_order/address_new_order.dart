import 'dart:convert';
import 'dart:io';

import 'package:wepostexpress/models/package_model.dart';
import 'package:wepostexpress/models/user/user_model.dart';

class AddressOrderModel {
    AddressOrderModel(
            {
                this.index,
                this.packageModel,
                this.quantity,
                this.weight,
                this.weightUnit,
                this.height,
                this.heightUnit,
                this.width,
                this.widthUnit,
                this.length,
                this.lengthUnit,
                this.description,
            });

    @override
    String toString() {
        return jsonEncode(toJson());
    }

    Map<String, String> toJson() {
        return  {
            'packageModel': packageModel.toJson(),
            'quantity': quantity,
            'weight': weight,
            'weightUnit': weightUnit,
            'height': height,
            'heightUnit': heightUnit,
            'width': width,
            'widthUnit': widthUnit,
            'length': length,
            'lengthUnit': lengthUnit,
            'description': description,
        };
    }

    static fromJson(user) {
        return AddressOrderModel(
            packageModel: AddressOrderModel.fromJson(user['packageModel']),
            quantity: user['quantity'],
            weight: user['weight'],
            weightUnit: user['weightUnit'],
            height: user['height'],
            heightUnit: user['heightUnit'],
            width: user['width'],
            widthUnit: user['widthUnit'],
            length: user['length'],
            lengthUnit: user['lengthUnit'],
            description: user['description'],
        );
    }

    int index ;
    PackageModel packageModel;
    String quantity;
    String weight;
    String weightUnit;
    String height;
    String heightUnit;
    String width;
    String widthUnit;
    String length;
    String lengthUnit;
    String description;
}
