import 'package:wepostexpress/components/empty_content.dart';
import 'package:wepostexpress/utils/constants/app_keys.dart';
import 'package:conditional_builder/conditional_builder.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:wepostexpress/components/my_svg.dart';
import 'package:wepostexpress/components/qr_code.dart';
import 'package:wepostexpress/ui/home/bloc/home_bloc.dart';
import 'package:wepostexpress/ui/home/bloc/home_events.dart';
import 'package:wepostexpress/ui/home/bloc/home_states.dart';
import 'package:wepostexpress/ui/mission_shipments/mission_shipments_screen.dart';
import 'package:wepostexpress/ui/search/search_screen.dart';
import 'package:wepostexpress/utils/config/config.dart';
import 'package:wepostexpress/utils/constants/constants.dart';
import 'package:wepostexpress/utils/constants/local_keys.dart';
import 'package:wepostexpress/models/mission_model.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';

class HomeSingleScreen extends StatefulWidget {
  HomeSingleScreen();

  @override
  _HomeSingleScreenState createState() => _HomeSingleScreenState();
}

class _HomeSingleScreenState extends State<HomeSingleScreen> {
  ScrollController scrollControllerShipments = ScrollController(keepScrollOffset: true);
  bool gettingData = false;
  bool isLastValue = false;
  RefreshController _refreshController = RefreshController(initialRefresh: false);
  RefreshController _refreshController2 = RefreshController(initialRefresh: false);
  RefreshController _refreshController3 = RefreshController(initialRefresh: false);

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 3,
      child: Scaffold(
        body: NestedScrollView(
          floatHeaderSlivers: true,
          headerSliverBuilder: (context, innerBoxIsScrolled) => [
            SliverToBoxAdapter(
              child: Container(
                height: (MediaQuery.of(context).size.height * (47.0 / 100)) -
                    (MediaQuery.of(context).size.height * (3.0 / 100)),
                color: rgboOrHex(Config.get.styling[Config.get.themeMode].primary),
                child: Stack(
                  children: [
                    Column(
                      children: [
                        Expanded(
                          child: MySVG(
                            svgPath: 'assets/icons/splash_background.svg',
                          ),
                        ),
                        Spacer(),
                      ],
                    ),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                          Expanded(
                          child: Center(
                            child: Padding(
                              padding: EdgeInsets.all(40.0),
                              child: MySVG(
                                    size: MediaQuery.of(context).size.height * (11 / 100),
                                    svgPath: 'assets/icons/logo.svg',
                                  ),
                            ),
                          ),
                        ),
                        Expanded(
                          flex: 1,
                          child: Column(
                            children: [
                              Container(
                                width: double.infinity,
                                margin: EdgeInsets.symmetric(
                                    horizontal: MediaQuery.of(context).size.width * (5.3 / 100)),
                                decoration: BoxDecoration(
                                  color: Colors.white,
                                  borderRadius: BorderRadius.all(Radius.circular(50.0)),
                                ),
                                child: Row(
                                  children: [
                                    Expanded(
                                      child: TextField(
                                        maxLines: 1,
                                        readOnly: true,
                                        textAlign: TextAlign.start,
                                        onTap: (){
                                          Navigator.push(context,MaterialPageRoute(builder: (_)=>SearchScreen(code: null,)));
                                        },
                                        decoration: InputDecoration(
                                          hintText: tr(LocalKeys.your_tracking_id),
                                          hintStyle: TextStyle(
                                              fontSize: 14,
                                              color: rgboOrHex(Config.get.styling[Config.get.themeMode].secondary)),
                                          border: InputBorder.none,
                                          prefixIcon: SizedBox(
                                            width: MediaQuery.of(context).size.height * (1.72 / 100),
                                            height: MediaQuery.of(context).size.height * (1.72 / 100),
                                            child: Padding(
                                              padding: EdgeInsets.all(15.0),
                                              child: SvgPicture.asset('assets/icons/search1.svg',
                                                  color: rgboOrHex(Config
                                                          .get.styling[Config.get.themeMode].secondary)
                                                      .withOpacity(0.5)),
                                            ),
                                          ),
                                        ),
                                      ),
                                    ),
                                    Container(
                                      child: InkWell(
                                        onTap: ()async{
                                          FocusScopeNode currentFocus = FocusScope.of(context);

                                          if (!currentFocus.hasPrimaryFocus) {
                                            currentFocus.unfocus();
                                          }
                                          // Navigator.push(context,MaterialPageRoute(builder: (_)=>QRViewExample())).then((value) {
                                          //   print('barcode value');
                                          //   print(value);
                                          //   if(value !=null){
                                          //     Navigator.push(context,MaterialPageRoute(builder: (_)=>SearchScreen(code: value,)));
                                          //   }
                                          //   return null;
                                          // });
                                        },
                                        child: SizedBox(
                                          width: MediaQuery.of(context).size.height * (5.72 / 100),
                                          height: MediaQuery.of(context).size.height * (5.72 / 100),
                                          child: Padding(
                                            padding: EdgeInsets.all(15.0),
                                            child: SvgPicture.asset(
                                              'assets/icons/scan1.svg',
                                              color: rgboOrHex(Config.get.styling[Config.get.themeMode].primary),
                                            ),
                                          ),
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
          ],
          body:  Stack(
            alignment: Alignment.topCenter,
            children: [
              Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      Container(
                        width: double.infinity,
                        color: rgboOrHex(Config.get.styling[Config.get.themeMode].primary),
                        child: Row(
                          children: [
                            SizedBox(
                              width: MediaQuery.of(context).size.height * (4.26 / 100),
                            ),
                            Expanded(
                              child: TabBar(
                                isScrollable: true,
                                indicatorColor: Colors.white,
                                tabs: [
                                  Tab(
                                    child: Text(
                                      tr(LocalKeys.assigned_and_approved),
                                      style: TextStyle(
                                        fontSize: 12,
                                        fontWeight: FontWeight.w500,
                                      ),
                                    ),
                                  ),
                                  Tab(
                                    child: Text(
                                      tr(LocalKeys.received_status),
                                      style: TextStyle(
                                        fontSize: 12,
                                        fontWeight: FontWeight.w500,
                                      ),
                                    ),
                                  ),
                                  Tab(
                                    child: Text(
                                      tr(LocalKeys.done),
                                      style: TextStyle(
                                        fontSize: 12,
                                        fontWeight: FontWeight.w500,
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                  Expanded(
                    child: Container(
                      color: Color(0xffF7F7FB),
                      child: TabBarView(
                        physics: NeverScrollableScrollPhysics(),
                        children: [
                          buildMissions(),
                          buildReceivedMissions(),
                          buildDoneMissions(),
                        ],
                      ),
                    ),
                  ),
                ],
              ),

            ],
          ),
        ),
      ),
    );
  }


  Widget buildMissions() {
    return BlocBuilder<HomeBloc,HomeStates>(
      builder: (context, state) {
        return ConditionalBuilder(
        condition: state is !LoadingHomeState,
          builder:(context) =>  SmartRefresher(
            controller: _refreshController,
            enablePullDown: true,
            enablePullUp: false,
            onRefresh: (){
              BlocProvider.of<HomeBloc>(context).add(FetchHomeEvent(forFirstTime: false));
              _refreshController.loadComplete();
            },

            child: ConditionalBuilder(
              condition: BlocProvider.of<HomeBloc>(context).currentMissions.length>0,
              builder: (context) => ReorderableListView.builder(
                onReorder: (int oldIndex, int newIndex) {
                  setState(() {
                    if (oldIndex < newIndex) {
                      newIndex -= 1;
                    }
                    final MissionModel item = BlocProvider.of<HomeBloc>(context).currentMissions.removeAt(oldIndex);
                    BlocProvider.of<HomeBloc>(context).currentMissions.insert(newIndex, item);
                    BlocProvider.of<HomeBloc>(context).add(HomePageListChangedEvent());
                  });
                },
                shrinkWrap: true,
                physics: NeverScrollableScrollPhysics(),
                itemCount: BlocProvider.of<HomeBloc>(context).currentMissions.length,
                itemBuilder: (BuildContext context, int index) {
                  return Card(
                    key: Key('$index'),
                    elevation: 10,
                    shadowColor: Color(0xffF7F7FB),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(15),
                    ),
                    margin: EdgeInsets.symmetric(
                      horizontal: MediaQuery.of(context).size.width * (4.2 / 100),
                      vertical: MediaQuery.of(context).size.height * (2.4 / 100),
                    ),
                    clipBehavior:Clip.antiAlias ,
                    child: InkWell(
                      onTap: (){
                        Navigator.push(context,MaterialPageRoute(builder: (_)=>MissionShipmentsScreen(BlocProvider.of<HomeBloc>(context).currentMissions[index].id))).then((value) {
                          BlocProvider.of<HomeBloc>(context).add(FetchHomeEvent(forFirstTime: false));
                          return null;
                        });
                      },
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            children: [
                              SizedBox(
                                width: MediaQuery.of(context).size.width * (4.2 / 100),
                              ),
                              Expanded(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    SizedBox(
                                      height: MediaQuery.of(context).size.width * (4.2 / 100),
                                    ),
                                    Text(
                                      BlocProvider.of<HomeBloc>(context).currentMissions[index]?.code??'',
                                      style: TextStyle(
                                        color: rgboOrHex(
                                                Config.get.styling[Config.get.themeMode].primary),
                                        fontSize: 16,
                                        fontWeight: FontWeight.w500,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                              Container(
                                decoration: BoxDecoration(
                                  color: Colors.redAccent,
                                  borderRadius: BorderRadius.only(
                                          topRight: Radius.circular(15.0), bottomLeft: Radius.circular(15.0)),
                                ),
                                padding: EdgeInsets.symmetric(
                                  horizontal: MediaQuery.of(context).size.width * (5.0 / 100),
                                  vertical: MediaQuery.of(context).size.width * (2.0 / 100),
                                ),
                                child: Text(
                                  BlocProvider.of<HomeBloc>(context).currentMissions[index]?.type??'',
                                  style: TextStyle(
                                    color: Colors.white,
                                  ),
                                ),
                              ),
                            ],
                          ),
                          if(BlocProvider.of<HomeBloc>(context).currentMissions[index].address.isNotEmpty)
                          SizedBox(
                            height: (MediaQuery.of(context).size.height * (2.2 / 100)) / 3,
                          ),
                          if(BlocProvider.of<HomeBloc>(context).currentMissions[index].address.isNotEmpty)
                          Container(
                            padding: EdgeInsets.symmetric(
                              horizontal: MediaQuery.of(context).size.width * (5.0 / 100),
                              vertical: MediaQuery.of(context).size.width * (2.0 / 100),
                            ),
                            child: Text(
                              BlocProvider.of<HomeBloc>(context).currentMissions[index]?.address??'',
                            ),
                          ),
                          if(BlocProvider.of<HomeBloc>(context).currentMissions[index]?.type == AppKeys.TRANSFER_Key &&BlocProvider.of<HomeBloc>(context).currentMissions[index].to_branch_id.isNotEmpty && BlocProvider.of<HomeBloc>(context).branches.isNotEmpty)
                          SizedBox(
                            height: (MediaQuery.of(context).size.height * (2.2 / 100)) / 3,
                          ),
                          if(BlocProvider.of<HomeBloc>(context).currentMissions[index]?.type == AppKeys.TRANSFER_Key &&BlocProvider.of<HomeBloc>(context).currentMissions[index].to_branch_id.isNotEmpty && BlocProvider.of<HomeBloc>(context).branches.isNotEmpty)
                          Container(
                            padding: EdgeInsets.symmetric(
                              horizontal: MediaQuery.of(context).size.width * (5.0 / 100),
                              vertical: MediaQuery.of(context).size.width * (2.0 / 100),
                            ),
                            child: Text(
                              tr(LocalKeys.branch)+': '+  BlocProvider.of<HomeBloc>(context).branches.firstWhere((element) {
                                return element.id == BlocProvider.of<HomeBloc>(context).currentMissions[index].to_branch_id;
                              }).name,
                              style: TextStyle(
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                          ),
                          if(BlocProvider.of<HomeBloc>(context).currentMissions[index].amount.isNotEmpty)
                            SizedBox(
                              height: (MediaQuery.of(context).size.height * (1.2 / 100)) / 3,
                            ),
                          if(BlocProvider.of<HomeBloc>(context).currentMissions[index].amount.isNotEmpty)
                          Container(
                            width: double.infinity,
                            padding: EdgeInsets.symmetric(
                              horizontal: MediaQuery.of(context).size.width * (5.0 / 100),
                              vertical: MediaQuery.of(context).size.width * (3.0 / 100),
                            ),
                            decoration: BoxDecoration(
                              color: rgboOrHex(Config.get
                                      .styling[Config.get.themeMode].primary)
                                      .withOpacity(0.8),
                              borderRadius: BorderRadius.only(
                                      bottomRight: Radius.circular(15.0),
                                      bottomLeft: Radius.circular(15.0)),
                            ),
                            child: Text(
                              (BlocProvider.of<HomeBloc>(context).currentMissions[index]?.amount??'')+' '+(BlocProvider.of<HomeBloc>(context).currencyModel?.symbol??''),
                              textAlign: TextAlign.center,
                              style: TextStyle(
                                      color: rgboOrHex(Config.get
                                              .styling[Config.get.themeMode].buttonTextColor),
                                fontSize: 18,
                                fontWeight: FontWeight.bold
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  );
                },
              ),
              fallback: (context) => SingleChildScrollView(
                child: Column(
                  children: [
                    EmptyContent(
                      svgIconPath: 'assets/icons/empty.svg',
                      message: tr(LocalKeys.noDataFound),
                      hasEmptyHeight: true,

                    ),
                  ],
                ),
              ),
            ),
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
      );
      },
    );
  }

  Widget buildReceivedMissions() {
    return BlocBuilder<HomeBloc,HomeStates>(
      builder: (context, state) {
        return ConditionalBuilder(
          condition: state is !LoadingHomeState,
          builder:(context) =>  SmartRefresher(
            controller: _refreshController2,
            enablePullDown: true,
            enablePullUp: false,
            onRefresh: (){
              BlocProvider.of<HomeBloc>(context).add(FetchHomeEvent(forFirstTime: false));
              _refreshController2.loadComplete();
            },

            child: ConditionalBuilder(
              condition: BlocProvider.of<HomeBloc>(context).receivedMissions.length>0,
              builder: (context) => ListView.builder(
                shrinkWrap: true,
                physics: NeverScrollableScrollPhysics(),
                itemCount: BlocProvider.of<HomeBloc>(context).receivedMissions.length,
                itemBuilder: (BuildContext context, int index) {
                  return Column(
                    children: [
                      if(index ==0)
                        SizedBox(
                          height: MediaQuery.of(context).size.height * (2 / 100),
                        ),
                      Card(
                        elevation: 10,
                        shadowColor: Color(0xffF7F7FB),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(15),
                        ),
                        margin: EdgeInsets.symmetric(
                                horizontal: MediaQuery.of(context).size.width * (4.2 / 100),
                                vertical: MediaQuery.of(context).size.height * (2.4 / 100)),
                        clipBehavior:Clip.antiAlias ,
                        child: InkWell(
                          onTap: (){
                            Navigator.push(context,MaterialPageRoute(builder: (_)=>MissionShipmentsScreen(BlocProvider.of<HomeBloc>(context).receivedMissions[index].id)));
                          },
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Row(
                                children: [
                                  SizedBox(
                                    width: MediaQuery.of(context).size.width * (4.2 / 100),
                                  ),
                                  Expanded(
                                    child: Column(
                                      crossAxisAlignment: CrossAxisAlignment.start,
                                      children: [
                                        SizedBox(
                                          height: MediaQuery.of(context).size.width * (4.2 / 100),
                                        ),
                                        Text(
                                          BlocProvider.of<HomeBloc>(context).receivedMissions[index].code,
                                          style: TextStyle(
                                            color: rgboOrHex(
                                                    Config.get.styling[Config.get.themeMode].primary),
                                            fontSize: 16,
                                            fontWeight: FontWeight.w500,
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                  Container(
                                    decoration: BoxDecoration(
                                      color: Colors.redAccent,
                                      borderRadius: BorderRadius.only(
                                              topRight: Radius.circular(15.0), bottomLeft: Radius.circular(15.0)),
                                    ),
                                    padding: EdgeInsets.symmetric(
                                      horizontal: MediaQuery.of(context).size.width * (5.0 / 100),
                                      vertical: MediaQuery.of(context).size.width * (2.0 / 100),
                                    ),
                                    child: Text(
                                      BlocProvider.of<HomeBloc>(context).receivedMissions[index].type,
                                      style: TextStyle(
                                        color: Colors.white,
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                              if(BlocProvider.of<HomeBloc>(context).receivedMissions[index].address.isNotEmpty)
                              SizedBox(
                                height: (MediaQuery.of(context).size.height * (2.2 / 100)) / 3,
                              ),
                              if(BlocProvider.of<HomeBloc>(context).receivedMissions[index].address.isNotEmpty)
                                Container(
                                padding: EdgeInsets.symmetric(
                                  horizontal: MediaQuery.of(context).size.width * (5.0 / 100),
                                  vertical: MediaQuery.of(context).size.width * (2.0 / 100),
                                ),
                                child: Text(
                                  BlocProvider.of<HomeBloc>(context).receivedMissions[index]?.address??'',
                                ),
                              ),
                              if(BlocProvider.of<HomeBloc>(context).receivedMissions[index].amount.isNotEmpty)
                                SizedBox(
                                  height: (MediaQuery.of(context).size.height * (4.2 / 100)) / 3,
                                ),
                              if(BlocProvider.of<HomeBloc>(context).receivedMissions[index].amount.isNotEmpty)
                                Container(
                                  width: double.infinity,
                                  padding: EdgeInsets.symmetric(
                                    horizontal: MediaQuery.of(context).size.width * (5.0 / 100),
                                    vertical: MediaQuery.of(context).size.width * (3.0 / 100),
                                  ),
                                  decoration: BoxDecoration(
                                    color: rgboOrHex(Config.get
                                            .styling[Config.get.themeMode].primary)
                                            .withOpacity(0.8),
                                    borderRadius: BorderRadius.only(
                                            bottomRight: Radius.circular(15.0),
                                            bottomLeft: Radius.circular(15.0)),
                                  ),
                                  child: Text(
                                    (BlocProvider.of<HomeBloc>(context).receivedMissions[index]?.amount??'')+' '+(BlocProvider.of<HomeBloc>(context).currencyModel?.symbol??''),
                                    textAlign: TextAlign.center,
                                    style: TextStyle(
                                            color: rgboOrHex(Config.get
                                                    .styling[Config.get.themeMode].buttonTextColor),
                                            fontSize: 18,
                                            fontWeight: FontWeight.bold
                                    ),
                                  ),
                                ),
                            ],
                          ),
                        ),
                      ),
                    ],
                  );
                },
              ),
              fallback: (context) => SingleChildScrollView(
                child: Column(
                  children: [
                    EmptyContent(
                      svgIconPath: 'assets/icons/empty.svg',
                      message: tr(LocalKeys.noDataFound),
                      hasEmptyHeight: true,

                    ),
                  ],
                ),
              ),
            ),
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
        );
      },
    );
  }
  Widget buildDoneMissions() {
    return BlocBuilder<HomeBloc,HomeStates>(
      builder: (context, state) {
        return ConditionalBuilder(
          condition: state is !LoadingHomeState,
          builder:(context) =>  SmartRefresher(
            controller: _refreshController3,
            enablePullDown: true,
            enablePullUp: false,
            onRefresh: (){
              BlocProvider.of<HomeBloc>(context).add(FetchHomeEvent(forFirstTime: false));
              _refreshController3.loadComplete();
            },

            child: SingleChildScrollView(
              child: Column(
                children: [
                  ConditionalBuilder(
                    condition: BlocProvider.of<HomeBloc>(context).doneMissions.length>0,
                    builder: (context) =>   ListView.builder(
                      shrinkWrap: true,
                      physics: NeverScrollableScrollPhysics(),
                      itemCount: BlocProvider.of<HomeBloc>(context).doneMissions.length,
                      itemBuilder: (BuildContext context, int index) {
                        return Column(
                          children: [
                            if(index ==0)
                              SizedBox(
                                height: MediaQuery.of(context).size.height * (2 / 100),
                              ),
                            Card(
                              elevation: 10,
                              shadowColor: Color(0xffF7F7FB),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(15),
                              ),
                              margin: EdgeInsets.symmetric(
                                      horizontal: MediaQuery.of(context).size.width * (4.2 / 100),
                                      vertical: MediaQuery.of(context).size.height * (2.4 / 100)),
                              clipBehavior:Clip.antiAlias ,
                              child: InkWell(
                                onTap: (){
                                  Navigator.push(context,MaterialPageRoute(builder: (_)=>MissionShipmentsScreen(BlocProvider.of<HomeBloc>(context).doneMissions[index].id,)));
                                },
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Row(
                                      children: [
                                        SizedBox(
                                          width: MediaQuery.of(context).size.width * (4.2 / 100),
                                        ),
                                        Expanded(
                                          child: Column(
                                            crossAxisAlignment: CrossAxisAlignment.start,
                                            children: [
                                              SizedBox(
                                                height: MediaQuery.of(context).size.width * (4.2 / 100),
                                              ),
                                              Text(
                                                BlocProvider.of<HomeBloc>(context).doneMissions[index].code,
                                                style: TextStyle(
                                                  color: rgboOrHex(
                                                          Config.get.styling[Config.get.themeMode].primary),
                                                  fontSize: 16,
                                                  fontWeight: FontWeight.w500,
                                                ),
                                              ),
                                            ],
                                          ),
                                        ),
                                        Container(
                                          decoration: BoxDecoration(
                                            color: Colors.redAccent,
                                            borderRadius: BorderRadius.only(
                                                    topRight: Radius.circular(15.0), bottomLeft: Radius.circular(15.0)),
                                          ),
                                          padding: EdgeInsets.symmetric(
                                            horizontal: MediaQuery.of(context).size.width * (5.0 / 100),
                                            vertical: MediaQuery.of(context).size.width * (2.0 / 100),
                                          ),
                                          child: Text(
                                            BlocProvider.of<HomeBloc>(context).doneMissions[index].type,
                                            style: TextStyle(
                                              color: Colors.white,
                                            ),
                                          ),
                                        ),
                                      ],
                                    ),
                                    if(BlocProvider.of<HomeBloc>(context).doneMissions[index].address.isNotEmpty)
                                    SizedBox(
                                      height: (MediaQuery.of(context).size.height * (2.2 / 100)) / 3,
                                    ),
                                    if(BlocProvider.of<HomeBloc>(context).doneMissions[index].address.isNotEmpty)
                                      Container(
                                      padding: EdgeInsets.symmetric(
                                        horizontal: MediaQuery.of(context).size.width * (5.0 / 100),
                                        vertical: MediaQuery.of(context).size.width * (2.0 / 100),
                                      ),
                                      child: Text(
                                        BlocProvider.of<HomeBloc>(context).doneMissions[index].address,
                                      ),
                                    ),
                                    if(BlocProvider.of<HomeBloc>(context).doneMissions[index].amount.isNotEmpty)
                                      SizedBox(
                                        height: (MediaQuery.of(context).size.height * (1.2 / 100)) / 3,
                                      ),
                                    if(BlocProvider.of<HomeBloc>(context).doneMissions[index].amount.isNotEmpty)
                                      Container(
                                        width: double.infinity,
                                        padding: EdgeInsets.symmetric(
                                          horizontal: MediaQuery.of(context).size.width * (5.0 / 100),
                                          vertical: MediaQuery.of(context).size.width * (3.0 / 100),
                                        ),
                                        decoration: BoxDecoration(
                                          color: rgboOrHex(Config.get
                                                  .styling[Config.get.themeMode].primary)
                                                  .withOpacity(0.8),
                                          borderRadius: BorderRadius.only(
                                                  bottomRight: Radius.circular(15.0),
                                                  bottomLeft: Radius.circular(15.0)),
                                        ),
                                        child: Text(
                                          (BlocProvider.of<HomeBloc>(context).doneMissions[index]?.amount??'')+' '+(BlocProvider.of<HomeBloc>(context).currencyModel?.symbol??''),
                                          textAlign: TextAlign.center,
                                          style: TextStyle(
                                                  color: rgboOrHex(Config.get
                                                          .styling[Config.get.themeMode].buttonTextColor),
                                                  fontSize: 18,
                                                  fontWeight: FontWeight.bold
                                          ),
                                        ),
                                      ),
                                  ],
                                ),
                              ),
                            ),
                          ],
                        );
                      },
                    ),
                    fallback: (context) => EmptyContent(
                      svgIconPath: 'assets/icons/empty.svg',
                      message: tr(LocalKeys.noDataFound),
                      hasEmptyHeight: true,

                    ),
                  ),
                ],
              ),
            ),
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
        );
      },
    );
  }

}
