import 'dart:convert' hide utf8;
import 'dart:io';
import 'dart:typed_data';

import 'package:wepostexpress/models/address_model.dart';
import 'package:wepostexpress/models/address_response_model.dart';
import 'package:wepostexpress/models/area_model.dart';
import 'package:wepostexpress/models/county_model.dart';
import 'package:wepostexpress/models/create_address_model.dart';
import 'package:wepostexpress/models/create_mission_model.dart';
import 'package:wepostexpress/models/create_order_model.dart';
import 'package:wepostexpress/models/currency_model.dart';
import 'package:wepostexpress/models/google_maps_model.dart';
import 'package:wepostexpress/models/mission_confirmation_type_model.dart';
import 'package:wepostexpress/models/mission_model.dart';
import 'package:wepostexpress/models/notification_model.dart';
import 'package:wepostexpress/models/package_model.dart';
import 'package:wepostexpress/models/payment_method_model.dart';
import 'package:wepostexpress/models/reasons_model.dart';
import 'package:wepostexpress/models/receiver_model.dart';
import 'package:wepostexpress/models/shipment_model.dart';
import 'package:wepostexpress/models/shipment_settings_model.dart';
import 'package:wepostexpress/models/shipments_response_model.dart';
import 'package:wepostexpress/models/single_package_shipment_model.dart';
import 'package:wepostexpress/models/state_model.dart';
import 'package:wepostexpress/models/user/auth_response_model.dart';
import 'package:wepostexpress/models/user/user_model.dart';
import 'package:wepostexpress/utils/cache/cache_helper.dart';
import 'package:wepostexpress/utils/config/config.dart';
import 'package:wepostexpress/utils/constants/app_keys.dart';
import 'package:wepostexpress/utils/constants/local_keys.dart';
import 'package:wepostexpress/utils/di/di.dart';
import 'package:wepostexpress/utils/errors/server_exception.dart';
import 'package:wepostexpress/utils/network/remote/api_helper.dart';
import 'package:wepostexpress/utils/network/remote/dio_helper.dart';
import 'package:dartz/dartz.dart';
import 'package:dio/dio.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/foundation.dart';
// import 'package:google_maps_place_picker/google_maps_place_picker.dart';
import 'package:path/path.dart' as path;
import 'package:path_provider/path_provider.dart';

abstract class Repository {
  UserModel user = UserModel();

  Future<Either<String, UserModel>> login({
    String email,
    String password,
  });

  Future<Either<String, String>> getUserWallet();

  Future<Either<String, String>> createShipment({
    CreateOrderModel createOrderModel,
  });

  Future<Either<String, String>> createMission({
    CreateMissionModel createMissionModel,
  });
  Future<Either<String, String>> deleteShipmentFromMission(
    ReasonsModel reasonsModel,
    String mission_id,
    String shipment_id,
  );

  Future<Either<String, String>> changeMissionStatus({
    @required String otp_confirm,
    @required String to,
    @required String shipment_id,
    @required String amount,
    @required String checked_ids,
    @required List<int> image,
  });

  Future<Either<String, ShipmentResponseModel>> getShipments({String code, String page});

  Future<Either<String, List<SinglePackageShipmentModel>>> getSingleShipmentPackages(
      {String shipmentId});

  // Future<Either<String, List<ShipmentResponseModel>>> getShipmentPackages({String code,String page});
  Future<Either<String, List<ShipmentModel>>> getMissionShipments({String id});

  Future<Either<String, MissionModel>> getSingleMission({String id});

  Future<Either<String, List<MissionModel>>> getMissions(int statusId);

  Future<Either<String, List<ReasonsModel>>> getReasons();

  Future<bool> logout();

  Future<Either<String, List<NotificationModel>>> getNotifications();

  Future<Either<String, UserModel>> register({
    @required UserModel userModel,
  });

  Future<Either<String, List<AddressResponseModel>>> saveNewAddressOfSender({
    @required AddressModel addressModel,
    // @required PickResult pickResult,
  });

  Future<Either<String, ReceiverModel>> saveNewReceiver({
    @required ReceiverModel receiverModel,
  });

  Future<Either<String,List<ReceiverModel>>> getReceivers();

  Future<Either<String, List<UserModel>>> getBranches();

  Future<Either<String,List<ShipmentSettingsModel>>> getShipmentSettings();

  Future<Either<String, List<AddressResponseModel>>> getAddresses();

  Future<Either<String,List<PackageModel>>> getPackages();

  Future<Either<String, CurrencyModel>> getCurrencies();

  Future<Either<String, List<PaymentMethodModel>>> getPaymentTypes();

  Future<Either<String, String>> downloadImage({
    String url,
  });

  Future<Either<String, List<CountryModel>>> getAllCountries();

  Future<Either<String, GoogleMapsModel>> getGoogleMaps();

  Future<Either<String, MissionConfirmationType>> getMissionConfirmation();

  Future<Either<String, List<StateModel>>> getCities({
    @required String countyID,
  });

  Future<Either<String, List<AreaModel>>> getAreas({
    @required String cityID,
  });
}

class RepoImpl extends Repository {
  final ApiHelper apiHelper;
  final DioHelper dioHelper;
  final CacheHelper cacheHelper;

  RepoImpl({
    @required this.apiHelper,
    @required this.dioHelper,
    @required this.cacheHelper,
  }) {
    // if we want to cache
  }

  @override
  Future<Either<String, String>> getUserWallet() async {
    return _basicErrorHandling<String>(
      onSuccess: () async {
        final call = await apiHelper.getData(
          di<Config>().baseURL,
          'get-wallet?type=captain',
          token: user.api_token,
        );
        di<Repository>().user.balance = call;
        return call;
      },
      onServerError: (exception) async {
        final f = exception.error;
        final msg = _handleErrorMessages(f['message']);
        return LocalKeys.server_error;
      },
    );
  }

  @override
  Future<Either<String, UserModel>> login({
    String email,
    String password,
  }) async {
    return _basicErrorHandling<UserModel>(
      onSuccess: () async {
        String token = await FirebaseMessaging.instance.getToken();
        final f =
            await apiHelper.postData(di<Config>().baseURL, 'v1/auth/login', token: null, data: {
          'email': email,
          'device_token': token,
          'password': password,
        });
        print('fffffffffffffffffffffff');
        print(f);
        final data =
        jsonDecode(f);
        print('loginData');
        print(data);
        print(data is! String);
        if (data is! String && data['message'] == null) {
          AuthResponse authResponse = AuthResponse.fromJson(data);
          UserModel userModel = UserModel.fromJson(authResponse.user);
          if (userModel.type != null && userModel.type == 'captain') {
            userModel.api_token != authResponse.api_token;
            user = userModel;
            cacheHelper.put(AppKeys.userData, userModel.toJson());
          }
          return userModel;
        } else {
          return UserModel.fromJson({
            'error': (data is! String) ? data['message'] : data,
          });
        }
      },
      onServerError: (exception) async {
        final f = exception.error;
        final msg = _handleErrorMessages(f['message']);
        return LocalKeys.server_error;
      },
    );
  }

  @override
  Future<Either<String, String>> createShipment({
    CreateOrderModel createOrderModel,
  }) async {
    return _basicErrorHandling<String>(
      onSuccess: () async {
        final f = await apiHelper.postData(di<Config>().baseURL, 'admin/shipments/create',
            authToken: user.api_token, data: createOrderModel.toJson());
        final data = jsonDecode(f);
        if (data is! String) {
          return data['message'];
        } else {
          return 'An error ouccured';
        }
      },
      onServerError: (exception) async {
        final f = exception.error;
        final msg = _handleErrorMessages(f['message']);
        return LocalKeys.server_error;
      },
    );
  }

  @override
  Future<Either<String, String>> createMission({
    CreateMissionModel createMissionModel,
  }) async {
    return _basicErrorHandling<String>(
      onSuccess: () async {
        final f = await apiHelper.postData(di<Config>().baseURL, 'createMission',
            token: user.api_token, data: createMissionModel.toJson());
        final data = jsonDecode(f);

        if (data is! String) {
          return data['message'];
        } else {
          return 'An error ouccured';
        }
      },
      onServerError: (exception) async {
        final f = exception.error;
        final msg = _handleErrorMessages(f['message']);
        return LocalKeys.server_error;
      },
    );
  }

  @override
  Future<Either<String, String>> deleteShipmentFromMission(
    ReasonsModel reasonsModel,
    String mission_id,
    String shipment_id,
  ) async {
    print('reasonsModel.id');
    print(reasonsModel.id);
    print(mission_id);
    print(shipment_id);
    return _basicErrorHandling<String>(
      onSuccess: () async {
        final f = await apiHelper.postData(di<Config>().baseURL, 'remove-shipment-from-mission',
            token: user.api_token,
            data: {
              'mission_id': mission_id,
              'shipment_id': shipment_id,
              'reason': reasonsModel.id,
            });
        print('deleteShipmentFromMission response');
        print(f);
        final data = jsonDecode(f);

        if (data is! String) {
          return data['message'];
        } else {
          return 'An error ouccured';
        }
      },
      onServerError: (exception) async {
        final f = exception.error;
        final msg = _handleErrorMessages(f['message']);
        return LocalKeys.server_error;
      },
    );
  }

  @override
  Future<Either<String, String>> changeMissionStatus({
    @required String otp_confirm,
    @required String to,
    @required String shipment_id,
    @required String amount,
    @required String checked_ids,
    @required List<int> image,
  }) async {
    print('reasonsModel.id');
    return _basicErrorHandling<String>(
      onSuccess: () async {
        final f = await dioHelper.postMultiPart(di<Config>().baseURL + 'changeMissionStatus',
            token: user.api_token,
            data: {
              if (otp_confirm != null) 'otp_confirm': otp_confirm,
              if (shipment_id != null) 'shipment_id': shipment_id,
              'amount': amount,
              'to': to,
              'checked_ids[0]': checked_ids,
              if (image != null)
                'signaturePadImg': MultipartFile.fromBytes(
                  image,
                  filename: 'signaturePadImg',
                ),
            });

        print('changeMissionStatus response');
        print(f);
        // final data = jsonDecode(f);
        //
        // if(data is !String){
        //   return data['message'];
        // }else{
        //   return 'An error ouccured';
        // }
        return 'Status Changed Successfully!';
      },
      onServerError: (exception) async {
        final f = exception.error;
        final msg = _handleErrorMessages(f['message']);
        return LocalKeys.server_error;
      },
    );
  }

  @override
  Future<bool> logout({
    String email,
    String password,
  }) async {
    await cacheHelper.clear(AppKeys.userData);
    return true;
  }

  @override
  Future<Either<String, UserModel>> register({
     @required UserModel userModel,
  }) async {
    return _basicErrorHandling<UserModel>(
      onSuccess: () async {
        String token = await FirebaseMessaging.instance.getToken();
        final f = await apiHelper.postData(di<Config>().baseURL, 'v1/auth/signup',
            typeJSON: false, data: userModel.toJsonForRegister(token));
        final data = jsonDecode(f);
        AuthResponse authResponse = AuthResponse.fromJson(data);
        // email is [email errors]
        print('authResponse');
        print(data);
        print(authResponse.email);
        if (authResponse.email == null || authResponse.email.isEmpty) {
          UserModel userModel = UserModel.fromJson(authResponse.user);
          userModel.api_token != authResponse.api_token;
          user = userModel;
          cacheHelper.put(AppKeys.userData, userModel.toJson());
          return userModel;
        } else {
          print('ddddddd');
          return UserModel.fromJson({
            'error': authResponse.email.first,
          });
        }
      },
      onServerError: (exception) async {
        final f = exception.error;
        final msg = _handleErrorMessages(f['message']);
        return LocalKeys.server_error;
      },
    );
  }

  @override
  Future<Either<String, List<CountryModel>>> getAllCountries() async {
    return _basicErrorHandling<List<CountryModel>>(
      onSuccess: () async {
        List<CountryModel> list = [];
        final data = await jsonDecode(await apiHelper.getData(
          di<Config>().baseURL,
          'countries',
          token: null,
        ));
        for (int index = 0; index < (data as List).length; index++) {
          list.add(CountryModel.fromJson(data[index]));
        }
        return list;
      },
      onServerError: (exception) async {
        final f = exception.error;
        final msg = _handleErrorMessages(f['message']);
        return LocalKeys.server_error;
      },
    );
  }

  @override
  Future<Either<String, GoogleMapsModel>> getGoogleMaps() async {
    return _basicErrorHandling<GoogleMapsModel>(
      onSuccess: () async {
        final data = await jsonDecode(await apiHelper.getData(
          di<Config>().baseURL,
          'checkGoogleMap',
          token: user.api_token,
        ));
        GoogleMapsModel googleMapsModel = GoogleMapsModel.fromJson(data);
        return googleMapsModel;
      },
      onServerError: (exception) async {
        final f = exception.error;
        final msg = _handleErrorMessages(f['message']);
        print("msg");
        print(msg);
        return msg;
      },
    );
  }

  @override
  Future<Either<String, MissionConfirmationType>> getMissionConfirmation() async {
    return _basicErrorHandling<MissionConfirmationType>(
      onSuccess: () async {
        final data = await jsonDecode(await apiHelper.getData(
          di<Config>().baseURL,
          'ConfirmationTypeMission',
          token: user.api_token,
        ));
        MissionConfirmationType confirmationType = MissionConfirmationType.fromJson(data);
        return confirmationType;
      },
      onServerError: (exception) async {
        final f = exception.error;
        final msg = _handleErrorMessages(f['message']);
        print("msg");
        print(msg);
        return msg;
      },
    );
  }

  @override
  Future<Either<String, List<AddressResponseModel>>> saveNewAddressOfSender({
    @required AddressModel addressModel,
    // @required PickResult pickResult,
  }) async {
    return _basicErrorHandling<List<AddressResponseModel>>(
      onSuccess: () async {
        List<AddressResponseModel> list = [];
        CreateAddressModel createAddressModel = CreateAddressModel(
            address: addressModel.address_name ?? '',
            area: addressModel.area_id ?? '',
            client_id: user.id ?? '',
          //  client_lat: (pickResult.geometry.location.lat ?? '').toString(),
            //client_lng: (pickResult.geometry.location.lng ?? '').toString(),
            //client_street_address_map: pickResult.vicinity ?? '',
            //client_url: pickResult.url ?? '',
            country: (addressModel.country_id ?? ''),
            state: (addressModel.state_id ?? ''));
        print('createAddressModel.toJson()');
        print(createAddressModel.toJson());
        final f = await apiHelper.postData(di<Config>().baseURL, 'addAddress',
            token: user.api_token, data: createAddressModel.toJson());
        final data = jsonDecode(f);
        for (int index = 0; index < (data['original'] as List).length; index++) {
          list.add(AddressResponseModel.fromJson(data['original'][index]));
        }
        return list;
      },
      onServerError: (exception) async {
        final f = exception.error;
        final msg = _handleErrorMessages(f['message']);
        return LocalKeys.server_error;
      },
    );
  }

  @override
  Future<Either<String, ReceiverModel>> saveNewReceiver({
    @required ReceiverModel receiverModel,
  }) async {
    return _basicErrorHandling<ReceiverModel>(
      onSuccess: () async {
        List<ReceiverModel> receiverModels = [];
        final receivers = await cacheHelper.get(AppKeys.receivers);
        if (receivers != null) {
          for (int index = 0; index < (receivers as List).length; index++) {
            receiverModels.add(ReceiverModel.fromJson(receivers[index]));
          }
        }
        receiverModels.add(receiverModel);
        await cacheHelper.put(AppKeys.receivers, receiverModels);
        return receiverModel;
      },
      onServerError: (exception) async {
        final f = exception.error;
        final msg = _handleErrorMessages(f['message']);
        return LocalKeys.server_error;
      },
    );
  }

  @override
  Future<Either<String,List<AddressResponseModel>>> getAddresses() async {
    return _basicErrorHandling<List<AddressResponseModel>>(
      onSuccess: () async {
        List<AddressResponseModel> addressModels = [];
        final call = await apiHelper.getData(
          di<Config>().baseURL,
          'getAddresses?client_id=${user.id}',
          token: user.api_token,
        );
        final data = jsonDecode(call);
        for (int index = 0; index < (data as List).length; index++) {
          addressModels.add(AddressResponseModel.fromJson(data[index]));
        }
        return addressModels;
      },
      onServerError: (exception) async {
        final f = exception.error;
        final msg = _handleErrorMessages(f['message']);
        return LocalKeys.server_error;
      },
    );

  }

  @override
  Future<Either<String,List<ReceiverModel>>> getReceivers() async {
    return _basicErrorHandling<List<ReceiverModel>>(
      onSuccess: () async {
        List<ReceiverModel> receiverModels = [];
        final receivers = await cacheHelper.get(AppKeys.receivers);
        if (receivers != null) {
          for (int index = 0; index < (receivers as List).length; index++) {
            receiverModels.add(ReceiverModel.fromJson(receivers[index]));
          }
        }
        return receiverModels;

      },
      onServerError: (exception) async {
        final f = exception.error;
        final msg = _handleErrorMessages(f['message']);
        return LocalKeys.server_error;
      },
    );

  }

  @override
  Future<Either<String,List<ShipmentSettingsModel>>> getShipmentSettings() async {
    return _basicErrorHandling<List<ShipmentSettingsModel>>(
      onSuccess: () async {
        List<ShipmentSettingsModel> list = [];
        final call = await apiHelper.getData(
          di<Config>().baseURL,
          'shipment-setting',
          token: user.api_token,
        );
        if (call != null) {
          final data = await jsonDecode(call);
          for (int index = 0; index < (data as List).length; index++) {
            list.add(ShipmentSettingsModel.fromJson(data[index]));
          }
        }
        return list;
      },
      onServerError: (exception) async {
        final f = exception.error;
        final msg = _handleErrorMessages(f['message']);
        return LocalKeys.server_error;
      },
    );

  }

  @override
  Future<Either<String, List<UserModel>>> getBranches() async {
    return _basicErrorHandling<List<UserModel>>(
      onSuccess: () async {
        List<UserModel> list = [];
        final call = await apiHelper.getData(
          di<Config>().baseURL,
          'branchs',
          token: user.api_token,
        );
        if (call != null) {
          final data = await jsonDecode(call);
          for (int index = 0; index < (data as List).length; index++) {
            list.add(UserModel.fromJson(data[index]));
          }
        }
        return list;
      },
      onServerError: (exception) async {
        final f = exception.error;
        final msg = _handleErrorMessages(f['message']);
        return LocalKeys.server_error;
      },
    );
  }

  @override
  Future<Either<String,List<PackageModel>>> getPackages() async {
    return _basicErrorHandling<List<PackageModel>>(
      onSuccess: () async {
        List<PackageModel> list = [];
        final call = await apiHelper.getData(
          di<Config>().baseURL,
          'packages',
          token: user.api_token,
        );
        final data = await jsonDecode(call);
        for (int index = 0; index < (data as List).length; index++) {
          list.add(PackageModel.fromJson(data[index]));
        }
        return list;

      },
      onServerError: (exception) async {
        final f = exception.error;
        final msg = _handleErrorMessages(f['message']);
        return LocalKeys.server_error;
      },
    );

  }

  @override
  Future<Either<String,List<PaymentMethodModel>>> getPaymentTypes() async {
    return _basicErrorHandling<List<PaymentMethodModel>>(
      onSuccess: () async {
        List<PaymentMethodModel> list = [];
        final call = await apiHelper.getData(
          di<Config>().baseURL,
          'payment-types',
          token: user.api_token,
        );
        final data = await jsonDecode(call);
        print('getPaymentTypes');
        print(data);
        for (int index = 0; index < (data as List).length; index++) {
          print('getPaymentTypes');
          print(data[index]);

          list.add(PaymentMethodModel.fromJson(data[index]));
        }
        return list;

      },
      onServerError: (exception) async {
        final f = exception.error;
        final msg = _handleErrorMessages(f['message']);
        return LocalKeys.server_error;
      },
    );

  }

  @override
  Future<Either<String, List<ReasonsModel>>> getReasons() async {
    return _basicErrorHandling<List<ReasonsModel>>(
      onSuccess: () async {
        List<ReasonsModel> reasons = [];
        final call = await apiHelper.getData(
          di<Config>().baseURL,
          'reasons',
          token: user.api_token,
        );
        print('getReasons call');
        print(call);
        final data = await jsonDecode(call);
        for (int index = 0; index < (data as List).length; index++) {
          reasons.add(ReasonsModel.fromJson(data[index]));
        }
        return reasons;

      },
      onServerError: (exception) async {
        final f = exception.error;
        final msg = _handleErrorMessages(f['message']);
        return LocalKeys.server_error;
      },
    );

  }

  @override
  Future<Either<String, CurrencyModel>> getCurrencies() async {
    return _basicErrorHandling<CurrencyModel>(
      onSuccess: () async {
        List<CurrencyModel> currencies = [];

        final call = await apiHelper.getData(
          di<Config>().baseURL,
          'get-system-currency',
          token: user.api_token,
        );
        final data = await jsonDecode(call);

        return CurrencyModel.fromJson(data);

      },
      onServerError: (exception) async {
        final f = exception.error;
        final msg = _handleErrorMessages(f['message']);
        return LocalKeys.server_error;
      },
    );

  }

  @override
  Future<Either<String, List<StateModel>>> getCities({
    @required String countyID,
  }) async {
    return _basicErrorHandling<List<StateModel>>(
      onSuccess: () async {
        List<StateModel> list = [];
        final call = await apiHelper.getData(
          di<Config>().baseURL,
          'states?country_id=$countyID',
          token: null,
        );
        final data = await jsonDecode(call);
        for (int index = 0; index < (data as List).length; index++) {
          list.add(StateModel.fromJson(data[index]));
        }
        return list;
      },
      onServerError: (exception) async {
        final f = exception.error;
        final msg = _handleErrorMessages(f['message']);
        return LocalKeys.server_error;
      },
    );
  }

  @override
  Future<Either<String, ShipmentResponseModel>> getShipments({String code, String page}) async {
    return _basicErrorHandling<ShipmentResponseModel>(
      onSuccess: () async {
        if (code == null) {
          code = '';
        }
        final call = await apiHelper.getData(
          di<Config>().baseURL,
          'shipments?code=$code&client_id=${user?.id ?? ''}}&page=${page}',
          token: user.api_token,
        );
        // final data2= (call.split(',"All Shipments",').first).substring(1,(call.split(',"All Shipments",').first).length);
        final data = await jsonDecode(call);
        ShipmentResponseModel shipmentResponseModel = ShipmentResponseModel.fromJson(data);
        return shipmentResponseModel;
      },
      onServerError: (exception) async {
        final f = exception.error;
        final msg = _handleErrorMessages(f['message']);
        return LocalKeys.server_error;
      },
    );
  }

  @override
  @override
  Future<Either<String, List<SinglePackageShipmentModel>>> getSingleShipmentPackages(
      {String shipmentId}) async {
    return _basicErrorHandling<List<SinglePackageShipmentModel>>(
      onSuccess: () async {
        List<SinglePackageShipmentModel> ships = [];

        final call = await apiHelper.getData(
          di<Config>().baseURL,
          'shipmentPackages?shipment_id=$shipmentId',
          token: user.api_token,
        );
        final data = await jsonDecode(call);
        for (int index = 0; index < (data as List).length; index++) {
          ships.add(SinglePackageShipmentModel.fromJson(data[index]));
        }
        return ships;
      },
      onServerError: (exception) async {
        final f = exception.error;
        final msg = _handleErrorMessages(f['message']);
        return LocalKeys.server_error;
      },
    );
  }

  @override
  @override
  Future<Either<String, List<ShipmentModel>>> getMissionShipments({String id}) async {
    return _basicErrorHandling<List<ShipmentModel>>(
      onSuccess: () async {
        List<ShipmentModel> ships = [];

        final call = await apiHelper.getData(
          di<Config>().baseURL,
          'MissionShipments?mission_id=$id',
          token: user.api_token,
        );
        final data = await jsonDecode(call);
        for (int index = 0; index < (data as List).length; index++) {
          ships.add(ShipmentModel.fromJson(data[index]['shipment']));
        }
        return ships;
      },
      onServerError: (exception) async {
        final f = exception.error;
        final msg = _handleErrorMessages(f['message']);
        return LocalKeys.server_error;
      },
    );
  }

  @override
  Future<Either<String, MissionModel>> getSingleMission({String id}) async {
    return _basicErrorHandling<MissionModel>(
      onSuccess: () async {
        final call = await apiHelper.getData(
          di<Config>().baseURL,
          'missions?id=$id',
          token: user.api_token,
        );
        final data = await jsonDecode(call);
        print('ddddata');
        print(data);
        return MissionModel.fromJson(data);
      },
      onServerError: (exception) async {
        final f = exception.error;
        final msg = _handleErrorMessages(f['message']);
        return LocalKeys.server_error;
      },
    );
  }

  @override
  Future<Either<String, List<MissionModel>>> getMissions(int statusId) async {
    return _basicErrorHandling<List<MissionModel>>(
      onSuccess: () async {
        List<MissionModel> missions = [];
        final call = await apiHelper.getData(
          di<Config>().baseURL,
          'missions?client_id=${user.id}}&status_id=$statusId&page=1',
          token: user.api_token,
        );
        print('missions call');
        print(call);
        final data = await jsonDecode(call);
        for (int index = 0; index < (data as List).length; index++) {
          print('data[index]');
          print(data[index]);
          missions.add(MissionModel.fromJson(data[index]));
        }
        return missions;
      },
      onServerError: (exception) async {
        final f = exception.error;
        final msg = _handleErrorMessages(f['message']);
        return LocalKeys.server_error;
      },
    );
  }

  @override
  @override
  Future<Either<String, List<NotificationModel>>> getNotifications() async {
    return _basicErrorHandling<List<NotificationModel>>(
      onSuccess: () async {
        List<NotificationModel> notifications = [];
        final call = await apiHelper.getData(
          di<Config>().baseURL,
          'notifications?user_id=${user.id}',
          token: user.api_token,
        );

        final data = await jsonDecode(call);
        for (int index = 0; index < (data as List).length; index++) {
          print('notifications data;;;');
          print(data[index]);
          notifications.add(NotificationModel.fromJson(data[index]));
        }

        return notifications;
      },
      onServerError: (exception) async {
        final f = exception.error;
        final msg = _handleErrorMessages(f['message']);
        return LocalKeys.server_error;
      },
    );
  }

  @override
  Future<Either<String, List<AreaModel>>> getAreas({
    @required String cityID,
  }) async {
    return _basicErrorHandling<List<AreaModel>>(
      onSuccess: () async {
        List<AreaModel> list = [];
        final data = await jsonDecode(await apiHelper.getData(
          di<Config>().baseURL,
          'areas?state_id=$cityID',
          token: null,
        ));
        for (int index = 0; index < (data as List).length; index++) {
          list.add(AreaModel.fromJson(data[index]));
        }
        return list;
      },
      onServerError: (exception) async {
        final f = exception.error;
        final msg = _handleErrorMessages(f['message']);
        return LocalKeys.server_error;
      },
    );
  }

  @override
  Future<Either<String, String>> downloadImage({
    String url,
  }) async {
    return _basicErrorHandling<String>(
      onSuccess: () async {
        var request = await HttpClient().getUrl(Uri.parse(url));
        var response = await request.close();
        Uint8List bytes = await consolidateHttpClientResponseBytes(response);
        Directory directory;
        if (Platform.isAndroid) {
          directory = (await getExternalStorageDirectory());
        } else {
          directory = await getApplicationDocumentsDirectory();
        }
        File file = new File(path.join(directory.path, 'cargo.jpg'));
        file.writeAsBytesSync(bytes); // This is a sync operation on a real
        final String localPath = '${directory.path}/cargo.jpg';
        await cacheHelper.put(AppKeys.APP_LOGO_PATH, localPath);
        return localPath;
      },
    );
  }
}

extension on Repository {
  String _handleErrorMessages(final dynamic f) {
    String msg = '';
    if (f is String) {
      msg = f;
    } else if (f is Map) {
      for (dynamic l in f.values) {
        if (l is List) {
          for (final s in l) {
            msg += '$s\n';
          }
        }
      }
      if (msg.contains('\n')) {
        msg = msg.substring(0, msg.lastIndexOf('\n'));
      }
      if (msg.isEmpty) {
        msg = 'Server Error';
      }
    } else {
      msg = 'Server Error';
    }
    return LocalKeys.server_error;
  }

  Future<Either<String, T>> _basicErrorHandling<T>({
    @required Future<T> onSuccess(),
    Future<String> onServerError(ServerException exception),
    Future<String> onCacheError(CacheException exception),
    Future<String> onOtherError(Exception exception),
  }) async {
    try {
      final f = await onSuccess();
      return Right(f);
    } catch (e, s) {
      print(e);
      print(s);
      return Left(tr(LocalKeys.server_error));
    }
  }
}
