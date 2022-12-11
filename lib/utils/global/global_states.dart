import 'package:flutter/foundation.dart';

@immutable
abstract class GlobalStates {
  const GlobalStates();
}

class InitialGlobalState extends GlobalStates {}

class LoadingGlobalState extends GlobalStates {}

class SuccessFetchedLogoState extends GlobalStates {}
class SuccessGlobalState extends GlobalStates {}
class ConnectionChangedGlobalState extends GlobalStates {
  final bool isOnline;
  ConnectionChangedGlobalState(this.isOnline);
}

class ErrorGlobalState extends GlobalStates {
  final String error;

  ErrorGlobalState(this.error);
}