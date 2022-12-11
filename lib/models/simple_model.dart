import 'dart:convert';
import 'dart:io';

import 'package:wepostexpress/models/details_model.dart';
import 'package:flutter/cupertino.dart';

class SimpleModel {
  SimpleModel({
    @required this.id,
  });

  @override
  String toString() {
    return jsonEncode(toJson());
  }

  toJson() {
    return {
      'id': id,
      'status': status,
    };
  }

  static fromJson(user) {
    return SimpleModel(
      id: user['id'],
    );
  }

  bool status;
  bool followed;
  bool favorite;
  bool readed;
  bool password_changed;
  bool user_activated;
  bool blocked;
  int id;
  String error;
  String message;
  DetailsModel user;
}
