import 'package:cloud_firestore/cloud_firestore.dart';

import 'package:flutter/material.dart';

class NewMsg extends StatefulWidget {
  const NewMsg({super.key, required this.recieverId, required this.currentId});
  final String? recieverId;
  final String? currentId;
  @override
  State<NewMsg> createState() {
    return _NewMsgState();
  }
}

class _NewMsgState extends State<NewMsg> {
  final _msgController = TextEditingController();
  String generateChatRoomId(String user1, String user2) {
    List<String> ids = [user1, user2];
    ids.sort();
    return ids.join('_');
  }

  @override
  void dispose() {
    _msgController.dispose();
    super.dispose();
  }

  void _sendMsg() async {
    final enteredMsg = _msgController.text;
    final chatRoomId =
        generateChatRoomId(widget.currentId!, widget.recieverId!);
    if (enteredMsg.trim().isEmpty) {
      return;
    }
    FocusScope.of(context).unfocus();

    FirebaseFirestore.instance.collection('chat').add({
      'senderId': widget.currentId,
      'receiverId': widget.recieverId,
      'message': enteredMsg,
      'chatRoomId': chatRoomId,
      'createdAt': Timestamp.now(),
    });
    _msgController.clear();
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(
        left: 15,
        right: 1,
        bottom: 14,
      ),
      child: Row(
        children: [
          Expanded(
            child: TextField(
              controller: _msgController,
              textCapitalization: TextCapitalization.sentences,
              autocorrect: true,
              enableSuggestions: true,
              decoration: const InputDecoration(labelText: 'Send a meddage...'),
            ),
          ),
          IconButton(
            color: Theme.of(context).colorScheme.primary,
            icon: const Icon(Icons.send_outlined),
            onPressed: _sendMsg,
          )
        ],
      ),
    );
  }
}
