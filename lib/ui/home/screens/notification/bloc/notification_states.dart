import 'package:flutter/foundation.dart';

@immutable
abstract class NotificationStates {
  const NotificationStates();
}

class InitialNotificationState extends NotificationStates {}

class LoadingNotificationState extends NotificationStates {}

class SuccessChangedPageState extends NotificationStates {}
class SuccessNotificationState extends NotificationStates {}

class ErrorNotificationState extends NotificationStates {
  final String error;

  ErrorNotificationState(this.error);
}