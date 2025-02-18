import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:lottie/lottie.dart';
import 'package:neo_ai_assistant/widget/custom_btn.dart';

import '../model/onboard.dart';
import 'home_screen.dart';

class OnboardingScreen extends StatelessWidget {
  const OnboardingScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final PageController controller = PageController();

    final List<Onboard> onboardingList = [
      const Onboard(
          title: 'Ask me Anything',
          subtitle:
              'I can be your Best Friend & You can ask me anything & I will help you!',
          lottie: 'ai_ask_me'),
      const Onboard(
          title: 'Imagination to Reality',
          subtitle:
              'Just Imagine anything & let me know, I will create something wonderful for you!',
          lottie: 'ai_play'),
      const Onboard(
          title: 'Language Translation',
          subtitle:
              'Just think a sentence & let me know, I will translate to any language you want!',
          lottie: 'ai_translate'),
      const Onboard(
          title: 'Note Taking',
          subtitle: 'Easily take and manage your notes anytime.',
          lottie: 'ai_ask_me'),
      const Onboard(
          title: 'To-Do List',
          subtitle: 'Keep track of your daily tasks efficiently.',
          lottie: 'ai_play'),
      const Onboard(
          title: 'Habit Tracker',
          subtitle: 'Build and maintain good habits seamlessly.',
          lottie: 'ai_translate'),
    ];

    // Splitting onboarding into 2 pages (3 items per page)
    final List<List<Onboard>> pages = [
      onboardingList.sublist(0, 3),
      onboardingList.sublist(3, 6),
    ];

    return Scaffold(
      body: PageView.builder(
        controller: controller,
        itemCount: pages.length,
        itemBuilder: (context, index) {
          final bool isLastPage = index == pages.length - 1;

          return Column(
            children: [
              const SizedBox(height: 50),

              // Onboarding Cards
              Expanded(
                child: ListView.builder(
                  padding: const EdgeInsets.symmetric(horizontal: 20),
                  itemCount: pages[index].length,
                  itemBuilder: (context, i) {
                    final Onboard item = pages[index][i];
                    return Container(
                      margin: const EdgeInsets.symmetric(vertical: 15),
                      padding: const EdgeInsets.all(15),
                      decoration: BoxDecoration(
                        color: Colors.blueGrey[100],
                        borderRadius: BorderRadius.circular(15),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black.withOpacity(0.1),
                            blurRadius: 8,
                            spreadRadius: 2,
                          )
                        ],
                      ),
                      child: Row(
                        children: [
                          // Lottie Animation
                          Lottie.asset(
                            'assets/lottie/${item.lottie}.json',
                            height: 80,
                            width: 80,
                          ),
                          const SizedBox(width: 20),

                          // Text Content
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  item.title,
                                  style: const TextStyle(
                                      fontSize: 18,
                                      fontWeight: FontWeight.bold,
                                      color: Colors.black87),
                                ),
                                const SizedBox(height: 5),
                                Text(
                                  item.subtitle,
                                  style: const TextStyle(
                                      fontSize: 14,
                                      color: Colors.black54),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    );
                  },
                ),
              ),

              const SizedBox(height: 20),

              // Dots Indicator
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: List.generate(
                  pages.length,
                  (i) => AnimatedContainer(
                    duration: const Duration(milliseconds: 300),
                    margin: const EdgeInsets.symmetric(horizontal: 5),
                    width: i == index ? 15 : 10,
                    height: 8,
                    decoration: BoxDecoration(
                      color: i == index ? Colors.blue : Colors.grey,
                      borderRadius: BorderRadius.circular(5),
                    ),
                  ),
                ),
              ),

              const SizedBox(height: 25),

              // Next / Finish Button
              CustomBtn(
                onTap: () {
                  if (isLastPage) {
                    Get.off(() => const HomeScreen());
                  } else {
                    controller.nextPage(
                        duration: const Duration(milliseconds: 600),
                        curve: Curves.ease);
                  }
                },
                text: isLastPage ? 'Finish' : 'Next',
              ),

              const SizedBox(height: 40),
            ],
          );
        },
      ),
    );
  }
}
