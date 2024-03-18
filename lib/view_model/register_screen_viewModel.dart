import 'package:chat_app/Navigators/AuthNavigator.dart';
import 'package:chat_app/database/database_utils.dart';
import 'package:chat_app/model/my_user.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:chat_app/firebase_errors.dart';

class RegisterScreen_viewModel extends ChangeNotifier {
  late AuthNavigator navigator;
  void registerFirebaseAuth(
      String email, String password, String firstName, String lastName) async {
    try {
      navigator.showLoading();
      final credential =
          await FirebaseAuth.instance.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );
      //save user in firebase firestore db
      var user = MyUser(
          id: credential.user?.uid ?? '',
          firstName: firstName,
          lastName: lastName,
          email: email,
          token: '');
      DatabaseUtils.registerUser(user);

      print('Registered successfully!');
      navigator.hideLoading();
      navigator.showMessage('Registered successfully!');
      navigator.navigateToHome(user);

    } on FirebaseAuthException catch (e) {
      if (e.code == firebase_errors.weak_password) {
        print('The password provided is too weak.');
        navigator.hideLoading();
        navigator.showMessage('The password provided is too weak.');
      } else if (e.code == firebase_errors.email_already_in_use) {
        print('The account already exists for that email.');
        navigator.hideLoading();
        navigator.showMessage('The account already exists for that email.');
      }
    } catch (e) {
      print(e);
      navigator.hideLoading();
      navigator.showMessage(e.toString());
    }
  }
}
