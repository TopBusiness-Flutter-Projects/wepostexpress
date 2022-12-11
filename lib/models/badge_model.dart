import 'dart:convert';
import 'dart:io';

class BadgeModel {
    BadgeModel({
        this.color,
        this.name
    });

    @override
    String toString() {
        return jsonEncode(toJson());
    }

    toJson() {
        return {
        };
    }

    static fromJson(user) {
        return BadgeModel(
        );
    }

    String name;
    String color;
}
