import 'package:flutter/foundation.dart';

@immutable
abstract class LoginEvents
{
  const LoginEvents();
}

class FetchLoginEvent extends LoginEvents {}

class PasswordToggleChangedLoginEvent extends LoginEvents {}

class SubmitLoginEvent extends LoginEvents {
  final String email;
  final String password;
  SubmitLoginEvent({
    @required this.email,
    @required this.password,
});
}