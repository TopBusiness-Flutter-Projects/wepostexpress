import 'package:flutter/foundation.dart';

@immutable
abstract class SplashStates {
  const SplashStates();
}

class InitialSplashState extends SplashStates {}

class LoadingSplashState extends SplashStates {}

class SuccessSplashState extends SplashStates {}
class NavigateToConfigLoader extends SplashStates {}

class ErrorSplashState extends SplashStates {
  final String error;

  ErrorSplashState(this.error);
}