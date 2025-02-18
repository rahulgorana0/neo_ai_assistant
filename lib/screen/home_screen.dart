import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';

import '../helper/global.dart';
import '../helper/pref.dart';
import '../model/home_type.dart';
import '../widget/home_card.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final RxBool _isDarkMode = Get.isDarkMode.obs;

  @override
  void initState() {
    super.initState();
    SystemChrome.setEnabledSystemUIMode(SystemUiMode.edgeToEdge);
    Pref.showOnboarding = false;
  }

  @override
  Widget build(BuildContext context) {
    final Size screenSize = MediaQuery.of(context).size;

    return Scaffold(
      appBar: AppBar(
        title: const Text(appName),
        actions: [
          Obx(() => IconButton(
                padding: const EdgeInsets.only(right: 10),
                onPressed: _toggleTheme,
                icon: _buildThemeIcon(),
              )),
        ],
      ),
      body: ListView(
        padding: EdgeInsets.symmetric(
          horizontal: screenSize.width * 0.04,
          vertical: screenSize.height * 0.015,
        ),
        children: HomeType.values.map((e) => HomeCard(homeType: e)).toList(),
      ),
    );
  }

  void _toggleTheme() {
    final newMode = _isDarkMode.value ? ThemeMode.light : ThemeMode.dark;
    Get.changeThemeMode(newMode);
    _isDarkMode.value = !_isDarkMode.value;
    Pref.isDarkMode = _isDarkMode.value;
  }

  Widget _buildThemeIcon() {
    return Icon(
      _isDarkMode.value
          ? Icons.brightness_2_rounded
          : Icons.brightness_5_rounded,
      size: 26,
    );
  }
}
