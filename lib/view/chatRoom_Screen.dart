import 'dart:convert';

import 'package:chat_app/Navigators/chatRoomNavigator.dart';
import 'package:chat_app/Services/local_push_notification.dart';
import 'package:chat_app/model/message.dart';
import 'package:chat_app/model/my_user.dart';
import 'package:chat_app/provider/push_notification_provider.dart';
import 'package:chat_app/provider/user_provider.dart';
import 'package:chat_app/view/home_screen.dart';
import 'package:chat_app/view/messageWidget.dart';
import 'package:chat_app/view_model/chatRoom_viewModel.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:provider/provider.dart';
import 'package:chat_app/utils.dart' as utils;

import '../model/room.dart';
import '../widgets/customSearchDelegate.dart';

class chatRoomScreen extends StatefulWidget {
  static const String routeName = 'chatRoom-screen';

  @override
  State<chatRoomScreen> createState() => _chatRoomScreenState();
}

class _chatRoomScreenState extends State<chatRoomScreen>
    implements chatRoomNavigator {
  chatRoom_viewModel viewModel = chatRoom_viewModel();
  String message = '';
  TextEditingController controller = TextEditingController();

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    viewModel.navigator = this;
    FirebaseMessaging.instance.getInitialMessage();
    FirebaseMessaging.onMessage.listen((event) {
      LocalNotificationService.display(event);
    });
    //call the store token fun
    HomeScreen.storeNotificationToken();
  }

  //send notification function
  sendNotification(
      String title, String body, String token, String roomId) async {
    final data = {
      'click_action': 'FLUTTER_NOTIFICATION_CLICK',
      'id': '1',
      'status': 'done',
      'message': title,
    };

    try {
      http.Response response =
          await http.post(Uri.parse('https://fcm.googleapis.com/fcm/send'),
              headers: <String, String>{
                'Content-Type': 'application/json',
                'Authorization':
                    'key=AAAAaMRsVIU:APA91bHeCqnqY4Vf_n22iFRlP1S1qooSIkpDq4-tHto0k4YksSZocrb3wBgXHMoD8hiEOM5VEpTs2-Bq59_Vh94Ua2kfgZkCe-P0C1UO2D0GMFtxpFKKmI2f1TQRPJRcnu8vlcQLpe-2'
              },
              body: jsonEncode(<String, dynamic>{
                'notification': <String, dynamic>{
                  'title': title,
                  'body': body,
                },
                'priority': 'high',
                'data': data,
                //which user to send notification to
                'to': '$token'
              }));

      if (response.statusCode == 200) {
        print("notification is sent");
      } else {
        print("Error");
      }
    } catch (e) {}
  }

  @override
  Widget build(BuildContext context) {
    var args = ModalRoute.of(context)?.settings.arguments as Room;
    var provider = Provider.of<UserProvider>(context);
    viewModel.currentUser = provider.user!;
    viewModel.room=args;
    viewModel.listenForUpdateMessages();

    return ChangeNotifierProvider(
      create: (context) => viewModel,
      child: Stack(
        children: [
          Container(
            color: Colors.white,
          ),
          Image.asset(
            'assets/images/main_bg.png',
            fit: BoxFit.cover,
            width: double.infinity,
          ),
          Scaffold(
            backgroundColor: Colors.transparent,
            appBar: AppBar(
              actions: [
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: IconButton(
                    onPressed: () {
                      showSearch(
                          context: context,
                          delegate:
                              customSearchDelegate(roomId: args!.roomId));
                    },
                    icon: Icon(
                      Icons.search,
                      color: Colors.blue,
                    ),
                  ),
                ),
                viewModel.room.participants.contains(viewModel.currentUser.id)
                    ? Container(
                        margin: EdgeInsets.all(5),
                        child: FloatingActionButton(
                            child: Text("leave"),
                            onPressed: () {
                              viewModel.removeRoomParticipant();
                              setState(() {});
                            }))
                    : Container(
                        margin: EdgeInsets.all(5),
                        child: FloatingActionButton(
                            child: Text("join"),
                            onPressed: () {
                              viewModel.addRoomParticipant();
                              setState(() {});
                            }))
              ],
              backgroundColor: Colors.transparent,
              elevation: 0,
              title: Text(
                args!.title,
                style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 22,
                    color: Colors.black),
              ),
              centerTitle: true,
            ),
            body: Container(
                height: MediaQuery.of(context).size.height * 0.8,
                margin: EdgeInsets.symmetric(horizontal: 12, vertical: 35),
                padding: EdgeInsets.all(20),
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
                    Expanded(
                        child: StreamBuilder<QuerySnapshot<Message>>(
                      stream: viewModel.streamMessage,
                      builder: (context, snapshot) {
                        if (snapshot.connectionState ==
                            ConnectionState.waiting) {
                          return Center(child: CircularProgressIndicator());
                        } else if (snapshot.hasError) {
                          return Text(snapshot.error.toString());
                        } else {
                          var messageList = snapshot.data?.docs
                                  .map((doc) => doc.data())
                                  .toList() ??
                              [];
                          return ListView.builder(
                            itemCount: messageList.length,
                            itemBuilder: (context, index) {
                              return messageWidget(message: messageList[index]);
                            },
                          );
                        }
                      },
                    )),
                    Spacer(),
                    Row(
                      children: [
                        Expanded(
                          child: TextFormField(
                            validator: (value) {
                              if (value == null || value.trim().isEmpty) {
                                return 'please a message to send';
                              } else {
                                return null;
                              }
                            },
                            onChanged: (value) {
                              message = value;
                            },
                            controller: controller,
                            decoration: InputDecoration(
                                hintText: 'Type a message',
                                enabledBorder: OutlineInputBorder(
                                    borderRadius: BorderRadius.only(
                                        topRight: Radius.circular(12)),
                                    borderSide:
                                        BorderSide(color: Colors.grey))),
                          ),
                        ),
                        SizedBox(
                          width: 10,
                        ),
                        Container(
                          padding: EdgeInsets.symmetric(
                              vertical: 12, horizontal: 10),
                          decoration: BoxDecoration(
                              color: Colors.blue,
                              borderRadius: BorderRadius.circular(5)),
                          child: InkWell(
                            onTap: () async {
                              viewModel.sendMessage(message);
                              for (int i = 0; i < viewModel.room.participants.length; i++) {
                                if (viewModel.room.participants[i].toString() != viewModel.currentUser.id) {
                                  String userid = viewModel.room.participants[i];
                                  QuerySnapshot<Map<String, dynamic>>
                                      userSnapshot = await FirebaseFirestore
                                          .instance
                                          .collection(MyUser.collectionName)
                                          .where('id', isEqualTo: userid)
                                          .get();
                                  if (userSnapshot.docs.isNotEmpty) {
                                    MyUser myUser = MyUser.fromJson(
                                        userSnapshot.docs.first.data());
                                    sendNotification(
                                        viewModel.room.title,
                                        viewModel.currentUser.firstName +
                                            ":" +
                                            message,
                                        myUser.token,
                                        viewModel.room.roomId);
                                  }
                                }
                              }
                            },
                            child: const Row(
                              children: [
                                Text(
                                  'Send',
                                  style: TextStyle(color: Colors.white),
                                ),
                                SizedBox(
                                  width: 5,
                                ),
                                Icon(
                                  Icons.send,
                                  color: Colors.white,
                                )
                              ],
                            ),
                          ),
                        )
                      ],
                    )
                  ],
                )),
          )
        ],
      ),
    );
  }

  @override
  void showMessage(String message) {
    utils.showMessage(context, message, 'ok', posAction);
  }

  void posAction(BuildContext context) {
    Navigator.pop(context);
  }

  @override
  void clearMessage() {
    controller.clear();
  }
}

