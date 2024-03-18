import 'package:chat_app/provider/user_provider.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:intl/intl.dart';

import '../model/message.dart';

class messageWidget extends StatelessWidget {
  Message message;
  messageWidget({required this.message});

  @override
  Widget build(BuildContext context) {
    var provider = Provider.of<UserProvider>(context);
    return provider.user?.id == message.senderId
        ? sentMessage(message: message)
        : recievedMessage(message: message);
  }
}

class sentMessage extends StatelessWidget {
  Message message;
  sentMessage({required this.message});
  @override
  Widget build(BuildContext context) {
    DateTime dateTime = DateTime.fromMillisecondsSinceEpoch(message.dateTime);
    String formattedTime =DateFormat.jm().format(dateTime);
    return Column(
      crossAxisAlignment: CrossAxisAlignment.end,
      children: [
        Container(
          padding: EdgeInsets.all(12),
          decoration: BoxDecoration(
            color: Colors.blue,
            borderRadius: BorderRadius.only(
              bottomLeft: Radius.circular(30),
              topLeft: Radius.circular(30),
              topRight: Radius.circular(30)
            )
          ),
          child: Text(message.content,style: TextStyle(
            color: Colors.white,
            fontSize: 16
          ),),
        ),
        SizedBox(height: 5,),
        Container(
          padding: EdgeInsets.all(8),
          decoration: BoxDecoration(
              color: Colors.white12
          ),
          child: Text(formattedTime),
        ),
        SizedBox(height: 12,),


      ],
    );
  }
}

class recievedMessage extends StatelessWidget {
  Message message;
  recievedMessage({required this.message});
  @override
  Widget build(BuildContext context) {
    DateTime dateTime = DateTime.fromMillisecondsSinceEpoch(message.dateTime);
    String formattedTime =DateFormat.jm().format(dateTime);
    return  Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          padding: EdgeInsets.all(12),
          decoration: BoxDecoration(
              color: Colors.grey,
              borderRadius: BorderRadius.only(
                  bottomRight: Radius.circular(30),
                  topLeft: Radius.circular(30),
                  topRight: Radius.circular(30)
              )
          ),
          child: Text(message.content,style: TextStyle(
              color: Colors.black,
              fontSize: 16
          ),),
        ),
        SizedBox(height: 5,),
        Container(
          padding: EdgeInsets.all(8),
          decoration: BoxDecoration(
              color: Colors.white12
          ),
          child: Text(formattedTime),
        ),
        SizedBox(height: 12,),


      ],
    );
  }
}
