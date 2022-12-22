import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:wepostexpress/ui/login/bloc/login_events.dart';
import 'package:wepostexpress/ui/login/bloc/login_states.dart';
import 'package:wepostexpress/ui/splash/bloc/splash_events.dart';
import 'package:wepostexpress/ui/splash/bloc/splash_states.dart';
import 'package:wepostexpress/utils/constants/constants.dart';
import 'package:wepostexpress/utils/network/repository.dart';
import 'package:wepostexpress/utils/di/di.dart';

import '../../../utils/cache/cache_helper.dart';
import '../../../utils/constants/app_keys.dart';

class LoginBloc extends Bloc<LoginEvents, LoginStates> {
  final Repository _repository;
  bool showPassword = false;

  LoginBloc(this._repository) : super(InitialLoginState());

  static LoginBloc get(BuildContext context) => BlocProvider.of(context);

  @override
  Stream<LoginStates> mapEventToState(LoginEvents event) async* {
    if (event is FetchLoginEvent) {
      yield SuccessLoginState();
    }

    if (event is PasswordToggleChangedLoginEvent) {
      yield PasswordToggleChangedLoginState();
    }

    if (event is SubmitLoginEvent) {
      yield LoadingLoginState();
      final authResponse = await _repository.login(
        email: event.email,
        password: event.password,
      );

      yield* authResponse.fold((l) async* {
        print('dddddddd');
        print(l);
        yield ErrorLoginState(l, false);
      }, (r) async* {
        _repository.user = r;
        print('r.type');
        print(r.type);
        if (r.error != null && (r.type == null || r.type == 'null')) {
          print('dasdasdasdasd');
          yield ErrorLoginState(r.error, false);
        } else {
          if (r.type == 5) {
            yield ErrorLoginState(r.error, true);
          } else {
            await di<CacheHelper>().put(AppKeys.userData, r);
            print('UserLogin Token');
            print(r.api_token);
            yield LoggedInSuccessfully();
          }
        }
      });
    }
  }
}
