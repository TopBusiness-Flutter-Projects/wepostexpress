import 'package:flutter/foundation.dart';
import 'package:wepostexpress/models/shipment_model.dart';

@immutable
abstract class ShipmentDetailsStates {
  const ShipmentDetailsStates();
}

class InitialShipmentDetailsState extends ShipmentDetailsStates {}

class LoadingShipmentDetailsState extends ShipmentDetailsStates {}
class LoadingProgressShipmentDetailsState extends ShipmentDetailsStates {}

class SuccessShipmentDetailsState extends ShipmentDetailsStates {}
class ShipmentDetailsedSuccessfully extends ShipmentDetailsStates {}
class SuccessGetAllCountriesShipmentDetailsState extends ShipmentDetailsStates {}
class SuccessNextShipmentDetailsState extends ShipmentDetailsStates {}

class SuccessStepForwardShipmentDetailsState extends ShipmentDetailsStates {}
class SuccessStepBackwardShipmentDetailsState extends ShipmentDetailsStates {}

class ErrorShipmentDetailsState extends ShipmentDetailsStates {
  final String error;

  ErrorShipmentDetailsState(this.error,);
}