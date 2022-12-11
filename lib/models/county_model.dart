import 'dart:convert';
import 'dart:io';

class CountryModel {
    CountryModel({
        this.id,
        this.currency,
        this.phonecode,
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
            'phonecode': phonecode,
            'currency': currency,
        };
    }

    static fromJson(user) {
        return CountryModel(
            id: user['id'].toString(),
            currency: user['currency'],
            name: user['name'],
            phonecode: user['phonecode'],
        );
    }

    final String id;
    final String name;
    final String currency;
    final String phonecode;
}
