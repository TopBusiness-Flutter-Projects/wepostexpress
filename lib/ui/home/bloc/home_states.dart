import 'package:flutter/foundation.dart';

@immutable
abstract class HomeStates {
  const HomeStates();
}

class InitialHomeState extends HomeStates {}

class LoadingHomeState extends HomeStates {}
class LoadingMoreShipmentsHomeState extends HomeStates {}
class LoadingMoreMissionsHomeState extends HomeStates {}
class LoadingNotificationsHomeState extends HomeStates {}

class LogoutSuccessfullyHomeState extends HomeStates {}

class SuccessChangedPageState extends HomeStates {}
class SuccessListChangedPageState extends HomeStates {}
class SuccessHomeState extends HomeStates {}
class SuccessWalletHomeState extends HomeStates {}

class ErrorHomeState extends HomeStates {
  final String error;

  ErrorHomeState(this.error);
}