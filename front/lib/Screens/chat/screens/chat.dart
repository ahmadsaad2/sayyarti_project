import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:sayyarti/Screens/chat/widgets/chat_msg.dart';
import 'package:sayyarti/Screens/chat/widgets/new_msg.dart';
// import 'package:shared_preferences/shared_preferences.dart';

class ChatScreen extends StatefulWidget {
  ChatScreen(
      {super.key,
      required this.personName,
      required this.personId,
      required this.senderId});

  final String? personName;
  final String? personId;
  final String? senderId;

  @override
  State<ChatScreen> createState() => _ChatScreenState();
}

class _ChatScreenState extends State<ChatScreen> {
  void setupNotifications() async {
    final fcm = FirebaseMessaging.instance;
    await fcm.requestPermission();
    final notificationToken = await fcm.getToken();
    print(notificationToken);
  }

  @override
  void initState() {
    super.initState();
    setupNotifications();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.personName ?? 'Unknown'),
      ),
      body: Column(
        children: [
          Expanded(
            child: ChatMsgs(
              userName: widget.personName,
              recieverId: widget.personId,
              currentId: widget.senderId,
            ),
          ),
          NewMsg(
            recieverId: widget.personId,
            currentId: widget.senderId,
          ),
        ],
      ),
    );
  }
}
