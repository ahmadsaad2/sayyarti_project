import 'package:sayyarti/Screens/chat/widgets/message_bubble.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class ChatMsgs extends StatelessWidget {
  ChatMsgs({super.key, required this.recieverId, required this.currentId});
  String? recieverId;
  String? currentId;

  @override
  Widget build(BuildContext context) {
    return StreamBuilder(
      stream: FirebaseFirestore.instance
          .collection('chat')
          .where('senderId', whereIn: [currentId, recieverId])
          .where('receiverId', whereIn: [currentId, recieverId])
          .orderBy(
            'timestamp',
            descending: true,
          )
          .snapshots(),
      builder: (ctx, chatSnapshots) {
        if (chatSnapshots.connectionState == ConnectionState.waiting) {
          return Center(
            child: const CircularProgressIndicator(),
          );
        }

        if (!chatSnapshots.hasData || chatSnapshots.data!.docs.isEmpty) {
          return Center(
            child: const Text('no msgs to display'),
          );
        }
        if (chatSnapshots.hasError) {
          return Center(
            child: const Text('Something went wrong...'),
          );
        }

        final loadedMsgs = chatSnapshots.data!.docs;

        return ListView.builder(
          padding: const EdgeInsets.only(
            bottom: 40,
            right: 30,
            left: 30,
          ),
          reverse: true,
          itemCount: loadedMsgs.length,
          itemBuilder: (ctx, index) {
            final chatMsg = loadedMsgs[index].data();
            final nextChatMsg = index + 1 < loadedMsgs.length
                ? loadedMsgs[index + 1].data()
                : null;
            final currentMsgUserId = chatMsg['userId'];
            final nextChatMsgUserId =
                nextChatMsg != null ? nextChatMsg['userId'] : null;
            final nextUserIsSame = nextChatMsgUserId == currentMsgUserId;

            if (nextUserIsSame) {
              return MessageBubble.next(
                message: chatMsg['text'],
                isMe: currentId == currentMsgUserId,
              );
            } else {
              return MessageBubble.first(
                userImage: chatMsg['userImage'],
                username: chatMsg['username'],
                message: chatMsg['text'],
                isMe: currentId == currentMsgUserId,
              );
            }
          },
        );
      },
    );
  }
}
