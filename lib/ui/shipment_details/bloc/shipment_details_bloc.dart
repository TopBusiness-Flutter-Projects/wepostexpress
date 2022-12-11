import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:wepostexpress/models/currency_model.dart';
import 'package:wepostexpress/models/payment_method_model.dart';
import 'package:wepostexpress/models/shipment_model.dart';
import 'package:wepostexpress/models/single_package_shipment_model.dart';
import 'package:wepostexpress/ui/shipment_details/bloc/shipment_details_events.dart';
import 'package:wepostexpress/ui/shipment_details/bloc/shipment_details_states.dart';
import 'package:wepostexpress/utils/network/repository.dart';

class ShipmentDetailsBloc extends Bloc<ShipmentDetailsEvents, ShipmentDetailsStates> {
  final Repository _repository;
  List<SinglePackageShipmentModel> packages =[];
  CurrencyModel currencyModel ;
  ShipmentModel shipmentModel;
  List<PaymentMethodModel> paymentTypes= [];

  ShipmentDetailsBloc(this._repository) : super(InitialShipmentDetailsState());

  static ShipmentDetailsBloc get(BuildContext context) => BlocProvider.of(context);

  @override
  Stream<ShipmentDetailsStates> mapEventToState(ShipmentDetailsEvents event) async*
  {
    if (event is NextShipmentDetailsEvent) {
      yield SuccessNextShipmentDetailsState();
    }
    if (event is FetchShipmentDetailsEvent) {
      yield LoadingShipmentDetailsState();
      if(event.code != null)
      {
        final getPaymentTypesResponse = await _repository.getPaymentTypes();
        getPaymentTypesResponse.fold((l)async* {
          yield ErrorShipmentDetailsState(l);
        }, (r) {
          return paymentTypes = r;
        });

        final f1 =await  _repository.getShipments(code: event.code);
        yield* f1.fold((l) => null, (r) async*{
          if(r != null && r.data != null && r.data.length==1){
            final getCurrenciesResponse = await  _repository.getCurrencies();
            getCurrenciesResponse.fold((l)async* {
              yield ErrorShipmentDetailsState(l);
            }, (r) {
              return currencyModel = r;
            });

            final f =await  _repository.getSingleShipmentPackages(shipmentId: r.data.first.id);
            shipmentModel = r.data.first;
            yield* f.fold((l) async*{
              yield ErrorShipmentDetailsState(l);
            }, (r) async*{
              packages = r;
              print('r.length');
              yield SuccessShipmentDetailsState();
            });
          }
        });
      }else{
        print('ollplpl');
        print(event.shipmentModel);
        final getCurrenciesResponse = await  _repository.getCurrencies();
        getCurrenciesResponse.fold((l)async* {
          yield ErrorShipmentDetailsState(l);
        }, (r) {
          return currencyModel = r;
        });


        final getPaymentTypesResponse = await _repository.getPaymentTypes();
        getPaymentTypesResponse.fold((l)async* {
          yield ErrorShipmentDetailsState(l);
        }, (r) {
          return paymentTypes = r;
        });

        shipmentModel = event.shipmentModel;
        final f =await  _repository.getSingleShipmentPackages(shipmentId: event.shipmentId);
        yield* f.fold((l) async*{
          yield ErrorShipmentDetailsState(l);
        }, (r) async*{
          packages = r;
          print('r.length');
          print(packages.length);
          yield SuccessShipmentDetailsState();
        });
      }
    }
  }
}
