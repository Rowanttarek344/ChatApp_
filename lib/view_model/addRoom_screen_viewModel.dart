import 'package:chat_app/Navigators/AddRoomNavigator.dart';
import 'package:chat_app/database/database_utils.dart';
import 'package:flutter/material.dart';

import '../model/room.dart';

class AddRoomScreen_viewModel extends ChangeNotifier {
  late AddRoomNavigator navigator;

  void addRoom(String title, String description, String categoryId) async {
    Room room = Room(
        roomId: '',
        title: title,
        description: description,
        categoryId: categoryId,
        participants: []
    );

    try {
      navigator.showLoading();
      var createdRoom = DatabaseUtils.addRoom(room);
      print('room added successfully!');
      navigator.hideLoading();
      navigator.showMessage('Room added successfully!');
      navigator.navigateToHome();
    } catch (e) {
      navigator.hideLoading();
      navigator.showMessage(e.toString());
    }
  }
}
