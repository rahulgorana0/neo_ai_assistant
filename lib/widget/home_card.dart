import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';

import '../model/home_type.dart';

class HomeCard extends StatelessWidget {
  final HomeType homeType;

  const HomeCard({super.key, required this.homeType});

  @override
  Widget build(BuildContext context) {
    final Size screenSize = MediaQuery.of(context).size;

    return Card(
      color: Colors.blue.withOpacity(0.2),
      elevation: 0,
      margin: EdgeInsets.only(bottom: screenSize.height * 0.02),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(20),
      ),
      child: InkWell(
        borderRadius: BorderRadius.circular(20),
        onTap: homeType.onTap,
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 15),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: homeType.leftAlign
                ? _buildLeftAligned(screenSize)
                : _buildRightAligned(screenSize),
          ),
        ),
      ),
    );
  }

  List<Widget> _buildLeftAligned(Size screenSize) {
    return [
      _buildLottie(screenSize),
      Expanded(
        child: Text(
          homeType.title,
          textAlign: TextAlign.center,
          style: const TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.w500,
            letterSpacing: 1,
          ),
        ),
      ),
    ];
  }

  List<Widget> _buildRightAligned(Size screenSize) {
    return [
      Expanded(
        child: Text(
          homeType.title,
          textAlign: TextAlign.center,
          style: const TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.w500,
            letterSpacing: 1,
          ),
        ),
      ),
      _buildLottie(screenSize),
    ];
  }

  Widget _buildLottie(Size screenSize) {
    return Container(
      width: screenSize.width * 0.35,
      padding: homeType.padding,
      child: Lottie.asset(
        'assets/lottie/${homeType.lottie}',
        errorBuilder: (context, error, stackTrace) => const Icon(Icons.error, color: Colors.red),
      ),
    );
  }
}
