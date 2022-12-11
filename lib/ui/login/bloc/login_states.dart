import 'package:flutter/foundation.dart';

@immutable
abstract class LoginStates {
  const LoginStates();
}

class InitialLoginState extends LoginStates {}

class LoadingLoginState extends LoginStates {}

class SuccessLoginState extends LoginStates {}
class PasswordToggleChangedLoginState extends LoginStates {}

class LoggedInSuccessfully extends LoginStates {}

class ErrorLoginState extends LoginStates {
  final String error;
  final bool isNotCaptain;

  ErrorLoginState(this.error,this.isNotCaptain);
}