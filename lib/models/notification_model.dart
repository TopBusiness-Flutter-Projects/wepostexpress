import 'dart:convert';
import 'dart:io';

import 'package:wepostexpress/models/user/user_model.dart';

class NotificationModel {
    NotificationModel({
        this.sender,
        this.created_at,
        this.subject,
        this.id,
        this.code,
        this.content,
        this.url,
        this.message_type,
        this.icon,
        this.type,
    });

    @override
    String toString() {
        return jsonEncode(toJson());
    }

    Map<String, String> toJson() {
        return  {
            'sender': sender.toString(),
            'code': code,
            'subject': subject,
            'message_type': message_type,
            'created_at': created_at,
            'id': id,
            'content': content,
            'url': url,
            'icon': icon,
            'type': type,
        };
    }

    static fromJson(user) {
        print('userfromJson');
        print(user);
        return NotificationModel(
            sender: UserModel.fromJson(user['data']['sender']??{}),
            subject: user['data']['message']['subject'].toString(),
            id: user['data']['message']['id'].toString(),
            content: user['data']['message']['content'].toString(),
            url: user['data']['message']['url'].toString(),
            code: user['data']['message']['code'],
            message_type: user['data']['message']['type'],
            icon: user['data']['icon'].toString(),
            type: user['data']['type'].toString(),
            created_at: user['created_at'],
        );
    }

    final UserModel sender;
    final String subject;
    final String created_at;
    final String id;
    final String content;
    final String url;
    final String icon;
    final String type;
    final String message_type;
    final String code;
}
/*
{
        "data": {
            "message": {
                "subject": "There is update shipment",
                "content": "Please check the a shipment which is just updated right now",
                "url": "your_google_maps_ApiKey/admin/shipments/12",
                "id": 12,
                "code": "AWB00012"
            },
            "icon": "flaticon2-bell-4",
            "type": "update_shipment"
        },
        "created_at": "2021-06-20 12:46:59"
    }
*/