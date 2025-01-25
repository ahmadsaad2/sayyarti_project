import 'dart:convert';
import 'package:http/http.dart' as http;

class ChatGPTService {
  final String apiKey;

  ChatGPTService(this.apiKey);

  Future<String> askChatGPT(String prompt) async {
    const url = 'https://api.openai.com/v1/chat/completions';

    try {
      final response = await http.post(
        Uri.parse(url),
        headers: {
          'Authorization': 'Bearer $apiKey',
          'Content-Type': 'application/json',
        },
        body: jsonEncode({
          'model': 'gpt-3.5-turbo', // Use "gpt-4" if you have access
          'messages': [
            {'role': 'system', 'content': 'You are a car assistant.'},
            {'role': 'user', 'content': prompt},
          ],
          'max_tokens': 200,
          'temperature': 0.7,
        }),
      );

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        return data['choices'][0]['message']['content'].toString().trim();
      } else {
        throw Exception(
            'Failed to connect to ChatGPT: ${response.statusCode} - ${response.reasonPhrase}');
      }
    } catch (e) {
      return 'Error: $e';
    }
  }
}
