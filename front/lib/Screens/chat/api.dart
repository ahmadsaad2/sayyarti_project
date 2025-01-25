import 'package:google_generative_ai/google_generative_ai.dart';
import 'dart:developer';

class GeminiAPI {
  static const String apiKey =
      'AIzaSyD72ySbbKr2TQaVq7OLBrGc2wsO67O20jk'; // Replace with your Gemini API key

  // Get answer from Gemini API
  static Future<String> getAnswer(String question) async {
    try {
      log('API Key: $apiKey');

      // Initialize the GenerativeModel
      final model = GenerativeModel(
        model: 'gemini-pro', // Use a valid model name
        apiKey: apiKey,
      );

      // Simplified and Clear Prompt for Workshop-Related Problems
      final prompt = '''
You are an expert car mechanic. Provide clear and actionable advice for car problems.
When answering questions, follow these rules:
1. Identify the problem and its possible causes.
2. Suggest immediate steps the user can take to diagnose or fix the issue.
3. Recommend whether the user should visit a workshop and why.
4. Provide tips to prevent the problem in the future.

Question: $question
''';

      // Prepare the content for the API request
      final content = [Content.text(prompt)];

      // Send the request to the Gemini API
      final response = await model.generateContent(content, safetySettings: [
        SafetySetting(HarmCategory.dangerousContent, HarmBlockThreshold.none),
        SafetySetting(HarmCategory.sexuallyExplicit, HarmBlockThreshold.none),
        SafetySetting(HarmCategory.harassment, HarmBlockThreshold.none),
        SafetySetting(HarmCategory.hateSpeech, HarmBlockThreshold.none),
      ]);

      // Log the raw response
      log('Raw Response: ${response.text}');

      // Format the response
      final formattedResponse = formatResponse(response.text!);

      // Log the formatted response
      log('Formatted Response: $formattedResponse');

      // Return the formatted response
      return formattedResponse;
    } catch (e) {
      // Log and handle errors
      log('Error: $e');
      return 'Something went wrong (Try again in sometime)';
    }
  }

  // Format the AI's response
  static String formatResponse(String response) {
    // Add headings and bullet points
    return response
        .replaceAll('- ', '• ') // Convert dashes to bullet points
        .replaceAll('\n', '\n\n'); // Add extra spacing for readability
  }
}
