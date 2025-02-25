import 'dart:convert';
import 'dart:io';
import 'dart:developer';
import 'package:http/http.dart' as http;
import 'package:translator_plus/translator_plus.dart';

class APIs {
  static final _client = http.Client();
  static const String geminiApiKey = 'YOUR_GEMINI_API_KEY';

  /// Fetch answer from Gemini AI
  static Future<String> getGeminiAnswer(String question) async {
    try {
      final uri = Uri.parse(
          'https://generativelanguage.googleapis.com/v1beta/models/gemini-pro:generateContent?key=$geminiApiKey');
      final response = await _client.post(
        uri,
        headers: {HttpHeaders.contentTypeHeader: 'application/json'},
        body: jsonEncode({
          "contents": [
            {
              "parts": [
                {"text": question}
              ]
            }
          ]
        }),
      );

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        final answer = data['candidates']?.first['content']['parts']?.first['text'] ?? 'No response';
        log('Gemini Response: $answer');
        return answer;
      } else {
        log('Gemini API Error: ${response.statusCode} - ${response.body}');
        return 'Error: Unable to fetch response. Try again later.';
      }
    } catch (e) {
      log('getGeminiAnswer Error: $e');
      return 'Something went wrong! Please try again.';
    }
  }

  /// Generate AI Images using Gemini
  static Future<List<String>> generateGeminiImages(String prompt) async {
    try {
      final uri = Uri.parse(
          'https://generativelanguage.googleapis.com/v1beta/models/gemini-pro-vision:generateContent?key=$geminiApiKey');
      final response = await _client.post(
        uri,
        headers: {HttpHeaders.contentTypeHeader: 'application/json'},
        body: jsonEncode({"prompt": [{"text": prompt}]}),
      );

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        return List<String>.from(data['images']?.map((e) => e['src'].toString()) ?? []);
      } else {
        log('Gemini Image API Error: ${response.statusCode} - ${response.body}');
        return [];
      }
    } catch (e) {
      log('generateGeminiImages Error: $e');
      return [];
    }
  }

  /// Google Translate API
  static Future<String> googleTranslate(
      {required String from, required String to, required String text}) async {
    try {
      final translator = GoogleTranslator();
      final result = await translator.translate(text, from: from, to: to);
      return result.text;
    } catch (e) {
      log('googleTranslate Error: $e');
      return 'Translation failed!';
    }
  }

  static getAnswer(String prompt) {}
}
