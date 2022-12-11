import 'package:flutter/foundation.dart';
import 'package:wepostexpress/models/user/user_model.dart';

@immutable
abstract class SearchEvents
{
  const SearchEvents();
}

class SubmitSearchEvent extends SearchEvents {
  final UserModel userModel;
  SubmitSearchEvent({
    @required this.userModel,
});
}
class FetchSearchEvent extends SearchEvents {
  final String code;

  FetchSearchEvent(this.code);

}
class NextSearchEvent extends SearchEvents {}
class ChangeSearchEvent extends SearchEvents {}
class ChangeBackwardEvent extends SearchEvents {}

class FetchCitiesSearchEvent extends SearchEvents {
  final String countryId ;
  FetchCitiesSearchEvent({
    @required this.countryId,
  });
}

class FetchAreasSearchEvent extends SearchEvents {
  final String cityId ;
  FetchAreasSearchEvent({
    @required this.cityId,
  });
}
