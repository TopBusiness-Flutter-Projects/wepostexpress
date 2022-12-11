import 'package:flutter/foundation.dart';
import 'package:wepostexpress/models/notification_model.dart';

@immutable
abstract class ThemeStates {
  const ThemeStates();
}

class InitialThemeState extends ThemeStates {}

class HasOpenedDemosThemeState extends ThemeStates {}

class LoadingThemeState extends ThemeStates {}

class LoadingFilterState extends ThemeStates {}

class SuccessFilterState extends ThemeStates {}

class ErrorFilterState extends ThemeStates {
  final String error;

  ErrorFilterState(this.error);
}

class LoadingIsChangingState extends ThemeStates {}

class LoadingCheckingState extends ThemeStates {}

class SuccessCheckingState extends ThemeStates {}

class LoadingSectionsState extends ThemeStates {}

class LoadingBlogsSectionsState extends ThemeStates {}

class SuccessSectionsState extends ThemeStates {}

class SuccessBlogsSectionsState extends ThemeStates {}

class SwitchPushNotificationsState extends ThemeStates {}

class GetCartProductsState extends ThemeStates {}

class SetCartProductsState extends ThemeStates {}

class CheckCartProductsState extends ThemeStates {}

class GetWishListProductsState extends ThemeStates {}

class LoadingBlockState extends ThemeStates {}

class SuccessBlockState extends ThemeStates
{
  final bool block;

  SuccessBlockState(this.block);
}

class ErrorBlockState extends ThemeStates {}

class ChangeBlockState extends ThemeStates {}

class SetWishListProductsState extends ThemeStates {}

class CheckWishListProductsState extends ThemeStates {}

class CheckMoreCartProductsState extends ThemeStates {}

class SwitchLanguageState extends ThemeStates {}

class SuccessFillRemoteFavState extends ThemeStates {}

class SuccessChangeFavState extends ThemeStates {}

class SuccessFillRemoteCartState extends ThemeStates {}

class SuccessGetLanguagesState extends ThemeStates {}

class SuccessGetCurrenciesState extends ThemeStates {}

class SuccessGetConfigState extends ThemeStates {}

class SuccessSetDirectionState extends ThemeStates {}

class SuccessGetDirectionState extends ThemeStates {}

class LoadingGetLanguagesState extends ThemeStates {}

class LoadingGetCurrenciesState extends ThemeStates {}

class SuccessFillLocalFavState extends ThemeStates {}

class SuccessActionLocalFavState extends ThemeStates {}

class FinishIsChangingState extends ThemeStates {}

class SuccessIsChangingState extends ThemeStates {}

class ReloadingThemeState extends ThemeStates {}

class SuccessThemeState extends ThemeStates {}

class SuccessShowNotificationState extends ThemeStates {}

class LoadShowNotificationState extends ThemeStates {}

class SuccessGetUserState extends ThemeStates {}

class SuccessGetLanguageState extends ThemeStates {}

class SuccessGetCurrencyState extends ThemeStates {}

class SuccessGetBottomTitlesState extends ThemeStates {}

class LoadingGetRemoteUserState extends ThemeStates {}

class SuccessGetRemoteUserState extends ThemeStates {}

class ChangeDevModeState extends ThemeStates {
  final bool isDevMode;

  ChangeDevModeState(this.isDevMode);
}

class NavigateFromNotificationState extends ThemeStates {
  final NotificationModel model;

  NavigateFromNotificationState(this.model);
}

class ErrorThemeState extends ThemeStates {
  final String error;

  ErrorThemeState(this.error);
}

class ErrorReportState extends ThemeStates {
  final String error;

  ErrorReportState(this.error);
}

class SuccessReportState extends ThemeStates {
}

class LoadingReportState extends ThemeStates {
}

class ThemeState extends ThemeStates {}
