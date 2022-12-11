import 'package:flutter/foundation.dart';

@immutable
abstract class ConfigLoaderEvents
{
  const ConfigLoaderEvents();
}

class FetchConfigLoaderEvent extends ConfigLoaderEvents {}
class FetchedConfigLoaderEvent extends ConfigLoaderEvents {}