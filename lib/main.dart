
import 'package:chat_app/provider/push_notification_provider.dart';
import 'package:chat_app/provider/user_provider.dart';
import 'package:chat_app/view/addRoom/addRoom_screen.dart';
import 'package:chat_app/view/chatRoom_Screen.dart';
import 'package:chat_app/view/home_screen.dart';
import 'package:chat_app/view/register_screen.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:provider/provider.dart';
import 'Services/local_push_notification.dart';
import 'model/room.dart';
import 'view/login_screen.dart';


Future<void> _firebaseMessagingBackgroundHandler(RemoteMessage message) async {
  await Firebase.initializeApp();

}

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();

  //push messages notfications
  LocalNotificationService.initialize();
  FirebaseMessaging.onBackgroundMessage(_firebaseMessagingBackgroundHandler);


  runApp(MultiProvider(
    child: MyApp(),
    providers: [
      ChangeNotifierProvider<UserProvider>(
          create: (context) => UserProvider(), child: MyApp()),

    ],
  ));


}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {

    var provider = Provider.of<UserProvider>(context);
    return MaterialApp(
        debugShowCheckedModeBanner: false,
        routes: {
          RegisterScreen.routeName: (context) => RegisterScreen(),
          LoginScreen.routeName: (context) => LoginScreen(),
          HomeScreen.routeName: (context) => HomeScreen(),
          AddRoomScreen.routeName: (context) => AddRoomScreen(),
          chatRoomScreen.routeName: (context) => chatRoomScreen(),
        },
        initialRoute: /* HomeScreen.routeName);*/
            provider.firebaseUser == null
                ? LoginScreen.routeName
                : HomeScreen.routeName);
  }
}
