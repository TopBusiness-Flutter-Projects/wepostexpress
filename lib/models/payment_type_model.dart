import 'dart:convert';
import 'dart:io';

class PaymentTypeModel {
    PaymentTypeModel(
            {
                this.id,
      this.type,
      this.value,
      this.key,
      this.lang,
      this.name,
      this.created_at,
      this.updated_at,});

    @override
    String toString() {
        return jsonEncode(toJson());
    }

    toJson() {
        return {
            'id': id,
            'type': type,
            'value': value,
            'key': key,
            'lang': lang,
            'name': name,
            'created_at': created_at,
            'updated_at': updated_at,
        };
    }

    static fromJson(user) {
        return PaymentTypeModel(
            id: user['id'].toString(),
            type: user['type'],
            value: user['value'],
            key: user['key'],
            lang: user['lang'],
            name: user['name'],
            created_at: user['created_at'],
            updated_at: user['updated_at'],
        );
    }

    final String id;
    final String type;
    final String value;
    final String key;
    final String lang;
    final String name;
    final String created_at;
    final String updated_at;
}