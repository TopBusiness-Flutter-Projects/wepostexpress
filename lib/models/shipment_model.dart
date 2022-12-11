import 'dart:convert';
import 'dart:io';

import 'package:wepostexpress/models/new_order/address_new_order.dart';
import 'package:wepostexpress/models/package_model.dart';

class ShipmentModel {
    ShipmentModel({
        this.id,
        this.code,
        this.packages,
        this.status_id,
        this.type,
        this.branch_id,
        this.error,
        this.shipping_date,
        this.client_id,
        this.client_address,
        this.payment_type,
        this.paid,
        this.payment_integration_id,
        this.payment_method_id,
        this.tax,
        this.insurance,
        this.delivery_time,
        this.shipping_cost,
        this.total_weight,
        this.employee_user_id,
        this.client_street_address_map,
        this.client_lat,
        this.client_lng,
        this.client_url,
        this.reciver_street_address_map,
        this.reciver_lat,
        this.from_address,
        this.reciver_lng,
        this.reciver_url,
        this.attachments_before_shipping,
        this.attachments_after_shipping,
        this.client_phone,
        this.reciver_phone,
        this.created_at,
        this.updated_at,
        this.reciver_name,
        this.reciver_address,
        this.mission_id,
        this.captain_id,
        this.return_cost,
        this.from_country_id,
        this.from_state_id,
        this.from_area_id,
        this.to_country_id,
        this.to_state_id,
        this.to_area_id,
        this.prev_branch,
        this.client_status,
        this.amount_to_be_collected,
        this.barcode,
    });

    @override
    String toString() {
        return jsonEncode(toJson());
    }

    Map<String, String> toJson() {
        return  {
            'id': id,
            'code': code,
            'status_id': status_id,
            'type': type,
            'branch_id': branch_id,
            'error': error,
            'shipping_date': shipping_date,
            'client_id': client_id,
            'client_address': client_address,
            'payment_type': payment_type,
            'paid': paid,
            'payment_integration_id': payment_integration_id,
            'payment_method_id': payment_method_id,
            'tax': tax,
            'insurance': insurance,
            'delivery_time': delivery_time,
            'shipping_cost': shipping_cost,
            'total_weight': total_weight,
            'employee_user_id': employee_user_id,
            'client_street_address_map': client_street_address_map,
            'client_lat': client_lat,
            'client_lng': client_lng,
            'client_url': client_url,
            'reciver_street_address_map': reciver_street_address_map,
            'reciver_lat': reciver_lat,
            'reciver_lng': reciver_lng,
            'reciver_url': reciver_url,
            'attachments_before_shipping': attachments_before_shipping,
            'attachments_after_shipping': attachments_after_shipping,
            'client_phone': client_phone,
            'reciver_phone': reciver_phone,
            'created_at': created_at,
            'updated_at': updated_at,
            'reciver_name': reciver_name,
            'reciver_address': reciver_address,
            'mission_id': mission_id,
            'captain_id': captain_id,
            'return_cost': return_cost,
            'from_country_id': from_country_id,
            'from_state_id': from_state_id,
            'from_area_id': from_area_id,
            'to_country_id': to_country_id,
            'to_state_id': to_state_id,
            'to_area_id': to_area_id,
            'prev_branch': prev_branch,
            'client_status': client_status,
            'amount_to_be_collected': amount_to_be_collected,
            'barcode': barcode,
        };
    }

    static fromJson(user) {
        print('userfromJson');
        print(user);
        return ShipmentModel(
            id: user['id'].toString(),
            code: user['code'],
            status_id: user['status_id'].toString(),
            type: user['type'],
            branch_id: user['branch_id'].toString(),
            error: user['error'],
            shipping_date: user['shipping_date'],
            client_id: user['client_id'].toString(),
            client_address: user['client_address'],
            payment_type: user['payment_type'].toString(),
            paid: user['paid'].toString(),
            payment_integration_id: user['payment_integration_id'],
            payment_method_id: (user['payment_method_id']??'').toString(),
            tax: user['tax'].toString(),
            insurance: user['insurance'].toString(),
            delivery_time: user['delivery_time'],
            shipping_cost: user['shipping_cost'].toString(),
            total_weight: user['total_weight'].toString(),
            employee_user_id: user['employee_user_id'],
            client_street_address_map: user['client_street_address_map'],
            client_lat: user['client_lat'],
            client_lng: user['client_lng'],
            client_url: user['client_url'],
            reciver_street_address_map: user['reciver_street_address_map'],
            reciver_lat: user['reciver_lat'],
            reciver_lng: user['reciver_lng'],
            reciver_url: user['reciver_url'],
            attachments_before_shipping: user['attachments_before_shipping'],
            attachments_after_shipping: user['attachments_after_shipping'],
            client_phone: user['client_phone'],
            reciver_phone: user['reciver_phone'],
            created_at: user['created_at'],
            updated_at: user['updated_at'],
            reciver_name: user['reciver_name'],
            reciver_address: user['reciver_address'],
            mission_id: user['mission_id'].toString(),
            captain_id: user['captain_id']!=null ?user['captain_id'].toString():'',
            return_cost: user['return_cost'].toString(),
            from_country_id: user['from_country_id'].toString(),
            from_state_id: user['from_state_id'].toString(),
            from_area_id: user['from_area_id'].toString(),
            to_country_id: user['to_country_id'].toString(),
            to_state_id: user['to_state_id'].toString(),
            to_area_id: user['to_area_id'].toString(),
            prev_branch: user['prev_branch'],
            client_status: user['client_status'].toString(),
            amount_to_be_collected: user['amount_to_be_collected'].toString(),
            barcode: user['barcode'],
            from_address: FromAddressModel.fromJson(user['from_address']??{}),
        );
    }

    final String id;
    final String code;
    final String status_id;
    final String type;
    final String branch_id;
    final String error;
    final String shipping_date;
    final String client_id;
    final String client_address;
    final String payment_type;
    final String paid;
    final String payment_integration_id;
    final String payment_method_id;
    final String tax;
    final String insurance;
    final String delivery_time;
    final String shipping_cost;
    final String total_weight;
    final String employee_user_id;
    final String client_street_address_map;
    final String client_lat;
    final String client_lng;
    final String client_url;
    final String reciver_street_address_map;
    final String reciver_lat;
    final String reciver_lng;
    final String reciver_url;
    final String attachments_before_shipping;
    final String attachments_after_shipping;
    final String client_phone;
    final String reciver_phone;
    final String created_at;
    final String updated_at;
    final String reciver_name;
    final String reciver_address;
    final String mission_id;
    final String captain_id;
    final String return_cost;
    final String from_country_id;
    final String from_state_id;
    final String from_area_id;
    final String to_country_id;
    final String to_state_id;
    final String to_area_id;
    final String prev_branch;
    final String client_status;
    final String amount_to_be_collected;
    final String barcode;
    final List<AddressOrderModel> packages;
    final FromAddressModel from_address;
}
class FromAddressModel {
    FromAddressModel(
            {
                this.id,
                this.client_id,
                this.address,
                this.country_id,
                this.state_id,
                this.area_id,
                this.client_street_address_map,
                this.client_lat,
                this.client_lng,
                this.client_url});

    @override
    String toString() {
        return jsonEncode(toJson());
    }

    toJson() {
        return {
            'id': id,
            'client_id': client_id,
            'address': address,
            'country_id': country_id,
            'state_id': state_id,
            'area_id': area_id,
            'client_street_address_map': client_street_address_map,
            'client_lat': client_lat,
            'client_lng': client_lng,
            'client_url': client_url,
        };
    }

    static fromJson(data) {
        print('FromAddressModel fromJson');
        print(data);
        return FromAddressModel(
            id:( data['id']??'').toString(),
            client_id:( data['client_id']??'').toString(),
            address:( data['address']??'').toString(),
            country_id:( data['country_id']??'').toString(),
            state_id:(  data['state_id']??'').toString(),
            area_id:( data['area_id']??'').toString(),
            client_street_address_map:( data['client_street_address_map']??'').toString(),
            client_lat:( data['client_lat']??'').toString(),
            client_lng:( data['client_lng']??'').toString(),
            client_url:( data['client_url']??'').toString(),
        );
    }

    final String id;
    final String client_id;
    final String address;
    final String country_id;
    final String state_id;
    final String area_id;
    final String client_street_address_map;
    final String client_lat;
    final String client_lng;
    final String client_url;
}