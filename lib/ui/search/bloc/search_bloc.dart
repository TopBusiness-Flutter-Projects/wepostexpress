import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:geolocator/geolocator.dart';
import 'package:wepostexpress/models/address_model.dart';
import 'package:wepostexpress/models/area_model.dart';
import 'package:wepostexpress/models/county_model.dart';
import 'package:wepostexpress/models/shipment_model.dart';
import 'package:wepostexpress/models/state_model.dart';
import 'package:wepostexpress/ui/search/bloc/search_events.dart';
import 'package:wepostexpress/ui/search/bloc/search_states.dart';
import 'package:wepostexpress/utils/constants/constants.dart';
import 'package:wepostexpress/utils/network/repository.dart';
// import 'package:google_maps_flutter/google_maps_flutter.dart';

class SearchBloc extends Bloc<SearchEvents, SearchStates> {
  final Repository _repository;
  List<ShipmentModel> shipments=[];

  SearchBloc(this._repository) : super(InitialSearchState());

  static SearchBloc get(BuildContext context) => BlocProvider.of(context);

  @override
  Stream<SearchStates> mapEventToState(SearchEvents event) async*
  {
    if (event is NextSearchEvent) {
      yield SuccessNextSearchState();
    }
    if (event is FetchSearchEvent) {
      if(event.code!= null && event.code.trim().isNotEmpty){
        yield LoadingSearchState();
        final f =await  _repository.getShipments(code: event.code);
        yield* f.fold((l) async*{
          yield ErrorSearchState(l);
        }, (r) async*{
          shipments = r.data;
          print('r.length');
          print(r.data.length);
          yield SuccessSearchState();
        });

      }
    }
  }


}
