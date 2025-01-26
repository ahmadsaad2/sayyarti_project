class ChatConversation {
  final String id;
  final String name;

  ChatConversation({required this.id, required this.name});

  factory ChatConversation.fromJson(Map<String, dynamic> json) {
    return ChatConversation(
      id: json['id'].toString(),
      name: json['name'],
    );
  }
}
