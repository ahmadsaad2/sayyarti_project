import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:sayyarti/Screens/chat/screens/main_chat.dart';
import 'package:sayyarti/constants.dart';
import 'package:sayyarti/firebasefunctions/local_notifications.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;

final FirebaseMessaging _firebaseMessaging = FirebaseMessaging.instance;
final GlobalKey<NavigatorState> navigatorKey = GlobalKey<NavigatorState>();
void initializeFCM() async {
  await _firebaseMessaging.requestPermission(
    alert: true,
    badge: true,
    sound: true,
  );

  String? fireToken = await _firebaseMessaging.getToken();
  final prefs = await SharedPreferences.getInstance();
  final userId = prefs.getInt('userId');
  final token = prefs.getString('token');
  print('fcm_token :$fireToken');
  print('userId : $userId');
  final url = Uri.http(backendUrl, '/user/info-update/$userId');
  final res = await http.put(
    url,
    headers: {
      'Content-Type': 'application/json',
      'token': token!,
    },
    body: json.encode({
      'fcm_token': fireToken,
    }),
  );
  if (res.statusCode != 200) {
    ScaffoldMessenger.of(navigatorKey.currentContext!).showSnackBar(
      SnackBar(
        content: Text('Failed to update FCM token!'),
        duration: Duration(seconds: 3),
        action: SnackBarAction(
          label: 'Undo',
          onPressed: () {
            // Action to perform when the action button is pressed
          },
        ),
      ),
    );
  }

  //Listener for the incoming msgs
  FirebaseMessaging.onMessage.listen((RemoteMessage msg) {
    print(msg.notification?.title);
    showLocalNotification(
      title: msg.notification?.title,
      body: msg.notification?.body,
    );
  });

  FirebaseMessaging.onMessageOpenedApp.listen((RemoteMessage msg) {
    msg.notification?.title;
    navigatorKey.currentState?.push(
      MaterialPageRoute(builder: (context) => MainChatScreen()),
    );
  });
}
