import 'dart:convert';
import 'dart:io';

import 'package:wepostexpress/models/badge_model.dart';

class DetailsModel {
  DetailsModel({
    this.id,
    this.email,
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
    return DetailsModel(
    );
  }

  int id;
  String displayname;
  String firstname;
  String lastname;
  String nickname;
  String description;
  String registered;
  String email;
  String avatar;
  String avatar_small;
  String user_message;
  bool confirm_account;
  bool not_allow_ask;
  String not_see_questions;
  bool not_allow_answer;
  String not_see_answers;
  bool not_allow_post;
  String not_see_posts;
  bool not_allow_comment;
  String not_see_comments;
  String cover;
  int points;
  int followers;
  int questions;
  int answers;
  int best_answers;
  int notifications;
  int new_notifications;
  List<String> user_followers;
  bool verified;
  bool followed;
  bool block;
  bool unblock;
  BadgeModel badge;
}
