import 'dart:developer';
import 'dart:io';
import 'package:dart_openai/dart_openai.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'package:path_provider/path_provider.dart';
import 'package:share_plus/share_plus.dart';

import '../apis/apis.dart';
import '../helper/global.dart';
import '../helper/my_dialog.dart';

enum Status { none, loading, complete }

class ImageController extends GetxController {
  final textC = TextEditingController();
  final status = Status.none.obs;
  final url = ''.obs;
  final imageList = <String>[].obs;

  Future<void> createAIImage() async {
    final prompt = textC.text.trim();
    if (prompt.isEmpty) {
      MyDialog.info('Provide some beautiful image description!');
      return;
    }

    try {
      OpenAI.apiKey = apiKey; // Consider storing securely
      status.value = Status.loading;

      final image = await OpenAI.instance.image.create(
        prompt: prompt,
        n: 1,
        size: OpenAIImageSize.size512,
        responseFormat: OpenAIImageResponseFormat.url,
      );

      if (image.data.isNotEmpty) {
        url.value = image.data.first.url.toString();
        status.value = Status.complete;
      } else {
        MyDialog.error('Failed to generate an image. Try again later.');
        status.value = Status.none;
      }
    } catch (e) {
      log('createAIImage error: $e');
      MyDialog.error('Something went wrong. Please try again later.');
      status.value = Status.none;
    }
  }

  Future<void> downloadImage() async {
    if (url.value.isEmpty) {
      MyDialog.error('No image URL found!');
      return;
    }

    try {
      MyDialog.showLoadingDialog(); // Ensure it is awaited

      final response = await http.get(Uri.parse(url.value));
      final bytes = response.bodyBytes;
      final dir = await getTemporaryDirectory();
      final file = File('${dir.path}/ai_image.png');
      await file.writeAsBytes(bytes);

      await Share.shareXFiles([XFile(file.path)], text: 'AI Image');

      MyDialog.success('Image Downloaded and Shared!');
    } catch (e) {
      log('downloadImage error: $e');
      MyDialog.error('Something Went Wrong: $e');
    } finally {
      Get.back();
    }
  }

  Future<void> shareImage() async {
    if (url.value.isEmpty) {
      MyDialog.error('No image URL found to share!');
      return;
    }

    try {
      MyDialog.showLoadingDialog();

      final response = await http.get(Uri.parse(url.value));
      final bytes = response.bodyBytes;
      final dir = await getTemporaryDirectory();
      final file = await File('${dir.path}/ai_image.png').writeAsBytes(bytes);

      await Share.shareXFiles([XFile(file.path)],
          text: 'Check out this Amazing Image created by AI Assistant App!');

      MyDialog.success('Image shared successfully!');
    } catch (e) {
      log('shareImage error: $e');
      MyDialog.error('Something Went Wrong (Try again later)!');
    } finally {
      Get.back();
    }
  }

  Future<void> searchAiImage() async {
    final prompt = textC.text.trim();
    if (prompt.isEmpty) {
      MyDialog.info('Provide some beautiful image description!');
      return;
    }

    status.value = Status.loading;

    try {
      final images = await APIs.generateGeminiImages(prompt);
      if (images.isEmpty) {
        MyDialog.error('No images found. Try again later.');
        status.value = Status.none;
        return;
      }

      imageList.value = images;
      url.value = imageList.first;
      status.value = Status.complete;
    } catch (e) {
      log('searchAiImage error: $e');
      MyDialog.error('Error fetching AI images. Try again later.');
      status.value = Status.none;
    }
  }
}
