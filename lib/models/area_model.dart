import 'dart:convert';
import 'dart:io';

class AreaModel {
    AreaModel({
        this.id,
        this.state_id,
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
            'state_id': state_id,
        };
    }

    static fromJson(user) {
        return AreaModel(
            id: user['id'].toString(),
            state_id: user['state_id'].toString(),
            name: user['name'],
        );
    }

    final String id;
    final String name;
    final String state_id;
}
