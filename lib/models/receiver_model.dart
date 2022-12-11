import 'dart:convert';

class ReceiverModel {
  ReceiverModel(
      {
        this.receiver_name,
        this.receiver_email,
        this.receiver_mobile,
       });

  @override
  String toString() {
    return jsonEncode(toJson());
  }

  toJson() {
    return {
      'receiver_name': receiver_name,
      'receiver_email': receiver_email,
      'receiver_mobile': receiver_mobile,
    };
  }

  static fromJson(user) {
    return ReceiverModel(
      receiver_name: user['receiver_name'].toString(),
      receiver_email: user['receiver_email'].toString(),
      receiver_mobile: user['receiver_mobile'].toString(),
    );
  }

  final String receiver_name;
  final String receiver_email;
  final String receiver_mobile;
}
