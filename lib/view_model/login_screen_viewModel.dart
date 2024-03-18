import 'package:chat_app/Navigators/AuthNavigator.dart';
import 'package:chat_app/database/database_utils.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:chat_app/firebase_errors.dart';

class LoginScreen_viewModel extends ChangeNotifier {
  late AuthNavigator navigator;

  void loginFirebaseAuth(String email, String password) async {
    try {
      navigator.showLoading();
      final credential = await FirebaseAuth.instance
          .signInWithEmailAndPassword(email: email, password: password);

      //retrive the user from firebase firestore db
      var user= await DatabaseUtils.getUser(credential.user?.uid??'');
      if(user==null){
        navigator.hideLoading();
        navigator.showMessage('Failed,please try again');
      }
      else{
        print('Login susccessfully!');
        navigator.hideLoading();
        navigator.showMessage('Login susccessfully!');
        navigator.navigateToHome(user);
      }


    } on FirebaseAuthException catch (e) {
      if (e.code == firebase_errors.user_not_found) {
        print('No user found for that email.');
        navigator.hideLoading();
        navigator.showMessage('No user found for that email.');
      } else if (e.code == firebase_errors.wrong_password) {
        print('Wrong password provided for that user.');
        navigator.hideLoading();
        navigator.showMessage('Wrong password provided for that user.');
      }
    }
  }
}
