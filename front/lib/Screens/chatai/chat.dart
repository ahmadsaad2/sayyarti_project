import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'chatcontroller.dart';

class ChatBotFeature extends StatelessWidget {
  final _c = Get.put(ChatController());

  ChatBotFeature({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Row(
          children: [
            const SizedBox(width: 70), // Spacing between logo and text
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  'Sayyarti AI',
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                ),
                Text(
                  'AI care for your vehicle',
                  style: TextStyle(
                    fontSize: 12,
                    color: Colors.white.withOpacity(0.8),
                  ),
                ),
              ],
            ),
          ],
        ),
        flexibleSpace: Container(
          decoration: const BoxDecoration(
            gradient: LinearGradient(
              colors: [
                Color.fromARGB(255, 3, 32, 114),
                Color.fromARGB(255, 13, 5, 126)
              ], // Gradient colors
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
          ),
        ),
      ),
      body: Stack(
        children: [
          // Background Image
          Container(
            decoration: BoxDecoration(
              image: DecorationImage(
                image: AssetImage(
                  'assets/images/7.jpg', // Path to your background image
                ),
                fit: BoxFit.cover, // Fit image to cover entire screen
              ),
            ),
          ),

          // Semi-Transparent Overlay
          Container(
            color:
                Colors.black.withOpacity(0.3), // Adjust opacity for readability
          ),

          // Chat Messages and Input Area
          Column(
            children: [
              // Chat Messages
              Expanded(
                child: Obx(
                  () => ListView.builder(
                    controller: _c.scrollC,
                    padding: const EdgeInsets.all(16),
                    itemCount: _c.list.length,
                    itemBuilder: (context, index) {
                      final message = _c.list[index];
                      return MessageCard(
                        message: message.msg,
                        isUser: message.msgType == MessageType.user,
                      );
                    },
                  ),
                ),
              ),

              // Input Area
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Row(
                  children: [
                    // Constrain the TextField to avoid overflow
                    Expanded(
                      child: TextField(
                        controller: _c.textC,
                        decoration: InputDecoration(
                          hintText: 'Ask me anything...',
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(25),
                          ),
                          contentPadding:
                              const EdgeInsets.symmetric(horizontal: 16),
                          filled: true,
                          fillColor: Colors.white
                              .withOpacity(0.8), // Semi-transparent white
                        ),
                      ),
                    ),
                    const SizedBox(width: 8),
                    // Send Button
                    Container(
                      decoration: BoxDecoration(
                        color: const Color.fromARGB(255, 7, 16, 100),
                        borderRadius: BorderRadius.circular(25),
                      ),
                      child: IconButton(
                        onPressed: _c.askQuestion,
                        icon: const Icon(Icons.send, color: Colors.white),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class MessageCard extends StatelessWidget {
  final String message;
  final bool isUser;

  const MessageCard({super.key, required this.message, required this.isUser});

  @override
  Widget build(BuildContext context) {
    return Align(
      alignment: isUser ? Alignment.centerRight : Alignment.centerLeft,
      child: Container(
        margin: const EdgeInsets.symmetric(vertical: 4),
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
        decoration: BoxDecoration(
          color: isUser
              ? const Color.fromARGB(255, 5, 2, 148)
                  .withOpacity(0.8) // Semi-transparent blue for user messages
              : Colors.grey[300]!
                  .withOpacity(0.8), // Semi-transparent grey for bot messages
          borderRadius: BorderRadius.circular(20),
        ),
        child: Text(
          message,
          style: TextStyle(
            color: isUser ? Colors.white : Colors.black,
          ),
        ),
      ),
    );
  }
}
