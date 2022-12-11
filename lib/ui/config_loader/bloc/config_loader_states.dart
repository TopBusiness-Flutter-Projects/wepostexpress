import 'package:flutter/foundation.dart';

@immutable
abstract class ConfigLoaderStates {
  const ConfigLoaderStates();
}

class InitialConfigLoaderState extends ConfigLoaderStates {}

class LoadingConfigLoaderState extends ConfigLoaderStates {}

class SuccessConfigLoaderState extends ConfigLoaderStates {}

class ErrorConfigLoaderState extends ConfigLoaderStates {
  final String error;

  ErrorConfigLoaderState(this.error);
}