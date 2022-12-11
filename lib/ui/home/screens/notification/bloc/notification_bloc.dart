import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:wepostexpress/models/notification_model.dart';
import 'package:wepostexpress/models/shipment_model.dart';
import 'package:wepostexpress/ui/home/bloc/home_events.dart';
import 'package:wepostexpress/ui/home/bloc/home_states.dart';
import 'package:wepostexpress/ui/home/screens/notification/bloc/notification_states.dart';
import 'package:wepostexpress/ui/login/bloc/login_events.dart';
import 'package:wepostexpress/ui/login/bloc/login_states.dart';
import 'package:wepostexpress/ui/splash/bloc/splash_events.dart';
import 'package:wepostexpress/ui/splash/bloc/splash_states.dart';
import 'package:wepostexpress/utils/network/repository.dart';

import 'notification_events.dart';

class NotificationBloc extends Bloc<NotificationEvents, NotificationStates> {
  final Repository _repository;
  List<NotificationModel> notifications=[];


  NotificationBloc(this._repository) : super(InitialNotificationState());

  static NotificationBloc get(BuildContext context) => BlocProvider.of(context);

  @override
  Stream<NotificationStates> mapEventToState(NotificationEvents event) async*
  {
    if (event is FetchNotificationEvent) {
      yield LoadingNotificationState();

      final no =await  _repository.getNotifications();
      yield* no.fold((l) async*{
        yield ErrorNotificationState(l);
      }, (r) async*{
        print('notifications.length');
        print(notifications.length);
        notifications = r;
        yield SuccessNotificationState();
      });
    }
  }
}
