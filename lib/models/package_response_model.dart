import 'dart:convert';

class PackageResponseModel {
  PackageResponseModel(
      {
        this.name,
        this.id,
      this.updated_at,
      this.created_at,
      this.cost,
      });

  @override
  String toString() {
    return jsonEncode(toJson());
  }

  toJson() {
    return {
      'name': name,
      'id': id,
      'updated_at': updated_at,
      'created_at': created_at,
      'cost': cost,
    };
  }

  static fromJson(user) {
    return PackageResponseModel(
      id: user['id'].toString(),
      name: user['name'],
      created_at: user['created_at'].toString(),
      updated_at: user['updated_at'].toString(),
      cost: user['cost'].toString(),
    );
  }

  final String id;
  final String name;
  final String created_at;
  final String updated_at;
  final String cost;
}

/*
 {
        "id": 1,
        "name": "Phones",
        "created_at": "2021-06-17 08:07:47",
        "updated_at": "2021-06-17 08:08:42",
        "cost": 20
    },
*/