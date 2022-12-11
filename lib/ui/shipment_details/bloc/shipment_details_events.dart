import 'package:flutter/foundation.dart';
import 'package:wepostexpress/models/shipment_model.dart';
import 'package:wepostexpress/models/user/user_model.dart';

@immutable
abstract class ShipmentDetailsEvents
{
  const ShipmentDetailsEvents();
}

class SubmitShipmentDetailsEvent extends ShipmentDetailsEvents {
  final UserModel userModel;
  SubmitShipmentDetailsEvent({
    @required this.userModel,
});
}
class FetchShipmentDetailsEvent extends ShipmentDetailsEvents {
  final String shipmentId;
  final String code ;
  final ShipmentModel shipmentModel;

  FetchShipmentDetailsEvent(this.shipmentId,this.shipmentModel,{this.code,});

}
class NextShipmentDetailsEvent extends ShipmentDetailsEvents {}
class ChangeShipmentDetailsEvent extends ShipmentDetailsEvents {}
class ChangeBackwardEvent extends ShipmentDetailsEvents {}

class FetchCitiesShipmentDetailsEvent extends ShipmentDetailsEvents {
  final String countryId ;
  FetchCitiesShipmentDetailsEvent({
    @required this.countryId,
  });
}

class FetchAreasShipmentDetailsEvent extends ShipmentDetailsEvents {
  final String cityId ;
  FetchAreasShipmentDetailsEvent({
    @required this.cityId,
  });
}
