import 'package:flutter/material.dart';
import 'package:sayyarti/Screens/chat/screens/chat.dart';
import 'package:sayyarti/constants.dart';
import 'package:sayyarti/model/conversation.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

class MainChatScreen extends StatefulWidget {
  const MainChatScreen({super.key});

  @override
  State<MainChatScreen> createState() {
    return _MainChatScreenState();
  }
}

class _MainChatScreenState extends State<MainChatScreen> {
  late Future<List<ChatConversation>> futureChats;
  String? userId;
  Future<List<ChatConversation>> fetchChatConversations(
      BuildContext context) async {
    final prefs = await SharedPreferences.getInstance();
    userId = prefs.getString('id');
    print('current user id: ${userId}');
    final url = Uri.http(backendUrl, '/user/chat-conv/');
    final response = await http.get(
      url,
      headers: {
        'Content-Type': 'application/json',
      },
    );

    if (response.statusCode == 200) {
      Map<String, dynamic> jsonResponse = json.decode(response.body);
      List<dynamic> data = jsonResponse['conv'];
      return data.map((json) => ChatConversation.fromJson(json)).toList();
    } else {
      // Show a popup dialog asking the user to try again
      await showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: Text('Error'),
            content:
                Text('Failed to load chat conversations. Please try again.'),
            actions: [
              TextButton(
                onPressed: () {
                  Navigator.of(context).pop(); // Close the dialog
                },
                child: Text('OK'),
              ),
              TextButton(
                onPressed: () {
                  Navigator.of(context).pop(); // Close the dialog
                  fetchChatConversations(context); // Retry the request
                },
                child: Text('Retry'),
              ),
            ],
          );
        },
      );
      throw Exception(
          'Failed to load chat conversations'); // Throw an exception to stop further execution
    }
  }

  @override
  void initState() {
    super.initState();
    futureChats = fetchChatConversations(context);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Chat Conversations'),
      ),
      body: FutureBuilder<List<ChatConversation>>(
        future: futureChats,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
            return Center(child: Text('No chat conversations found.'));
          } else {
            return ListView.builder(
              itemCount: snapshot.data!.length,
              itemBuilder: (context, index) {
                ChatConversation chat = snapshot.data![index];
                return Card(
                  margin: EdgeInsets.symmetric(vertical: 8, horizontal: 16),
                  child: ListTile(
                    title: Text(chat.name),
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => ChatScreen(
                            personId: chat.id,
                            personName: chat.name,
                            senderId: userId,
                          ),
                        ),
                      );
                    },
                  ),
                );
              },
            );
          }
        },
      ),
    );
  }
}
