import 'dart:async';

import 'package:chat_app/Navigators/AuthNavigator.dart';
import 'package:chat_app/firebase_errors.dart';
import 'package:chat_app/model/my_user.dart';
import 'package:chat_app/view_model/register_screen_viewModel.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:chat_app/utils.dart' as utils;

import '../provider/user_provider.dart';
import 'home_screen.dart';


class RegisterScreen extends StatefulWidget {
  static const String routeName = 'register-screen';

  @override
  State<RegisterScreen> createState() => _RegisterScreenState();
}

class _RegisterScreenState extends State<RegisterScreen> implements AuthNavigator {
  String first_name = '';

  String last_name = '';

  String email = '';

  String password = '';

  var formKey = GlobalKey<FormState>();

  RegisterScreen_viewModel viewModel = RegisterScreen_viewModel();

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    viewModel.navigator=this;
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
  void posAction(BuildContext context){
    Navigator.pop(context);
  }

  @override
  void navigateToHome(MyUser user){
    var provider=Provider.of<UserProvider>(context,listen: false);
    provider.user=user;
    Timer(Duration(seconds: 2),
            () => Navigator.of(context).pushNamed(HomeScreen.routeName));  }


  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (BuildContext context) => viewModel,
      child: Stack(
        children: [
          Container(
            color: Colors.white,
          ),
          Image.asset('assets/images/main_bg.png',
            fit: BoxFit.cover,
            width: double.infinity,
          ),

          Scaffold(
            backgroundColor: Colors.transparent,
            appBar: AppBar(
              backgroundColor: Colors.transparent,
              elevation: 0,
              title: Text(
                'Create Account',
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
                              if (value == null || value
                                  .trim()
                                  .isEmpty) {
                                return 'please enter your first name';
                              } else {
                                return null;
                              }
                            },
                            onChanged: (value) {
                              first_name = value;
                            },
                            decoration: InputDecoration(
                              hintText: 'enter your first name',
                            ),
                          ),
                          TextFormField(
                            validator: (value) {
                              if (value == null || value
                                  .trim()
                                  .isEmpty) {
                                return 'please enter your last name';
                              } else {
                                return null;
                              }
                            },
                            onChanged: (value) {
                              last_name = value;
                            },
                            decoration: InputDecoration(
                              hintText: 'enter your last name',
                            ),
                          ),
                          TextFormField(
                            validator: (value) {
                              final bool emailValid = RegExp(
                                  r"^[a-zA-Z0-9.a-zA-Z0-9.!#$%&'*+-/=?^_`{|}~]+@[a-zA-Z0-9]+\.[a-zA-Z]+")
                                  .hasMatch(value!);

                              if (value == null || value
                                  .trim()
                                  .isEmpty) {
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
                              if (value == null || value
                                  .trim()
                                  .isEmpty) {
                                return 'please enter your password';
                              } else if (value.length < 6) {
                                return 'your password must be at least 6 characters';
                              }
                              else {
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
                      )
                  ),
                  SizedBox(height: 16,),
                  ElevatedButton(onPressed: validateForm,
                      child: Text('Create Account'))
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
      //create account
      viewModel.registerFirebaseAuth(email, password,first_name,last_name);
    }
  }


}
