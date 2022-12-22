import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:wepostexpress/components/main_button.dart';
import 'package:wepostexpress/components/my_svg.dart';
import 'package:wepostexpress/ui/config_loader/bloc/config_loader_bloc.dart';
import 'package:wepostexpress/ui/config_loader/config_loader_screen.dart';
import 'package:wepostexpress/ui/home/home_screen.dart';
import 'package:wepostexpress/ui/login/bloc/login_bloc.dart';
import 'package:wepostexpress/ui/login/bloc/login_events.dart';
import 'package:wepostexpress/ui/login/bloc/login_states.dart';
import 'package:wepostexpress/utils/config/config.dart';
import 'package:wepostexpress/utils/constants/constants.dart';
import 'package:wepostexpress/utils/constants/local_keys.dart';
import 'package:wepostexpress/utils/di/di.dart';

class LoginScreen extends StatelessWidget {
  final formKey = GlobalKey<FormState>();
  TextEditingController emailController = TextEditingController();
  TextEditingController passwordController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    emailController.text='driver@driver.com';
    passwordController.text='123456';
    return BlocProvider<LoginBloc>(
      create: (BuildContext context) => di<LoginBloc>()..add(FetchLoginEvent()),
      child: BlocListener<LoginBloc, LoginStates>(
        listener: (BuildContext context, LoginStates state) async {
          if (state is ErrorLoginState) {
            if(state.isNotCaptain){
              showToast(tr(LocalKeys.yourAccountIsNotADriver), false);
            }else{
              showToast(state.error, false);
            }
          }
          if (state is LoggedInSuccessfully) {
              Navigator.pushReplacement(context,MaterialPageRoute(builder: (_)=>HomeScreen()));
          }
        },
        child: Scaffold(
          body: SafeArea(
            child: Builder(
              builder: (context) => SizedBox.expand(
                child: Stack(
                  children: [
                    Column(
                      children: [
                        Spacer(),
                        Container(
                          height: MediaQuery.of(context).size.height * (19 / 100),
                          width: double.infinity,
                          child: Stack(
                            children: [
                              Image.asset(
                                'assets/icons/login_bg.png',
                                width: double.infinity,
                                fit: BoxFit.cover,
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                    SingleChildScrollView(
                      child: Column(
                        children: <Widget>[
                          Form(
                            key: formKey,
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                SizedBox(
                                  height: MediaQuery.of(context).size.height * (6.4 / 100),
                                ),
                                Align(
                                    alignment: Alignment.center,
                                    child: Image.asset(
                                      // size: MediaQuery.of(context).size.height * (11 / 100),
                                      'assets/images/logo_remove.png',
                                    ),
                                ),
                                SizedBox(
                                  height: MediaQuery.of(context).size.height * (8.9 / 100),
                                ),
                                Padding(
                                  padding: EdgeInsets.symmetric(
                                      horizontal: MediaQuery.of(context).size.width * (6.4 / 100)),
                                  child: Text(
                                    tr(LocalKeys.email),
                                    style: TextStyle(
                                      color: Colors.grey,
                                      fontWeight: FontWeight.w600,
                                      fontSize: 13,
                                    ),
                                  ),
                                ),
                                Padding(
                                  padding: EdgeInsets.symmetric(
                                      horizontal: MediaQuery.of(context).size.width * (6.4 / 100)),
                                  child: TextFormField(
                                    validator: (v) {
                                      if (v == null || v.isEmpty) {
                                        return tr(LocalKeys.this_field_cant_be_empty);
                                      } else {
                                        return null;
                                      }
                                    },
                                    controller: emailController,
                                    decoration: InputDecoration(
                                      hintText: tr(LocalKeys.email),
                                      hintStyle: TextStyle(fontSize: 11),
                                      focusedBorder: UnderlineInputBorder(
                                          borderRadius: BorderRadius.all(Radius.circular(0.0)),
                                          borderSide: BorderSide(color: Colors.black, width: 2)),
                                    ),
                                  ),
                                ),
                                SizedBox(
                                  height: MediaQuery.of(context).size.height * (3.9 / 100),
                                ),
                                Padding(
                                  padding: EdgeInsets.symmetric(
                                      horizontal: MediaQuery.of(context).size.width * (6.4 / 100)),
                                  child: Text(
                                    tr(LocalKeys.password),
                                    style: TextStyle(
                                      color: Colors.grey,
                                      fontWeight: FontWeight.w600,
                                      fontSize: 13,
                                    ),
                                  ),
                                ),
                                BlocBuilder<LoginBloc, LoginStates>(
                                  builder: (context, state) => Padding(
                                    padding: EdgeInsets.symmetric(
                                        horizontal: MediaQuery.of(context).size.width * (6.4 / 100)),
                                    child: TextFormField(
                                      validator: (v) {
                                        if (v == null || v.isEmpty) {
                                          return tr(LocalKeys.this_field_cant_be_empty);
                                        } else {
                                          return null;
                                        }
                                      },
                                        keyboardType: TextInputType.visiblePassword,
                                      obscureText: !BlocProvider.of<LoginBloc>(context).showPassword,
                                        controller: passwordController,
                                      decoration: InputDecoration(
                                        hintText: tr(LocalKeys.password),
                                        hintStyle: TextStyle(fontSize: 11),
                                        suffixIcon: IconButton(
                                          onPressed: () {
                                            BlocProvider.of<LoginBloc>(context).showPassword = !BlocProvider.of<LoginBloc>(context).showPassword;
                                            BlocProvider.of<LoginBloc>(context).add(PasswordToggleChangedLoginEvent());
                                          },
                                          icon: Icon(
                                            Icons.remove_red_eye,
                                            color: BlocProvider.of<LoginBloc>(context).showPassword  ? Colors.blue : Colors.grey,
                                          ),
                                        ),
                                        focusedBorder: UnderlineInputBorder(
                                            borderRadius: BorderRadius.all(Radius.circular(0.0)),
                                            borderSide: BorderSide(color: Colors.black, width: 2)),
                                      ),
                                    ),
                                  ),
                                ),
                                SizedBox(
                                  height: MediaQuery.of(context).size.height * (8.1 / 100),
                                ),
                                BlocBuilder<LoginBloc, LoginStates>(
                                  builder: (context, state) => Padding(
                                    padding: EdgeInsets.symmetric(
                                        horizontal: MediaQuery.of(context).size.width * (6.4 / 100)),
                                    child: MainButton(
                                        isLoading: state is LoadingLoginState,
                                      borderColor: rgboOrHex(
                                          Config.get.styling[Config.get.themeMode].secondaryVariant),
                                      borderRadius: 0,
                                      onPressed: () {
                                        formKey.currentState.save();
                                        if (formKey.currentState.validate()) {
                                          BlocProvider.of<LoginBloc>(context).add(
                                            SubmitLoginEvent(
                                              email: emailController.text,
                                              password: passwordController.text,
                                            ),
                                          );
                                        }
                                      },
                                      text: tr(LocalKeys.login),
                                      textColor: rgboOrHex(
                                          Config.get.styling[Config.get.themeMode].buttonTextColor),
                                      color: rgboOrHex(Config
                                          .get.styling[Config.get.themeMode].primary),
                                    ),
                                  ),
                                ),
                                SizedBox(
                                  height: MediaQuery.of(context).size.height * (6.4 / 100),
                                ),
                              ],
                            ),
                          ),

                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
