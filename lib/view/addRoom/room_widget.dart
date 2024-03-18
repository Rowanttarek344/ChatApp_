import 'package:chat_app/provider/push_notification_provider.dart';
import 'package:chat_app/view/chatRoom_Screen.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../model/room.dart';

class room_widget extends StatelessWidget {
  Room room;
  room_widget({required this.room});

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () {
        Navigator.of(context).pushNamed(chatRoomScreen.routeName,arguments: room);
      },
      child: Container(
        width: 150,
        height: 150,
        padding: EdgeInsets.all(10),
        margin: EdgeInsets.all(15),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(20),
          color: Colors.white,
          boxShadow: [
            BoxShadow(
              color: Colors.grey.withOpacity(0.5),
              spreadRadius: 3,
              blurRadius: 7,
              offset: Offset(0, 3), // Shadow position
            ),
          ],
        ),
        child: Column(
          children: [
            Image.asset(
              'assets/images/${room.categoryId}.png',
              height: MediaQuery.of(context).size.height * 0.14,
            ),
            Text(room.title,style: TextStyle(fontWeight: FontWeight.bold,fontSize: 18),)
          ],
        ),
      ),
    );
  }
}
