import 'package:flutter/foundation.dart';

@immutable
abstract class SplashEvents
{
  const SplashEvents();
}

class FetchSplashEvent extends SplashEvents {}