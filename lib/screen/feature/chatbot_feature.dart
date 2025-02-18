import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../controller/chat_controller.dart';
import '../../widget/message_card.dart';

class ChatbotFeature extends StatelessWidget {
  final ChatController _c = Get.find();
  
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Chat with AI Assistant')),

      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
      floatingActionButton: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 8),
        child: Row(children: [
          // **Text Input Field**
          Expanded(
            child: TextFormField(
              controller: _c.textC,
              textAlign: TextAlign.center,
              onTapOutside: (_) => FocusScope.of(context).unfocus(),
              decoration: InputDecoration(
                fillColor: Theme.of(context).scaffoldBackgroundColor,
                filled: true,
                isDense: true,
                hintText: 'Ask me anything...',
                hintStyle: const TextStyle(fontSize: 14),
                border: const OutlineInputBorder(
                  borderRadius: BorderRadius.all(Radius.circular(50)),
                ),
              ),
            ),
          ),

          const SizedBox(width: 8),

          // **Mic Button for Voice Input**
          CircleAvatar(
            radius: 24,
            backgroundColor: Colors.red,
            child: IconButton(
              onPressed: _c.startListening,
              icon: const Icon(Icons.mic, color: Colors.white, size: 28),
            ),
          ),

          const SizedBox(width: 8),

          // **Send Button**
          CircleAvatar(
            radius: 24,
            backgroundColor: Theme.of(context).colorScheme.primary,
            child: IconButton(
              onPressed: _c.askQuestion,
              icon: const Icon(Icons.rocket_launch_rounded,
                  color: Colors.white, size: 28),
            ),
          ),
        ]),
      ),

      // **Chat Messages List**
      body: Obx(() => ListView.builder(
            physics: const BouncingScrollPhysics(),
            controller: _c.scrollC,
            padding: EdgeInsets.only(
                top: MediaQuery.of(context).size.height * 0.02,
                bottom: MediaQuery.of(context).size.height * 0.1),
            itemCount: _c.list.length,
            itemBuilder: (context, index) =>
                MessageCard(message: _c.list.toList()[index]),
          )),
    );
  }
}
