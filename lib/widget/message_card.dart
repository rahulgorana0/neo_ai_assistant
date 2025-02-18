import 'package:animated_text_kit/animated_text_kit.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../controller/chat_controller.dart';
import '../helper/global.dart';
import '../model/message.dart';
import 'package:flutter_tts/flutter_tts.dart';

class MessageCard extends StatelessWidget {
  final Message message;
  final ChatController _chatController = Get.find();
  final FlutterTts _flutterTts = FlutterTts();

  MessageCard({super.key, required this.message}) {
    _initializeTTS();
  }

  // Initialize TTS once
  void _initializeTTS() async {
    await _flutterTts.setLanguage("en-US");
    await _flutterTts.setPitch(1.0);
  }

  void _speak(String text) async {
    if (text.isNotEmpty) {
      try {
        await _flutterTts.speak(text);
      } catch (e) {
        debugPrint('TTS Error: $e');
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    const radius = Radius.circular(15);
    final isBot = message.msgType == MessageType.bot;

    return Row(
      mainAxisAlignment: isBot ? MainAxisAlignment.start : MainAxisAlignment.end,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        if (isBot) ...[
          const SizedBox(width: 6),
          const CircleAvatar(
            radius: 18,
            backgroundColor: Colors.white,
            child: Image(image: AssetImage('assets/images/logo.png'), width: 24),
          ),
        ],
        Flexible(
          child: Container(
            constraints: BoxConstraints(maxWidth: mq.width * .6),
            margin: EdgeInsets.only(
              bottom: mq.height * 0.02,
              left: isBot ? mq.width * 0.02 : 0,
              right: isBot ? 0 : mq.width * 0.02,
            ),
            padding: EdgeInsets.symmetric(
                vertical: mq.height * 0.01, horizontal: mq.width * 0.02),
            decoration: BoxDecoration(
              border: Border.all(color: Theme.of(context).colorScheme.onSurface),
              borderRadius: BorderRadius.only(
                topLeft: radius,
                topRight: radius,
                bottomLeft: isBot ? Radius.zero : radius,
                bottomRight: isBot ? radius : Radius.zero,
              ),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                message.msg.isEmpty
                    ? AnimatedTextKit(
                        animatedTexts: [
                          TypewriterAnimatedText(
                            'Please wait...!',
                            speed: const Duration(milliseconds: 100),
                          ),
                        ],
                        repeatForever: true,
                      )
                    : Text(message.msg, textAlign: TextAlign.left),
                if (isBot && message.msg.isNotEmpty) ...[
                  const SizedBox(height: 8),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      GestureDetector(
                        onTap: () => _chatController.saveChatResponseAsNote(
                            'Chatbot Response', message.msg),
                        child: const Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Icon(Icons.save, size: 16, color: Colors.blue),
                            SizedBox(width: 4),
                            Text('Save to Notes',
                                style: TextStyle(color: Colors.blue)),
                          ],
                        ),
                      ),
                      GestureDetector(
                        onTap: () => _speak(message.msg),
                        child: const Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Icon(Icons.volume_up, size: 16, color: Colors.green),
                            SizedBox(width: 4),
                            Text('Listen', style: TextStyle(color: Colors.green)),
                          ],
                        ),
                      ),
                    ],
                  ),
                ],
              ],
            ),
          ),
        ),
        if (!isBot) ...[
          const CircleAvatar(
            radius: 18,
            backgroundColor: Colors.white,
            child: Icon(Icons.person, color: Colors.blue),
          ),
          const SizedBox(width: 6),
        ],
      ],
    );
  }
}