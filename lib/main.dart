import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:neo_ai_assistant/controller/chat_controller.dart';
import 'package:neo_ai_assistant/controller/note_controller.dart';
import 'package:neo_ai_assistant/controller/todo_controller.dart';
import 'package:neo_ai_assistant/helper/global.dart';
import 'package:neo_ai_assistant/model/habit/habit.dart';
import 'package:neo_ai_assistant/model/note/note.dart';
import 'package:neo_ai_assistant/model/todo/todo.dart';
import 'package:neo_ai_assistant/screen/splash_screen.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'helper/pref.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  
  await Pref.initialize();
  
  await SystemChrome.setEnabledSystemUIMode(SystemUiMode.immersiveSticky);
  await SystemChrome.setPreferredOrientations([
    DeviceOrientation.portraitUp,
    DeviceOrientation.portraitDown,
  ]);

  await Hive.initFlutter();

  // Register Hive Adapters
  Hive
    ..registerAdapter(NoteAdapter())
    ..registerAdapter(TodoAdapter())
    ..registerAdapter(HabitAdapter());

  // Open Hive Boxes
  await Future.wait([
    Hive.openBox<Note>('notes'),
    Hive.openBox<Todo>('todos'),
    Hive.openBox<Habit>('habits'),
  ]);

  // Register GetX Controllers
  Get.put(NoteController(), permanent: true);
  Get.put(ChatController(), permanent: true);
  Get.put(TodoController(), permanent: true);

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      title: appName,
      debugShowCheckedModeBanner: false,
      themeMode: Pref.defaultTheme,
      darkTheme: ThemeData(
        useMaterial3: false,
        brightness: Brightness.dark,
        appBarTheme: const AppBarTheme(
          elevation: 1,
          centerTitle: true,
          titleTextStyle: TextStyle(
            color: Colors.white,
            fontSize: 20,
            fontWeight: FontWeight.w500,
          ),
        ),
      ),
      theme: ThemeData(
        useMaterial3: false,
        appBarTheme: const AppBarTheme(
          elevation: 1,
          centerTitle: true,
          backgroundColor: Colors.white,
          iconTheme: IconThemeData(color: Colors.blue),
          titleTextStyle: TextStyle(
            color: Colors.blue,
            fontSize: 20,
            fontWeight: FontWeight.w500,
          ),
        ),
      ),
      home: const SplashScreen(),
    );
  }
}

extension AppTheme on ThemeData {
  Color get lightTextColor =>
      brightness == Brightness.dark ? Colors.white70 : Colors.black54;

  Color get buttonColor =>
      brightness == Brightness.dark ? Colors.cyan.withOpacity(0.5) : Colors.blue;
}
