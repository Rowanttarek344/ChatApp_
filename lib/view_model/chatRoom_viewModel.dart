import 'package:chat_app/Navigators/chatRoomNavigator.dart';
import 'package:chat_app/database/database_utils.dart';
import 'package:chat_app/model/message.dart';
import 'package:chat_app/model/my_user.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

import '../model/room.dart';

class chatRoom_viewModel extends ChangeNotifier {
  late chatRoomNavigator navigator;
  late Room room;
  late MyUser currentUser;
  late Stream<QuerySnapshot<Message>> streamMessage;

  void sendMessage(String content) async {
    Message message = Message(
        roomId: room.roomId,
        content: content,
        senderId: currentUser.id,
        senderName: currentUser.firstName,
        dateTime: DateTime.now().millisecondsSinceEpoch);
    try{
      var res= await DatabaseUtils.insertMessage(message);
      navigator.clearMessage();
      print('message sent successfully!');

    }
    catch(error){
      navigator.showMessage(error.toString());
    }

  }

  void listenForUpdateMessages(){
    streamMessage=DatabaseUtils.getMessages(room.roomId);
  }

  void addRoomParticipant(){
    if(!room.participants.contains(currentUser.id)){
      room.participants?.add(currentUser.id);
      DatabaseUtils.addRoomParticipant(room,room.participants);
    }
    else{
      print("you are already joined this room");
    }
  }

  void removeRoomParticipant(){
    if(room.participants.contains(currentUser.id)){
      room.participants?.remove(currentUser.id);
      DatabaseUtils.removeRoomParticipant(room, room.participants);
    }

  }

}
