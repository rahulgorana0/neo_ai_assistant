import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'package:youtube_explode_dart/youtube_explode_dart.dart';
import '../apis/apis.dart';
import '../helper/my_dialog.dart';
import '../model/message.dart';
import '../controller/note_controller.dart';
import 'package:speech_to_text/speech_to_text.dart' as stt;

class ChatController extends GetxController {
  static ChatController get to => Get.find();

  final TextEditingController textC = TextEditingController();
  final ScrollController scrollC = ScrollController();
  final NoteController noteController = Get.find();

  var isListening = false.obs;
  var list = <Message>[].obs;
  late stt.SpeechToText speech;
  bool _isSpeechInitialized = false;

  @override
  void onInit() {
    super.onInit();
    _initializeSpeech();
    list.add(const Message(msg: 'Hello, How can I help you?', msgType: MessageType.bot));
  }

  @override
  void onClose() {
    textC.dispose();
    scrollC.dispose();
    if (_isSpeechInitialized) speech.stop();
    super.onClose();
  }

  /// Initialize Speech-to-Text
  Future<void> _initializeSpeech() async {
    speech = stt.SpeechToText();
    _isSpeechInitialized = await speech.initialize(
      onStatus: (status) => debugPrint('Speech Status: $status'),
      onError: (error) => debugPrint('Speech Error: $error'),
    );
    debugPrint("Speech Initialized: $_isSpeechInitialized");
  }

  /// Start Listening
  void startListening() {
    if (!_isSpeechInitialized) {
      MyDialog.info("Speech-to-Text not initialized! Please try again.");
      return;
    }

    isListening.value = true;
    speech.listen(onResult: (result) {
      textC.text = result.recognizedWords;
      isListening.value = false;
    });
  }

  /// Process Question
  Future<void> askQuestion({String? source}) async {
    String question = textC.text.trim();
    if (question.isEmpty) {
      MyDialog.info('Ask Something!');
      return;
    }

    list.addAll([
      Message(msg: question, msgType: MessageType.user),
      const Message(msg: '...', msgType: MessageType.bot),
    ]);
    _scrollDown();

    try {
      String response;
      if (source == "wikipedia") {
        response = await fetchWikipediaSummary(question);
      } else if (source == "youtube") {
        response = await fetchYouTubeResults(query: question);
      } else {
        response = await APIs.getGeminiAnswer(question);
      }

      list.removeLast();
      list.add(Message(msg: response, msgType: MessageType.bot));
      _scrollDown();
      textC.clear();
    } catch (e) {
      debugPrint("Error fetching response: $e");
      Get.snackbar('Error', 'Failed to get response');
    }
  }

  /// Fetch Wikipedia Summary
  Future<String> fetchWikipediaSummary(String query) async {
    try {
      final url = 'https://en.wikipedia.org/api/rest_v1/page/summary/$query';
      final response = await http.get(Uri.parse(url));

      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        return "**${data['title']}**\n${data['extract']}\n[Read More](${data['content_urls']['desktop']['page']})";
      }
    } catch (e) {
      debugPrint("Wikipedia API Error: $e");
    }
    return 'No Wikipedia results found.';
  }

  /// Fetch YouTube Videos Without API Key
  Future<String> fetchYouTubeResults({required String query}) async {
    List<String> results = [];
    var yt = YoutubeExplode();

    try {
      var searchResults = await yt.search.getVideos(query);

      for (var video in searchResults.take(3)) {
        results.add("**${video.title}**\n[Watch Video](https://www.youtube.com/watch?v=${video.id})\n");
      }

      return results.isNotEmpty ? results.join("\n") : 'No YouTube videos found.';
    } catch (e) {
      debugPrint("YouTube Scraping Error: $e");
      return 'Failed to fetch YouTube videos.';
    } finally {
      yt.close();
    }
  }

  void saveChatResponseAsNote(String title, String content) {
    noteController.addNote(title, content, 'Chat Notes', false, []);
    Get.snackbar('Success', 'Chat response saved to Notes');
  }

  /// Scroll Down
  void _scrollDown() {
    if (scrollC.hasClients) {
      scrollC.animateTo(
        scrollC.position.maxScrollExtent,
        duration: const Duration(milliseconds: 500),
        curve: Curves.easeOut,
      );
    }
  }
}
