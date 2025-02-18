import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:neo_ai_assistant/screen/feature/chatbot_feature.dart';
import 'package:neo_ai_assistant/screen/feature/habit_feature/habit_feature.dart';
import 'package:neo_ai_assistant/screen/feature/image_feature.dart';
import 'package:neo_ai_assistant/screen/feature/translator_feature.dart';
import 'package:neo_ai_assistant/screen/feature/note_feature/note_feature.dart';
import 'package:neo_ai_assistant/screen/feature/todo_feature/todo_feature.dart';

enum HomeType { aiChatBot, aiImage, aiTranslator, noteTaking, todolist, habitTracker }

extension MyHomeType on HomeType {
  // Title Mapping
  static final _titles = {
    HomeType.aiChatBot: 'AI ChatBot',
    HomeType.aiImage: 'AI Image Creator',
    HomeType.aiTranslator: 'Language Translator',
    HomeType.noteTaking: 'Note Taking',
    HomeType.todolist: 'To Do List',
    HomeType.habitTracker: 'Habit Tracker',
  };

  // Lottie Mapping
  static final _lottieFiles = {
    HomeType.aiChatBot: 'ai_hand_waving.json',
    HomeType.aiImage: 'ai_sit.json',
    HomeType.aiTranslator: 'ai_translate.json',
    HomeType.noteTaking: 'ai_hand_waving.json', // Unique Lottie file for notes
    HomeType.todolist: 'ai_sit.json', // Unique Lottie file for To-Do List
    HomeType.habitTracker: 'ai_translate.json', // Unique Lottie file for Habit Tracker
  };

  // Alignment Mapping
  static final _leftAlignments = {
    HomeType.aiChatBot: true,
    HomeType.aiImage: false,
    HomeType.aiTranslator: true,
    HomeType.noteTaking: false,
    HomeType.todolist: true,
    HomeType.habitTracker: false,
  };

  // Padding Mapping
  static final _paddings = {
    HomeType.aiChatBot: EdgeInsets.zero,
    HomeType.aiImage: const EdgeInsets.all(20),
    HomeType.aiTranslator: const EdgeInsets.all(20),
    HomeType.noteTaking: EdgeInsets.zero,
    HomeType.todolist: const EdgeInsets.all(20),
    HomeType.habitTracker: const EdgeInsets.all(20),
  };

  // Navigation Mapping
  static final _navigationCallbacks = {
    HomeType.aiChatBot: () => Get.to(() => ChatbotFeature()),
    HomeType.aiImage: () => Get.to(() => const ImageFeature()),
    HomeType.aiTranslator: () => Get.to(() => const TranslatorFeature()),
    HomeType.noteTaking: () => Get.to(() => NoteFeature()), // Added `const`
    HomeType.todolist: () => Get.to(() => TodoFeature()), // Added `const`
    HomeType.habitTracker: () => Get.to(() => const HabitFeature()), // Added `const`
  };

  String get title => _titles[this]!;
  String get lottie => _lottieFiles[this]!;
  bool get leftAlign => _leftAlignments[this]!;
  EdgeInsets get padding => _paddings[this]!;
  VoidCallback get onTap => _navigationCallbacks[this]!;
}