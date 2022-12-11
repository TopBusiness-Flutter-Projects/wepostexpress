import 'package:flutter/foundation.dart';

@immutable
abstract class SearchStates {
  const SearchStates();
}

class InitialSearchState extends SearchStates {}

class LoadingSearchState extends SearchStates {}
class LoadingProgressSearchState extends SearchStates {}

class SuccessSearchState extends SearchStates {}
class SearchedSuccessfully extends SearchStates {}
class SuccessGetAllCountriesSearchState extends SearchStates {}
class SuccessNextSearchState extends SearchStates {}

class SuccessStepForwardSearchState extends SearchStates {}
class SuccessStepBackwardSearchState extends SearchStates {}

class ErrorSearchState extends SearchStates {
  final String error;

  ErrorSearchState(this.error,);
}