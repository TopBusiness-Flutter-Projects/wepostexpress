import 'dart:convert';
import 'dart:io';

class StateModel {
    StateModel({
        this.id,
        this.country_code,
        this.country_id,
        this.name,
    });

    @override
    String toString() {
        return jsonEncode(toJson());
    }

    toJson() {
        return {
            'id': id,
            'name': name,
            'country_id': country_id,
            'country_code': country_code,
        };
    }

    static fromJson(user) {
        return StateModel(
            id: user['id'].toString(),
            country_code: user['country_code'],
            name: user['name'],
            country_id: user['country_id'].toString(),
        );
    }

    final String id;
    final String name;
    final String country_code;
    final String country_id;
}
