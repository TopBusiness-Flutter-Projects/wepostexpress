import 'package:flutter/foundation.dart';

@immutable
abstract class GlobalEvents
{
  const GlobalEvents();
}

class FetchGlobalEvent extends GlobalEvents {}
class FetchGlobalLogoEvent extends GlobalEvents {}
class GlobalPageChangedEvent extends GlobalEvents {}

class ConnectionChangedGlobalEvent extends GlobalEvents {
  final bool isOnline;
  ConnectionChangedGlobalEvent(this.isOnline);
}