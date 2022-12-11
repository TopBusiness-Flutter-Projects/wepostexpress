import 'dart:convert';

class MissionConfirmationType {
  MissionConfirmationType(
          {
            this.id,
            this.key,
            this.value,
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
      'key': key,
      'value': value,
      'created_at': created_at,
      'updated_at': updated_at,
    };
  }

  static fromJson(user) {
    return MissionConfirmationType(
      id: (user['id']??'').toString(),
      key: (user['key']??'').toString(),
      value: (user['value']??'').toString(),
      created_at: (user['created_at']??'').toString(),
      updated_at: (user['updated_at']??'').toString(),
    );
  }

  final String id;
  final String key;
  final String value;
  final String created_at;
  final String updated_at;
}
