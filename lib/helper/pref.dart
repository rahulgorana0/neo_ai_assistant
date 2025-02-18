//import 'dart:developer';
import 'package:flutter/material.dart';
import 'package:hive/hive.dart';
import 'package:flutter/foundation.dart'; // for kIsWeb
import 'package:path_provider/path_provider.dart'; // for non-web platforms
import 'dart:io'; // for platform check

class Pref {
  static late Box _box;

  static Future<void> initialize() async {
    if (!kIsWeb && (Platform.isAndroid || Platform.isIOS)) {
      final appDocumentDirectory = await getApplicationDocumentsDirectory();
      Hive.init(appDocumentDirectory.path);
    } else if (kIsWeb) {
      Hive.init('web_hive');
    }

    _box = await Hive.openBox('myData');
  }

  static bool get showOnboarding => _box.get('showOnboarding', defaultValue: true);
  static set showOnboarding(bool v) => _box.put('showOnboarding', v);

  static bool get isDarkMode => _box.get('isDarkMode') ?? false;
  static set isDarkMode(bool v) => _box.put('isDarkMode', v);

  static ThemeMode get defaultTheme {
    if (!_box.containsKey('isDarkMode')) return ThemeMode.system;
    return _box.get('isDarkMode') ? ThemeMode.dark : ThemeMode.light;
  }
}
