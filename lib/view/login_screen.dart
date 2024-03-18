import 'dart:async';

import 'package:chat_app/Navigators/AuthNavigator.dart';
import 'package:chat_app/firebase_errors.dart';
import 'package:chat_app/model/my_user.dart';
import 'package:chat_app/provider/user_provider.dart';
import 'package:chat_app/view/home_screen.dart';
import 'package:chat_app/view/register_screen.dart';
import 'package:chat_app/view_model/login_screen_viewModel.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:chat_app/utils.dart' as utils;

class LoginScreen extends StatefulWidget {
  static const String routeName = 'login-screen';

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> implements AuthNavigator {
  String email = '';

  String password = '';

  var formKey = GlobalKey<FormState>();
  LoginScreen_viewModel viewModel = LoginScreen_viewModel();

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    viewModel.navigator = this;
  }

  @override
  void hideLoading() {
    utils.hideLoading(context);
  }

  @override
  void showLoading() {
    utils.showLoading(context);
  }

  @override
  void showMessage(String message) {
    utils.showMessage(context, message, 'ok', posAction);
  }

  void posAction(BuildContext context) {
    Navigator.pop(context);
  }

  @override
  void navigateToHome(MyUser user) {
    var provider=Provider.of<UserProvider>(context,listen: false);
    provider.user=user;
    Timer(Duration(seconds: 2),
        () => Navigator.of(context).pushNamed(HomeScreen.routeName));
  }

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (BuildContext context) => viewModel,
      child: Stack(
        children: [
          Container(
            color: Colors.white,
          ),
          Image.asset(
            'assets/images/main_bg.png',
            fit: BoxFit.fill,
            width: double.infinity,
          ),
          Scaffold(
            resizeToAvoidBottomInset: false,
            backgroundColor: Colors.transparent,
            appBar: AppBar(
              backgroundColor: Colors.transparent,
              elevation: 0,
              title: Text(
                'Login',
                style: TextStyle(fontWeight: FontWeight.bold, fontSize: 22),
              ),
              centerTitle: true,
            ),
            body: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Form(
                      key: formKey,
                      child: Column(
                        children: [
                          TextFormField(
                            validator: (value) {
                              final bool emailValid = RegExp(
                                      r"^[a-zA-Z0-9.a-zA-Z0-9.!#$%&'*+-/=?^_`{|}~]+@[a-zA-Z0-9]+\.[a-zA-Z]+")
                                  .hasMatch(value!);

                              if (value == null || value.trim().isEmpty) {
                                return 'please enter your email';
                              } else if (!emailValid) {
                                return 'please enter valid email';
                              } else {
                                return null;
                              }
                            },
                            onChanged: (value) {
                              email = value;
                            },
                            decoration: InputDecoration(
                              hintText: 'enter your email',
                            ),
                          ),
                          TextFormField(
                            validator: (value) {
                              if (value == null || value.trim().isEmpty) {
                                return 'please enter your password';
                              } else if (value.length < 6) {
                                return 'your password must be at least 6 characters';
                              } else {
                                return null;
                              }
                            },
                            onChanged: (value) {
                              password = value;
                            },
                            decoration: InputDecoration(
                              hintText: 'enter your password',
                            ),
                          ),
                        ],
                      )),
                  SizedBox(
                    height: 16,
                  ),
                  ElevatedButton(onPressed: validateForm, child: Text('Login')),
                  TextButton(
                      onPressed: () {
                        Navigator.of(context)
                            .pushNamed(RegisterScreen.routeName);
                      },
                      child: Text('or Create My Account'))
                ],
              ),
            ),
          )
        ],
      ),
    );
  }

  void validateForm() async {
    if (formKey.currentState?.validate() == true) {
      //sign in
      viewModel.loginFirebaseAuth(email, password);
    }
  }
}
