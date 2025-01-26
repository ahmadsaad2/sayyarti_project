// chat_controller.dart
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'api.dart';

class ChatController extends GetxController {
  final textC = TextEditingController();
  final scrollC = ScrollController();
  final list = <Message>[].obs;

  Future<void> askQuestion() async {
    if (textC.text.trim().isNotEmpty) {
      // Add user message
      list.add(Message(msg: textC.text, msgType: MessageType.user));
      list.add(Message(
          msg: '', msgType: MessageType.bot)); // Placeholder for bot response
      _scrollDown();

      // Get AI response
      final res = await GeminiAPI.getAnswer(textC.text);

      // Update bot message
      list.removeLast();
      list.add(Message(msg: res, msgType: MessageType.bot));
      _scrollDown();

      textC.clear();
    }
  }

  void _scrollDown() {
    scrollC.animateTo(
      scrollC.position.maxScrollExtent,
      duration: const Duration(milliseconds: 500),
      curve: Curves.ease,
    );
  }
}

class Message {
  final String msg;
  final MessageType msgType;

  Message({required this.msg, required this.msgType});
}

enum MessageType { user, bot }
