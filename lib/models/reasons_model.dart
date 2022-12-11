import 'dart:convert';

class ReasonsModel {
  ReasonsModel(
          {
            this.id,
            this.type,
            this.key,
            this.name,
            this.created_at,
            this.updated_at,
          });

  @override
  String toString() {
    return jsonEncode(toJson());
  }

  toJson() {
    return {
      'id': id,
      'type': type,
      'key': key,
      'name': name,
      'created_at': created_at,
      'updated_at': updated_at,
    };
  }

  static fromJson(user) {
    return ReasonsModel(
      id: (user['id']??'').toString(),
      type: (user['type']??'').toString(),
      key: (user['key']??'').toString(),
      name: (user['name']??'').toString(),
      created_at: (user['created_at']??'').toString(),
      updated_at: (user['updated_at']??'').toString(),
    );
  }

  final String id;
  final String type;
  final String key;
  final String name;
  final String created_at;
  final String updated_at;
}
