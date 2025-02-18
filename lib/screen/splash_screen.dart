import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../helper/global.dart';
import '../helper/pref.dart';
import '../widget/custom_loading.dart';
import 'home_screen.dart';
import 'onboarding_screen.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    super.initState();

    Future.delayed(const Duration(seconds: 3), () {
      Get.offAll(() => Pref.showOnboarding
          ? const OnboardingScreen()
          : const HomeScreen());
    });
  }

  @override
  Widget build(BuildContext context) {
    mq = MediaQuery.sizeOf(context);

    return Scaffold(
      body: SizedBox(
        width: double.infinity,
        child: Column(
          children: [
            const Spacer(flex: 2),

            // Logo Card
            Card(
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(20),
              ),
              elevation: 4,
              child: Padding(
                padding: EdgeInsets.all(mq.width * 0.025),
                child: Image.asset(
                  'assets/images/logo.png',
                  width: mq.width * 0.45,
                ),
              ),
            ),

            const Spacer(),

            // Lottie Loading Animation
            const CustomLoading(),

            const Spacer(),
          ],
        ),
      ),
    );
  }
}
