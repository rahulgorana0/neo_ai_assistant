import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../widget/custom_loading.dart';

class MyDialog {
  static void _showSnackbar(String title, String msg, Color bgColor) {
    Get.snackbar(
      title,
      msg,
      backgroundColor: bgColor.withOpacity(0.7),
      colorText: Colors.white,
    );
  }

  /// Show Info Snackbar
  static void info(String msg) => _showSnackbar('Info', msg, Colors.blue);

  /// Show Success Snackbar
  static void success(String msg) => _showSnackbar('Success', msg, Colors.green);

  /// Show Error Snackbar
  static void error(String msg) => _showSnackbar('Error', msg, Colors.redAccent);

  /// Show Loading Dialog
  static void showLoadingDialog() {
    Get.dialog(
      const Center(child: CustomLoading()),
      barrierDismissible: false, // Prevents accidental dismissals
    );
  }
}
