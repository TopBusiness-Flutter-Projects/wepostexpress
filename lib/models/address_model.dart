import 'dart:convert';

class AddressModel {
  AddressModel(
      {
        this.address_name,
        this.country_code,
      this.country_id,
      this.country_name,
      this.country_currency,
      this.country_phonecode,
      this.state_name,
      this.state_id,
      this.area_name,
      this.area_id});

  @override
  String toString() {
    return jsonEncode(toJson());
  }

  toJson() {
    return {
      'address_name': address_name,
      'country_code': country_code,
      'country_id': country_id,
      'country_name': country_name,
      'country_currency': country_currency,
      'country_phonecode': country_phonecode,
      'state_name': state_name,
      'state_id': state_id,
      'area_name': area_name,
      'area_id': area_id,
    };
  }

  static fromJson(user) {
    return AddressModel(
      address_name: user['address_name'].toString(),
      country_code: user['country_code'].toString(),
      country_id: user['country_id'].toString(),
      country_name: user['country_name'].toString(),
      country_currency: user['country_currency'].toString(),
      country_phonecode: user['country_phonecode'].toString(),
      state_name: user['state_name'].toString(),
      state_id: user['state_id'].toString(),
      area_name: user['area_name'].toString(),
      area_id: user['area_id'].toString(),
    );
  }

  final String address_name;
  final String country_code;
  final String country_id;
  final String country_name;
  final String country_currency;
  final String country_phonecode;
  final String state_name;
  final String state_id;
  final String area_name;
  final String area_id;
}
