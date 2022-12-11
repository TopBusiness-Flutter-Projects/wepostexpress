import 'dart:convert';

class CreateAddressModel {
  CreateAddressModel(
          {this.client_id,
      this.address,
      this.country,
      this.state,
      this.area,
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
      'client_id': client_id,
      'address': address,
      'country': country,
      'state': state,
      'area': area,
      'client_street_address_map': client_street_address_map,
      'client_lat': client_lat,
      'client_lng': client_lng,
      'client_url': client_url,
    };
  }

  static fromJson(user) {
    return CreateAddressModel(
      client_id: user['client_id'].toString(),
      address: user['address'].toString(),
      country: user['country'].toString(),
      state: user['state'].toString(),
      area: user['area'].toString(),
      client_street_address_map: user['client_street_address_map'].toString(),
      client_lat: user['client_lat'].toString(),
      client_lng: user['client_lng'].toString(),
      client_url: user['client_url'].toString(),
    );
  }

  final String client_id;
  final String address;
  final String country;
  final String state;
  final String area;
  final String client_street_address_map;
  final String client_lat;
  final String client_lng;
  final String client_url;
}