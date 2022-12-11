import 'dart:convert';

class AddressResponseModel {
  AddressResponseModel(
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
            this.client_url,
            this.created_at,
            this.updated_at});

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
      'created_at': created_at,
      'updated_at': updated_at,
    };
  }

  static fromJson(user) {
    return AddressResponseModel(
      id: user['id'].toString(),
      client_id: user['client_id'].toString(),
      address: user['address'].toString(),
      country_id: user['country_id'].toString(),
      state_id: user['state_id'].toString(),
      area_id: user['area_id'].toString(),
      client_street_address_map: user['client_street_address_map'].toString(),
      client_lat: user['client_lat'].toString(),
      client_lng: user['client_lng'].toString(),
      client_url: user['client_url'].toString(),
      created_at: user['created_at'].toString(),
      updated_at: user['updated_at'].toString(),
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
  final String created_at;
  final String updated_at;
}
