import 'package:flutter/material.dart';
import 'package:get/get.dart';
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
    speech.stop();
    super.onClose();
  }

  // **Initialize Speech Recognition Once**
  Future<void> _initializeSpeech() async {
    if (!_isSpeechInitialized) {
      speech = stt.SpeechToText();
      _isSpeechInitialized = await speech.initialize(
        onError: (error) => debugPrint("Speech recognition error: $error"),
      );
      if (!_isSpeechInitialized) {
        Get.snackbar('Error', 'Speech recognition is not available');
      }
    }
  }

  // **Start Listening for Speech**
  void startListening() async {
    if (!_isSpeechInitialized) await _initializeSpeech();
    
    if (speech.isListening) {
      speech.stop();
    } else {
      speech.listen(
        onResult: (result) => textC.text = result.recognizedWords,
      );
    }
  }

  // **Ask AI Assistant a Question**
  Future<void> askQuestion() async {
    String question = textC.text.trim();
    if (question.isEmpty) {
      MyDialog.info('Ask Something!');
      return;
    }

    list.addAll([
      Message(msg: question, msgType: MessageType.user),
      const Message(msg: '...', msgType: MessageType.bot), // Loading Placeholder
    ]);
    _scrollDown();

    try {
      String response = await APIs.getAnswer(question);

      list.removeLast(); // Remove Placeholder
      list.add(Message(msg: response, msgType: MessageType.bot));
      _scrollDown();
      
      textC.clear();
    } catch (e) {
      debugPrint("Error fetching AI response: $e");
      Get.snackbar('Error', 'Failed to get AI response');
    }
  }

  // **Save Chat Response as Note**
  void saveChatResponseAsNote(String title, String content) {
    noteController.addNote(title, content, 'Chat Notes', false, []);
    Get.snackbar('Success', 'Chat response saved to Notes');
  }

  // **Scroll to the Last Message Efficiently**
  void _scrollDown() {
    if (scrollC.hasClients) {
      scrollC.animateTo(
        scrollC.position.minScrollExtent,
        duration: const Duration(milliseconds: 500),
        curve: Curves.easeOut,
      );
    }
  }
}
