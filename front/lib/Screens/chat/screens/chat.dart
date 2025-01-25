import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:sayyarti/Screens/chat/widgets/chat_msg.dart';
import 'package:sayyarti/Screens/chat/widgets/new_msg.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ChatScreen extends StatefulWidget {
  ChatScreen({super.key, required this.personName, required this.personId});

  String? personName;
  String? personId;

  @override
  State<ChatScreen> createState() => _ChatScreenState();
}

class _ChatScreenState extends State<ChatScreen> {
  late String _senderId;
  void setupNotifications() async {
    final fcm = FirebaseMessaging.instance;
    await fcm.requestPermission();
    final notificationToken = await fcm.getToken();
    print(notificationToken);
  }

  void _getSenderId() async {
    final prefs = await SharedPreferences.getInstance();
    _senderId = prefs.getString('id')!;
  }

  @override
  void initState() {
    super.initState();
    setupNotifications();
    _getSenderId();
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
              recieverId: widget.personId,
              currentId: _senderId,
            ),
          ),
          NewMsg(
            recieverId: widget.personId,
            currentId: _senderId,
          ),
        ],
      ),
    );
  }
}
