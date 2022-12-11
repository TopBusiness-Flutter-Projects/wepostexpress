import 'dart:io';
import 'dart:typed_data';

import 'package:wepostexpress/components/main_button.dart';
import 'package:wepostexpress/components/step_tracker.dart';
import 'package:wepostexpress/models/mission_model.dart';
import 'package:wepostexpress/models/reasons_model.dart';
import 'package:wepostexpress/models/shipment_model.dart';
import 'package:wepostexpress/ui/mission_shipments/bloc/mission_shipments_bloc.dart';
import 'package:wepostexpress/ui/mission_shipments/bloc/mission_shipments_events.dart';
import 'package:wepostexpress/ui/mission_shipments/bloc/mission_shipments_states.dart';
import 'package:wepostexpress/ui/shipment_details/shipment_details_screen.dart';
import 'package:wepostexpress/utils/config/config.dart';
import 'package:wepostexpress/utils/constants/app_keys.dart';
import 'package:wepostexpress/utils/constants/constants.dart';
import 'package:wepostexpress/utils/constants/local_keys.dart';
import 'package:wepostexpress/utils/di/di.dart';
import 'package:conditional_builder/conditional_builder.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:modal_bottom_sheet/modal_bottom_sheet.dart';
import 'package:signature/signature.dart';

class MissionShipmentsScreen extends StatelessWidget {
  final String missionID;

  MissionShipmentsScreen(this.missionID);

  @override
  Widget build(BuildContext context) {
    // print('missionModel');
    // print(missionModel.toJson());
    return BlocProvider<MissionShipmentsBloc>(
      create: (BuildContext context) =>
          di<MissionShipmentsBloc>()..add(FetchMissionShipmentsEvent(missionID)),
      child: BlocListener<MissionShipmentsBloc, MissionShipmentsStates>(
        listener: (BuildContext context, MissionShipmentsStates state) async {
          print('statestate');
          print(state);
          if (state is ErrorMissionShipmentsState) {
            showToast(state.error, false);
          }
          if (state is ShipmentChangedSuccessfullyMissionShipmentsState) {
            BlocProvider.of<MissionShipmentsBloc>(context).add(FetchMissionShipmentsEvent(missionID));
          }
          if (state is ShipmentRemovedSuccessfullyMissionShipmentsState) {
            showToast(tr(LocalKeys.shipmentRemovedSuccessfully), false);
          }
        },
        child: Builder(
          builder: (context) => SafeArea(
            child: Scaffold(
              body: Column(
                children: [
                  Container(
                    color: rgboOrHex(Config.get.styling[Config.get.themeMode].primary),
                    child: Column(
                      children: [
                        SizedBox(
                          height: MediaQuery.of(context).size.height * (1.2 / 100),
                        ),
                        Row(
                          children: [
                            SizedBox(
                              width: MediaQuery.of(context).size.height * (1.2 / 100),
                            ),
                            Container(
                              height: MediaQuery.of(context).size.height * (5.91 / 100),
                              child: IconButton(
                                icon: Icon(
                                  Icons.arrow_back_ios,
                                  color: rgboOrHex(
                                      Config.get.styling[Config.get.themeMode].buttonTextColor),
                                ),
                                onPressed: () {
                                  Navigator.pop(context);
                                },
                              ),
                            ),
                            Expanded(
                              child: Center(
                                child: Text(
                                  tr(LocalKeys.mission_shipments),
                                  style: TextStyle(
                                    fontSize: 16,
                                    color: rgboOrHex(
                                        Config.get.styling[Config.get.themeMode].buttonTextColor),
                                  ),
                                ),
                              ),
                            ),
                            Container(
                              width: MediaQuery.of(context).size.height * (5.91 / 100),
                            ),
                          ],
                        ),
                        SizedBox(
                          height: MediaQuery.of(context).size.height * (1.97 / 100),
                        ),
                      ],
                    ),
                  ),
                  BlocBuilder<MissionShipmentsBloc, MissionShipmentsStates>(
                    builder: (context, state) {
                      // print('state ksaodksa');
                      // print(BlocProvider.of<MissionShipmentsBloc>(context).missionModel.type == AppKeys.PICKUP_Key && int.parse(BlocProvider.of<MissionShipmentsBloc>(context).missionModel.status_id??'-1') == AppKeys.APPROVED_STATUS_MISSION);
                      return ConditionalBuilder(
                        condition: state is! LoadingMissionShipmentsState && BlocProvider.of<MissionShipmentsBloc>(context).missionModel != null ,
                        builder: (context) => Container(
                          width: double.infinity,
                          padding: EdgeInsets.symmetric(
                            horizontal: MediaQuery.of(context).size.width * (4.4 / 100),
                            vertical: MediaQuery.of(context).size.height * (2.4 / 100),
                          ),
                          margin: EdgeInsets.only(
                            right: MediaQuery.of(context).size.width * (6.4 / 100),
                            left: MediaQuery.of(context).size.width * (6.4 / 100),
                            bottom: MediaQuery.of(context).size.height * (2.4 / 100),
                            top: MediaQuery.of(context).size.height * (2.4 / 100),
                          ),
                          decoration: BoxDecoration(border: Border.all(width: 1,
                                  color: rgboOrHex(Config.get
                                          .styling[Config.get.themeMode].primary)
                          )),
                          child: ConditionalBuilder(
                            condition: BlocProvider.of<MissionShipmentsBloc>(context).missionModel.type != AppKeys.TRANSFER_Key,
                            builder: (context) => Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Text(
                                  tr(LocalKeys.mission_amount),
                                  textAlign: TextAlign.end,
                                  style: TextStyle(
                                          fontSize: 16,
                                          fontWeight: FontWeight.w400
                                  ),
                                ),
                                Text(
                                  (BlocProvider.of<MissionShipmentsBloc>(context).missionModel?.amount??'')+' '
                                          +(BlocProvider.of<MissionShipmentsBloc>(context).currencyModel?.symbol??''),
                                  textAlign: TextAlign.end,
                                  style: TextStyle(
                                          fontSize: 22,
                                          color: rgboOrHex(Config.get
                                                  .styling[Config.get.themeMode].primary),
                                          fontWeight: FontWeight.bold
                                  ),
                                ),
                              ],
                            ),
                            fallback: (context) => Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Text(
                                  tr(LocalKeys.to)+' '+tr(LocalKeys.branch),
                                  textAlign: TextAlign.end,
                                  style: TextStyle(
                                          fontSize: 16,
                                          fontWeight: FontWeight.w400
                                  ),
                                ),
                                Text(
                                  BlocProvider.of<MissionShipmentsBloc>(context).branches.firstWhere((element) {
                                    return element.id == BlocProvider.of<MissionShipmentsBloc>(context).missionModel.to_branch_id;
                                  }).name,
                                  textAlign: TextAlign.end,
                                  style: TextStyle(
                                          fontSize: 22,
                                          color: rgboOrHex(Config.get
                                                  .styling[Config.get.themeMode].primary),
                                          fontWeight: FontWeight.bold
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      );
                    },
                  ),
                  Expanded(
                    child: BlocBuilder<MissionShipmentsBloc, MissionShipmentsStates>(
                      builder: (context, state) => ConditionalBuilder(
                        condition: state is !LoadingMissionShipmentsState && BlocProvider.of<MissionShipmentsBloc>(context).missionModel != null,
                        builder: (context) => ListView.builder(
                          itemCount:
                              BlocProvider.of<MissionShipmentsBloc>(context).shipments.length,
                          itemBuilder: (BuildContext context, int index) {
                            print('index$index');
                            printFullText(BlocProvider.of<MissionShipmentsBloc>(context)
                                .shipments[index]
                                .toJson()
                                .toString());
                            return Row(
                              children: [
                                SizedBox(
                                  width: MediaQuery.of(context).size.width * (2.2 / 100),
                                ),
                                Expanded(
                                  child: Card(
                                    elevation: 10,
                                    shadowColor: Color(0xffF7F7FB),
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(15),
                                    ),
                                    margin: EdgeInsets.symmetric(
                                        vertical: MediaQuery.of(context).size.height * (2.4 / 100)),
                                    clipBehavior: Clip.antiAlias,
                                    child: InkWell(
                                      onTap: () {
                                        Navigator.push(
                                            context,
                                            MaterialPageRoute(
                                                builder: (_) => ShipmentDetailsScreen(
                                                    shipmentModel: BlocProvider.of<MissionShipmentsBloc>(context)
                                                        .shipments[index])));
                                      },
                                      child: Column(
                                        crossAxisAlignment: CrossAxisAlignment.start,
                                        children: [
                                          Row(
                                            children: [
                                              SizedBox(
                                                width:
                                                    MediaQuery.of(context).size.width * (4.2 / 100),
                                              ),
                                              Expanded(
                                                child: Column(
                                                  crossAxisAlignment: CrossAxisAlignment.start,
                                                  children: [
                                                    SizedBox(
                                                      height: MediaQuery.of(context).size.width *
                                                          (4.2 / 100),
                                                    ),
                                                    Text(
                                                      BlocProvider.of<MissionShipmentsBloc>(context)
                                                              ?.shipments[index]
                                                              ?.code ??
                                                          '',
                                                      style: TextStyle(
                                                        color: rgboOrHex(Config.get
                                                            .styling[Config.get.themeMode].primary),
                                                        fontSize: 16,
                                                        fontWeight: FontWeight.w500,
                                                      ),
                                                    ),
                                                  ],
                                                ),
                                              ),
                                              if(BlocProvider.of<MissionShipmentsBloc>(context).missionModel.type!= AppKeys.SUPPLY_Key)
                                              GestureDetector(
                                                onTap: () {
                                                  showDeleteBottomSheet(
                                                      context,
                                                      BlocProvider.of<MissionShipmentsBloc>(context)
                                                          .shipments[index]);
                                                },
                                                child: Container(
                                                  decoration: BoxDecoration(
                                                    color: Colors.redAccent,
                                                    borderRadius: BorderRadius.only(
                                                      topRight: Radius.circular(15.0),
                                                      bottomLeft: Radius.circular(15.0),
                                                    ),
                                                  ),
                                                  child: Padding(
                                                    padding: EdgeInsets.symmetric(
                                                      horizontal:
                                                          MediaQuery.of(context).size.width *
                                                              (4.0 / 100),
                                                      vertical: MediaQuery.of(context).size.width *
                                                          (2.5 / 100),
                                                    ),
                                                    child: Icon(
                                                      Icons.delete_outline_rounded,
                                                      color: Colors.white,
                                                    ),
                                                  ),
                                                ),
                                              ),
                                            ],
                                          ),
                                          SizedBox(
                                            height: (MediaQuery.of(context).size.height * (2.2 / 100)) ,
                                          ),

                                          Row(
                                            crossAxisAlignment: CrossAxisAlignment.end,
                                            children: [
                                              Container(
                                                decoration: BoxDecoration(
                                                  color: rgboOrHex(Config.get
                                                          .styling[Config.get.themeMode].primary)
                                                          .withOpacity(0.8),
                                                  borderRadius: BorderRadius.only(
                                                          topRight: Radius.circular(15.0),
                                                          bottomRight: Radius.circular(15.0)),
                                                ),
                                                padding: EdgeInsets.symmetric(
                                                  horizontal: MediaQuery.of(context).size.width *
                                                          (5.0 / 100),
                                                  vertical: MediaQuery.of(context).size.width *
                                                          (2.5 / 100),
                                                ),
                                                child: Text(
                                                  BlocProvider.of<MissionShipmentsBloc>(context)
                                                          .shipments[index]
                                                          ?.type ??
                                                          '',
                                                  style: TextStyle(
                                                    color: Colors.white,
                                                    fontWeight: FontWeight.w600,
                                                  ),
                                                ),
                                              ),
                                              Expanded(
                                                child: Container(
                                                  padding: EdgeInsets.symmetric(
                                                          horizontal:
                                                          MediaQuery.of(context).size.width *
                                                                  (4.2 / 100),
                                                          vertical: MediaQuery.of(context).size.width *
                                                                  (2.2 / 100)),
                                                  width: double.infinity,
                                                  child: Text(
                                                            () {
                                                      String txt = '';
                                                      try {
                                                        return BlocProvider.of<
                                                                MissionShipmentsBloc>(context)
                                                                .paymentTypes != []?BlocProvider.of<
                                                                MissionShipmentsBloc>(context)
                                                                .paymentTypes
                                                                ?.firstWhere((element) {
                                                          print('dsadasd');
                                                          print(BlocProvider.of<
                                                                  MissionShipmentsBloc>(context)
                                                                  .shipments[index]
                                                                  .payment_method_id
                                                                  .toString());
                                                          return element.id.toString() ==
                                                                  BlocProvider.of<
                                                                          MissionShipmentsBloc>(
                                                                          context)
                                                                          .shipments[index]
                                                                          .payment_method_id
                                                                          .toString() ||
                                                                  BlocProvider.of<MissionShipmentsBloc>(
                                                                          context)
                                                                          .shipments[index]
                                                                          .payment_type
                                                                          .toString() ==
                                                                          '1';
                                                        })?.name ??
                                                                '':'';
                                                      } on Exception catch (e) {
                                                        return '';
                                                      }
                                                    }(),
                                                    style: TextStyle(
                                                      color: rgboOrHex(Config.get
                                                              .styling[Config.get.themeMode].secondary),
                                                      fontSize: 16,
                                                      fontWeight: FontWeight.w500,
                                                    ),
                                                    textAlign: TextAlign.end,
                                                  ),
                                                ),
                                              ),
                                            ],
                                          ),
                                          SizedBox(
                                            height:
                                                (MediaQuery.of(context).size.height * (2.2 / 100)),
                                          ),
                                          Row(
                                            children: [
                                              SizedBox(
                                                width:
                                                    MediaQuery.of(context).size.width * (4.2 / 100),
                                              ),
                                              Expanded(
                                                  child: StepTracker(
                                                title:
                                                    BlocProvider.of<MissionShipmentsBloc>(context)
                                                            .shipments[index]
                                                            .from_address?.address ??
                                                        '',
                                                icon: null,
                                                isLast: false,
                                              )),
                                            ],
                                          ),
                                          Row(
                                            children: [
                                              SizedBox(
                                                width:
                                                    MediaQuery.of(context).size.width * (4.2 / 100),
                                              ),
                                              Expanded(
                                                  child: StepTracker(
                                                title:
                                                    BlocProvider.of<MissionShipmentsBloc>(context)
                                                            ?.shipments[index]
                                                            ?.reciver_address ??
                                                        '',
                                                icon: null,
                                                isLast: true,
                                              )),
                                            ],
                                          ),
                                          SizedBox(
                                            height:
                                            (MediaQuery.of(context).size.height * (4.2 / 100)) /
                                                    3,
                                          ),
                                          if(BlocProvider.of<MissionShipmentsBloc>(context).missionModel.type == AppKeys.DELIVERY_Key )
                                          Row(
                                            crossAxisAlignment: CrossAxisAlignment.end,
                                            children: [
                                              Expanded(
                                                child: Container(
                                                  padding: EdgeInsets.symmetric(
                                                          horizontal:
                                                          MediaQuery.of(context).size.width *
                                                                  (1.2 / 100),
                                                          vertical: MediaQuery.of(context).size.width *
                                                                  (2.2 / 100)),
                                                  width: double.infinity,
                                                  child: Text(
                                                    tr(LocalKeys.amount_to_be_collected),
                                                    style: TextStyle(
                                                      color: rgboOrHex(Config.get
                                                              .styling[Config.get.themeMode].secondary),
                                                      fontSize: 16,
                                                      fontWeight: FontWeight.w500,
                                                    ),
                                                    textAlign: TextAlign.start,
                                                  ),
                                                ),
                                              ),
                                              Container(
                                                padding: EdgeInsets.symmetric(
                                                        horizontal:
                                                        MediaQuery.of(context).size.width *
                                                                (2.2 / 100),
                                                        vertical: MediaQuery.of(context).size.width *
                                                                (2.2 / 100)),
                                                child: Text(
                                                  (BlocProvider.of<MissionShipmentsBloc>(context).shipments[index].amount_to_be_collected)+' '+(BlocProvider.of<MissionShipmentsBloc>(context).currencyModel?.symbol??''),
                                                  style: TextStyle(
                                                    // color: rgboOrHex(Config.get
                                                    //         .styling[Config.get.themeMode].secondary),
                                                    fontSize: 18,
                                                    fontWeight: FontWeight.bold,
                                                  ),
                                                  textAlign: TextAlign.end,
                                                ),
                                              ),

                                            ],
                                          ),

                                          if(BlocProvider.of<MissionShipmentsBloc>(context).missionModel.type == AppKeys.DELIVERY_Key )
                                            SizedBox(
                                            height:
                                            (MediaQuery.of(context).size.height * (4.2 / 100)) /
                                                    3,
                                          ),
                                          if(BlocProvider.of<MissionShipmentsBloc>(context).missionModel.type == AppKeys.DELIVERY_Key
                                                  &&int.parse(BlocProvider.of<MissionShipmentsBloc>(context).missionModel.status_id??'-1') == AppKeys.RECEIVED_STATUS_MISSION
                                                  && BlocProvider.of<MissionShipmentsBloc>(context).shipments[index].status_id != AppKeys.DELIVERED_STATUS.toString())
                                          InkWell(
                                            onTap:(){
                                              showChangeStatusForDeliveryBottomSheet(
                                                context,
                                                      BlocProvider.of<MissionShipmentsBloc>(context).shipments[index].id
                                              );
                                            },
                                            child: Container(
                                              width:double.infinity,
                                              decoration: BoxDecoration(
                                                color: rgboOrHex(Config.get
                                                        .styling[Config.get.themeMode].primary)
                                                        .withOpacity(0.8),
                                                borderRadius: BorderRadius.only(
                                                        bottomRight: Radius.circular(15.0),
                                                        bottomLeft: Radius.circular(15.0)),
                                              ),
                                              padding: EdgeInsets.symmetric(
                                                horizontal: MediaQuery.of(context).size.width *
                                                        (5.0 / 100),
                                                vertical: MediaQuery.of(context).size.height *
                                                        (2.5 / 100),
                                              ),
                                              child: Text(
                                                tr(LocalKeys.changeToDone),
                                                style: TextStyle(
                                                  color: Colors.white,
                                                  fontSize: 16,
                                                  fontWeight: FontWeight.bold,
                                                ),
                                              ),
                                              alignment: Alignment.center,
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                  ),
                                ),
                                SizedBox(
                                  width: MediaQuery.of(context).size.width * (2.2 / 100),
                                ),
                              ],
                            );
                          },
                        ),
                        fallback: (context) => Center(
                          child: Padding(
                            padding: EdgeInsets.all(40.0),
                            child: Column(
                              mainAxisSize: MainAxisSize.max,
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                CircularProgressIndicator(),
                              ],
                            ),
                          ),
                        ),
                      ),
                    ),
                  ),
                  BlocBuilder<MissionShipmentsBloc, MissionShipmentsStates>(
                    builder: (context, state) {
                      // print('state ksaodksa');
                      // print(BlocProvider.of<MissionShipmentsBloc>(context).missionModel.type == AppKeys.PICKUP_Key && int.parse(BlocProvider.of<MissionShipmentsBloc>(context).missionModel.status_id??'-1') == AppKeys.APPROVED_STATUS_MISSION);
                      return ConditionalBuilder(
                      condition: state is! LoadingMissionShipmentsState && BlocProvider.of<MissionShipmentsBloc>(context).missionModel != null && (
                              (BlocProvider.of<MissionShipmentsBloc>(context).missionModel.type == AppKeys.PICKUP_Key && int.parse(BlocProvider.of<MissionShipmentsBloc>(context).missionModel.status_id??'-1') == AppKeys.APPROVED_STATUS_MISSION)||
                                      (BlocProvider.of<MissionShipmentsBloc>(context).missionModel.type == AppKeys.DELIVERY_Key &&int.parse(BlocProvider.of<MissionShipmentsBloc>(context).missionModel.status_id??'-1') == AppKeys.APPROVED_STATUS_MISSION)||
                                      (BlocProvider.of<MissionShipmentsBloc>(context).missionModel.type == AppKeys.TRANSFER_Key &&int.parse(BlocProvider.of<MissionShipmentsBloc>(context).missionModel.status_id??'-1') == AppKeys.APPROVED_STATUS_MISSION)||
                                      (BlocProvider.of<MissionShipmentsBloc>(context).missionModel.type == AppKeys.RETURN_Key &&int.parse(BlocProvider.of<MissionShipmentsBloc>(context).missionModel.status_id??'-1') == AppKeys.APPROVED_STATUS_MISSION)||
                                      (BlocProvider.of<MissionShipmentsBloc>(context).missionModel.type == AppKeys.RETURN_Key &&int.parse(BlocProvider.of<MissionShipmentsBloc>(context).missionModel.status_id??'-1') == AppKeys.RECEIVED_STATUS_MISSION)||
                                      (BlocProvider.of<MissionShipmentsBloc>(context).missionModel.type == AppKeys.SUPPLY_Key &&int.parse(BlocProvider.of<MissionShipmentsBloc>(context).missionModel.status_id??'-1') != AppKeys.DONE_STATUS_MISSION)),
                      builder: (context) => Padding(
                        padding: EdgeInsets.symmetric(
                          horizontal: MediaQuery.of(context).size.width * (6.4 / 100),
                          vertical: MediaQuery.of(context).size.height * (2.4 / 100),
                        ),
                        child: MainButton(
                          isLoading: false,
                          borderColor:
                          rgboOrHex(Config.get.styling[Config.get.themeMode].secondaryVariant),
                          borderRadius: 0,
                          onPressed: () {
                            print(BlocProvider.of<MissionShipmentsBloc>(context).missionModel.type);
                            print(BlocProvider.of<MissionShipmentsBloc>(context).missionModel.status_id);
                            if (int.parse(BlocProvider.of<MissionShipmentsBloc>(context).missionModel.status_id??'-1') == AppKeys.APPROVED_STATUS_MISSION) {
                              showChangeStatusForPickupBottomSheet(
                                context,
                              );
                            }else{
                              showChangeStatusBottomSheet(
                                context,
                              );
                            }
                          },
                          text: tr((int.parse(BlocProvider.of<MissionShipmentsBloc>(context).missionModel.status_id??'-1') == AppKeys.APPROVED_STATUS_MISSION)?LocalKeys.changeToReceived:LocalKeys.changeToDone),
                          textColor:
                          rgboOrHex(Config.get.styling[Config.get.themeMode].buttonTextColor),
                          color: rgboOrHex(Config.get.styling[Config.get.themeMode].primary),
                        ),
                      ),
                    );
                    },
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  showDeleteBottomSheet(BuildContext context, ShipmentModel shipment) async {
    final blocContext = context;
    await showMaterialModalBottomSheet(
        backgroundColor: Colors.transparent,
        context: context,
        builder: (context) => RemoveShipmentScreen(blocContext, BlocProvider.of<MissionShipmentsBloc>(blocContext).missionModel, shipment));
  }

  showChangeStatusBottomSheet(
    BuildContext context,
  ) async {
    final blocContext = context;
    await showModalBottomSheet(
        enableDrag: false,
        backgroundColor: Colors.transparent,isScrollControlled: true,
        context: context,
        builder: (context) => ChangeStatusScreen(
              blocContext,
          BlocProvider.of<MissionShipmentsBloc>(blocContext).missionModel,
            ));
  }

  showChangeStatusForDeliveryBottomSheet(
    BuildContext context,
          String shipment_id,
  ) async {
    final blocContext = context;
    await showModalBottomSheet(
        enableDrag: false,
        backgroundColor: Colors.transparent,isScrollControlled: true,
        context: context,
        builder: (context) => ChangeStatusScreen(
              blocContext,
          BlocProvider.of<MissionShipmentsBloc>(blocContext).missionModel,
          shipment_id: shipment_id,
            ));
  }

  showChangeStatusForPickupBottomSheet(
    BuildContext context,
  ) async {
    final blocContext = context;
    await showModalBottomSheet(
        enableDrag: false,
        backgroundColor: Colors.transparent,isScrollControlled: true,
        context: context,
        builder: (context) => ChangeStatusForPickupScreen(
              blocContext,
          BlocProvider.of<MissionShipmentsBloc>(blocContext).missionModel,
            ));
  }
}

class RemoveShipmentScreen extends StatefulWidget {
  final BuildContext blocContext;
  final MissionModel missionModel;
  final ShipmentModel shipmentModel;

  RemoveShipmentScreen(this.blocContext, this.missionModel, this.shipmentModel);

  @override
  _RemoveShipmentScreenState createState() => _RemoveShipmentScreenState();
}

class _RemoveShipmentScreenState extends State<RemoveShipmentScreen> {
  ReasonsModel selectedReasonsModel;

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: BlocProvider.value(
        value: BlocProvider.of<MissionShipmentsBloc>(context),
        child: Material(
          child: Builder(
            builder: (context) => Container(
              decoration: BoxDecoration(
                borderRadius: BorderRadius.only(
                  topRight: Radius.circular(20),
                  topLeft: Radius.circular(20),
                ),
              ),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Container(
                    width: double.infinity,
                    padding: EdgeInsets.symmetric(
                        horizontal: MediaQuery.of(context).size.width * (6.4 / 100),
                        vertical: MediaQuery.of(context).size.width * (3.4 / 100)),
                    child: Text(
                      tr(LocalKeys.pleaseChooseWhyYouWantToRemoveThisShipment),
                      textAlign: TextAlign.start,
                      style: TextStyle(
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ),
                  Container(
                    decoration: BoxDecoration(
                      border: Border.all(
                        width: 1,
                        color: rgboOrHex(Config.get.styling[Config.get.themeMode].secondary),
                      ),
                      borderRadius: BorderRadius.all(Radius.circular(15.0)),
                    ),
                    padding: EdgeInsets.symmetric(
                        horizontal: MediaQuery.of(context).size.width * (6.4 / 100),
                        vertical: MediaQuery.of(context).size.width * (3.4 / 100)),
                    margin: EdgeInsets.symmetric(
                        horizontal: MediaQuery.of(context).size.width * (6.4 / 100),
                        vertical: MediaQuery.of(context).size.width * (3.4 / 100)),
                    child: Column(
                      children: [
                        Container(
                          width: double.infinity,
                          child: Text(
                            tr(LocalKeys.reason),
                            textAlign: TextAlign.start,
                            style: TextStyle(
                              color: rgboOrHex(Config.get.styling[Config.get.themeMode].secondary),
                            ),
                          ),
                        ),
                        DropdownButton(
                          style: TextStyle(color: Colors.black),
                          iconSize: 25,
                          value: selectedReasonsModel ??
                              BlocProvider.of<MissionShipmentsBloc>(widget.blocContext)
                                  .reasons
                                  .first,
                          isExpanded: true,
                          items: BlocProvider.of<MissionShipmentsBloc>(widget.blocContext)
                              .reasons
                              .map((value) {
                            return DropdownMenuItem(
                              child: Text(
                                value.name,
                                style: TextStyle(
                                  fontSize: 14,
                                ),
                              ),
                              value: value,
                            );
                          }).toList(),
                          onChanged: (value) {
                            setState(() {
                              selectedReasonsModel = value;
                            });
                          },
                          elevation: 0,
                        ),
                      ],
                    ),
                  ),
                  MaterialButton(
                    onPressed: () {
                      BlocProvider.of<MissionShipmentsBloc>(widget.blocContext).add(
                          DeleteShipmentFromMissionEvent(
                              missionId: widget.missionModel.id,
                              reasonsModel: selectedReasonsModel ??
                                  BlocProvider.of<MissionShipmentsBloc>(widget.blocContext)
                                      .reasons
                                      .first,
                              shipmentId: widget.shipmentModel.id));
                      Navigator.pop(context);
                    },
                    padding: EdgeInsets.symmetric(
                        horizontal: MediaQuery.of(context).size.width * (6.4 / 100),
                        vertical: MediaQuery.of(context).size.width * (3.4 / 100)),
                    child: Container(
                      alignment: Alignment.center,
                      width: double.infinity,
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(
                            Icons.delete_outline_rounded,
                            color: Colors.redAccent,
                          ),
                          SizedBox(
                            width: MediaQuery.of(context).size.width * (1.4 / 100),
                          ),
                          Text(
                            tr(LocalKeys.confirm),
                            style: TextStyle(
                                color: Colors.redAccent, fontWeight: FontWeight.bold, fontSize: 16),
                          ),
                        ],
                      ),
                    ),
                  ),
                  Container(
                    color: rgboOrHex(Config.get.styling[Config.get.themeMode].secondary),
                    width: double.infinity,
                    height: 1,
                  ),
                  MaterialButton(
                    onPressed: () => Navigator.pop(context),
                    padding: EdgeInsets.symmetric(
                        horizontal: MediaQuery.of(context).size.width * (6.4 / 100),
                        vertical: MediaQuery.of(context).size.width * (3.4 / 100)),
                    child: Container(
                      alignment: Alignment.center,
                      width: double.infinity,
                      child: Text(
                        tr(
                          LocalKeys.cancel,
                        ),
                        style: TextStyle(fontWeight: FontWeight.w500, fontSize: 16),
                      ),
                    ),
                  ),
                  SizedBox(
                    height: MediaQuery.of(context).size.width * (3.4 / 100),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class ChangeStatusScreen extends StatefulWidget {
  final BuildContext blocContext;
  final MissionModel missionModel;
  final String shipment_id;

  // final ShipmentModel shipmentModel;
  ChangeStatusScreen(this.blocContext, this.missionModel, {this.shipment_id});

  @override
  _ChangeStatusScreenState createState() => _ChangeStatusScreenState();
}

class _ChangeStatusScreenState extends State<ChangeStatusScreen> {
  ReasonsModel selectedReasonsModel;

  final SignatureController _controller = SignatureController(
    penStrokeWidth: 3,
    penColor: Colors.red,
    exportBackgroundColor: Colors.blue,
    onDrawStart: () => print('onDrawStart called!'),
    onDrawEnd: () => print('onDrawEnd called!'),
  );
  final TextEditingController controller = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: BlocProvider.value(
        value: BlocProvider.of<MissionShipmentsBloc>(context),
        child: Material(
          child: Builder(
            builder: (context) => Container(
              decoration: BoxDecoration(
                borderRadius: BorderRadius.only(
                  topRight: Radius.circular(20),
                  topLeft: Radius.circular(20),
                ),
              ),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  if (BlocProvider.of<MissionShipmentsBloc>(widget.blocContext)
                          .missionConfirmationType
                          .value ==
                      AppKeys.MISSION_CONFIRMATION_TYPE_SIGNATURE)
                    Column(
                      children: [
                        SizedBox(
                          height: MediaQuery.of(context).size.width * (3.4 / 100),
                        ),
                        Container(
                          width: double.infinity,
                          padding: EdgeInsets.symmetric(
                            horizontal: MediaQuery.of(context).size.width * (6.4 / 100),
                          ),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text(
                                tr(LocalKeys.signature),
                                textAlign: TextAlign.start,
                                style: TextStyle(
                                  fontWeight: FontWeight.w500,
                                ),
                              ),
                              MaterialButton(
                                onPressed: () {
                                  _controller.clear();
                                },
                                color: rgboOrHex(Config.get.styling[Config.get.themeMode].primary),
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.all(Radius.circular(15.0)),
                                ),
                                padding: EdgeInsets.symmetric(
                                    horizontal: MediaQuery.of(context).size.width * (6.4 / 100),
                                    vertical: MediaQuery.of(context).size.width * (3.4 / 100)),
                                child: Container(
                                  child: Text(
                                    tr(LocalKeys.clear),
                                    style: TextStyle(
                                      fontWeight: FontWeight.w500,
                                      color: rgboOrHex(
                                          Config.get.styling[Config.get.themeMode].buttonTextColor),
                                    ),
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                        Container(
                          height: 300,
                          margin: EdgeInsets.symmetric(
                              horizontal: MediaQuery.of(context).size.width * (6.4 / 100),
                              vertical: MediaQuery.of(context).size.width * (3.4 / 100)),
                          clipBehavior: Clip.antiAlias,
                          decoration: BoxDecoration(
                            border: Border.all(
                              width: 1,
                              color: rgboOrHex(Config.get.styling[Config.get.themeMode].secondary),
                            ),
                            borderRadius: BorderRadius.all(Radius.circular(5.0)),
                          ),
                          child: Stack(
                            children: [
                              Signature(
                                controller: _controller,
                                height: 300,
                                backgroundColor: Colors.white,
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  if (BlocProvider.of<MissionShipmentsBloc>(widget.blocContext)
                          .missionConfirmationType
                          .value ==
                          AppKeys.MISSION_CONFIRMATION_TYPE_OTP)
                  Column(
                    children: [
                      SizedBox(
                        height: MediaQuery.of(context).size.width * (3.4 / 100),
                      ),
                      Container(
                        width: double.infinity,
                        padding: EdgeInsets.symmetric(
                                horizontal: MediaQuery.of(context).size.width * (6.4 / 100),
                                vertical: MediaQuery.of(context).size.width * (1.4 / 100)),
                        child: Text(
                          tr(LocalKeys.pleaseEnterOTP),
                          textAlign: TextAlign.start,
                          style: TextStyle(
                            fontWeight: FontWeight.w500,
                            fontSize: 15,
                          ),
                        ),
                      ),

                      Container(
                        decoration: BoxDecoration(
                          border: Border.all(
                            width: 1,
                            color: rgboOrHex(Config.get.styling[Config.get.themeMode].secondary),
                          ),
                          borderRadius: BorderRadius.all(Radius.circular(15.0)),
                        ),
                        padding: EdgeInsets.symmetric(
                            horizontal: MediaQuery.of(context).size.width * (6.4 / 100),
                            vertical: MediaQuery.of(context).size.width * (3.4 / 100)),
                        margin: EdgeInsets.symmetric(
                            horizontal: MediaQuery.of(context).size.width * (6.4 / 100),
                            vertical: MediaQuery.of(context).size.width * (3.4 / 100)),
                        child: Container(
                          width: double.infinity,
                          child: TextField(
                            controller: controller,
                            decoration: InputDecoration(
                              focusedBorder: InputBorder.none,
                              border: InputBorder.none,
                                hintText: tr(LocalKeys.otp),
                            ),
                            keyboardType: TextInputType.number,
                            textAlign: TextAlign.start,
                          ),
                        ),
                      ),
                    ],
                  ),

                  MaterialButton(
                    onPressed: () async{
                      Uint8List image =  await  _controller.toPngBytes();
                      BlocProvider.of<MissionShipmentsBloc>(widget.blocContext).add(ChangeMissionStatusEvent(
                        to: AppKeys.DONE_STATUS_MISSION.toString(),
                        checked_ids: widget.missionModel.id,
                        amount: widget.missionModel.amount,
                        otp_confirm: controller?.text??'',
                        shipment_id: widget.shipment_id,
                        isPickup: false,
                        image: image,
                        missionModel: widget.missionModel,
                      ),
                      );
                      Navigator.pop(context);
                    },
                    padding: EdgeInsets.symmetric(
                        horizontal: MediaQuery.of(context).size.width * (6.4 / 100),
                        vertical: MediaQuery.of(context).size.width * (3.4 / 100)),
                    child: Container(
                      alignment: Alignment.center,
                      width: double.infinity,
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(
                            Icons.done_outline_rounded,
                            color: rgboOrHex(Config.get.styling[Config.get.themeMode].primary),
                          ),
                          SizedBox(
                            width: MediaQuery.of(context).size.width * (1.4 / 100),
                          ),
                          Text(
                            tr(LocalKeys.confirm),
                            style: TextStyle(
                                color: rgboOrHex(Config.get.styling[Config.get.themeMode].primary),
                                fontWeight: FontWeight.bold,
                                fontSize: 16),
                          ),
                        ],
                      ),
                    ),
                  ),
                  Container(
                    color: rgboOrHex(Config.get.styling[Config.get.themeMode].secondary),
                    width: double.infinity,
                    height: 1,
                  ),
                  MaterialButton(
                    onPressed: () => Navigator.pop(context),
                    padding: EdgeInsets.symmetric(
                        horizontal: MediaQuery.of(context).size.width * (6.4 / 100),
                        vertical: MediaQuery.of(context).size.width * (3.4 / 100)),
                    child: Container(
                      alignment: Alignment.center,
                      width: double.infinity,
                      child: Text(
                        tr(
                          LocalKeys.cancel,
                        ),
                        style: TextStyle(fontWeight: FontWeight.w500, fontSize: 16),
                      ),
                    ),
                  ),
                  SizedBox(
                    height: MediaQuery.of(context).size.width * (3.4 / 100),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class ChangeStatusForPickupScreen extends StatefulWidget {
  final BuildContext blocContext;
  final MissionModel missionModel;

  // final ShipmentModel shipmentModel;
  ChangeStatusForPickupScreen(this.blocContext, this.missionModel);

  @override
  _ChangeStatusForPickupScreenState createState() => _ChangeStatusForPickupScreenState();
}

class _ChangeStatusForPickupScreenState extends State<ChangeStatusForPickupScreen> {
  ReasonsModel selectedReasonsModel;
  TextEditingController textEditingController;

  final SignatureController _controller = SignatureController(
    penStrokeWidth: 3,
    penColor: Colors.red,
    exportBackgroundColor: Colors.blue,
    onDrawStart: () => print('onDrawStart called!'),
    onDrawEnd: () => print('onDrawEnd called!'),
  );
  @override
  void initState() {
    textEditingController = TextEditingController(text: widget.missionModel.amount);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: BlocProvider.value(
        value: BlocProvider.of<MissionShipmentsBloc>(context),
        child: Material(
          child: Builder(
            builder: (context) => Container(
              decoration: BoxDecoration(
                borderRadius: BorderRadius.only(
                  topRight: Radius.circular(20),
                  topLeft: Radius.circular(20),
                ),
              ),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Column(
                    children: [
                      SizedBox(
                        height: MediaQuery.of(context).size.width * (3.4 / 100),
                      ),
                      Container(
                        width: double.infinity,
                        padding: EdgeInsets.symmetric(
                                horizontal: MediaQuery.of(context).size.width * (6.4 / 100),
                                vertical: MediaQuery.of(context).size.width * (1.4 / 100)),
                        child: Text(
                          tr(LocalKeys.amount_to_be_collected),
                          textAlign: TextAlign.start,
                          style: TextStyle(
                            fontWeight: FontWeight.w500,
                            fontSize: 15,
                          ),
                        ),
                      ),

                      Container(
                        decoration: BoxDecoration(
                          border: Border.all(
                            width: 1,
                            color: rgboOrHex(Config.get.styling[Config.get.themeMode].secondary),
                          ),
                          borderRadius: BorderRadius.all(Radius.circular(15.0)),
                        ),
                        padding: EdgeInsets.symmetric(
                            horizontal: MediaQuery.of(context).size.width * (6.4 / 100),
                            vertical: MediaQuery.of(context).size.width * (3.4 / 100)),
                        margin: EdgeInsets.symmetric(
                            horizontal: MediaQuery.of(context).size.width * (6.4 / 100),
                            vertical: MediaQuery.of(context).size.width * (3.4 / 100)),
                        child: Container(
                          width: double.infinity,
                          child: TextField(
                            controller: textEditingController,
                            enabled: widget.missionModel.type == AppKeys.PICKUP_Key,
                            decoration: InputDecoration(
                              focusedBorder: InputBorder.none,
                              border: InputBorder.none,
                                hintText: tr(LocalKeys.amount_to_be_collected),
                            ),
                            keyboardType: TextInputType.number,
                            textAlign: TextAlign.start,
                          ),
                        ),
                      ),
                    ],
                  ),

                  MaterialButton(
                    onPressed: () {
                      BlocProvider.of<MissionShipmentsBloc>(widget.blocContext).add(ChangeMissionStatusEvent(
                        to: AppKeys.RECEIVED_STATUS_MISSION.toString(),
                        checked_ids: widget.missionModel.id,
                        shipment_id: null,
                        amount: widget.missionModel.amount,
                        otp_confirm: null,
                        isPickup: true,
                        image: null,
                        missionModel: widget.missionModel,
                      ),
                      );
                      Navigator.pop(context);
                    },
                    padding: EdgeInsets.symmetric(
                        horizontal: MediaQuery.of(context).size.width * (6.4 / 100),
                        vertical: MediaQuery.of(context).size.width * (3.4 / 100)),
                    child: Container(
                      alignment: Alignment.center,
                      width: double.infinity,
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(
                            Icons.done_outline_rounded,
                            color: rgboOrHex(Config.get.styling[Config.get.themeMode].primary),
                          ),
                          SizedBox(
                            width: MediaQuery.of(context).size.width * (1.4 / 100),
                          ),
                          Text(
                            tr(LocalKeys.confirm),
                            style: TextStyle(
                                color: rgboOrHex(Config.get.styling[Config.get.themeMode].primary),
                                fontWeight: FontWeight.bold,
                                fontSize: 16),
                          ),
                        ],
                      ),
                    ),
                  ),
                  Container(
                    color: rgboOrHex(Config.get.styling[Config.get.themeMode].secondary),
                    width: double.infinity,
                    height: 1,
                  ),
                  MaterialButton(
                    onPressed: () => Navigator.pop(context),
                    padding: EdgeInsets.symmetric(
                        horizontal: MediaQuery.of(context).size.width * (6.4 / 100),
                        vertical: MediaQuery.of(context).size.width * (3.4 / 100)),
                    child: Container(
                      alignment: Alignment.center,
                      width: double.infinity,
                      child: Text(
                        tr(
                          LocalKeys.cancel,
                        ),
                        style: TextStyle(fontWeight: FontWeight.w500, fontSize: 16),
                      ),
                    ),
                  ),
                  SizedBox(
                    height: MediaQuery.of(context).size.width * (3.4 / 100),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
