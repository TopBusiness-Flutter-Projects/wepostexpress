import 'package:flutter/foundation.dart';

@immutable
abstract class NotificationEvents
{
  const NotificationEvents();
}

class FetchNotificationEvent extends NotificationEvents {}
class NotificationPageChangedEvent extends NotificationEvents {}