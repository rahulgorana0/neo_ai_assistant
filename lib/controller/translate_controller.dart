import 'dart:convert';
import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:flutter_tts/flutter_tts.dart';
import 'package:speech_to_text/speech_to_text.dart' as stt;

import '../apis/apis.dart';
import '../helper/my_dialog.dart';
import 'image_controller.dart';

class TranslateController extends GetxController {
  final textC = TextEditingController();
  final resultC = TextEditingController();

  final from = ''.obs, to = ''.obs;
  final status = Status.none.obs;

  final FlutterTts tts = FlutterTts();
  final stt.SpeechToText speech = stt.SpeechToText();

  /// Initialize speech recognition only once
  Future<void> listen() async {
    if (!(await speech.initialize())) {
      MyDialog.info('Speech recognition not available!');
      return;
    }
    speech.listen(
      onResult: (result) => textC.text = result.recognizedWords,
    );
  }

  /// Speak translated text
  Future<void> speak() async {
    if (resultC.text.trim().isEmpty) {
      MyDialog.info('No translated text to speak!');
      return;
    }
    await tts.speak(resultC.text);
  }

  /// Handles AI-based translation
  Future<void> translate() async {
    if (textC.text.trim().isEmpty || to.isEmpty) {
      MyDialog.info(to.isEmpty ? 'Select To Language!' : 'Type Something to Translate!');
      return;
    }

    status.value = Status.loading;

    String prompt = from.isNotEmpty
        ? 'Can you translate given text from ${from.value} to ${to.value}:\n${textC.text}'
        : 'Can you translate given text to ${to.value}:\n${textC.text}';

    log(prompt);

    final res = await APIs.getAnswer(prompt);
    resultC.text = utf8.decode(res.codeUnits);

    status.value = Status.complete;
  }

  void swapLanguages() {
    if (to.isNotEmpty && from.isNotEmpty) {
      final temp = from.value;
      from.value = to.value;
      to.value = temp;
    }
  }

  /// Uses Google Translate API for translation
  Future<void> googleTranslate() async {
    if (textC.text.trim().isEmpty || to.isEmpty) {
      MyDialog.info(to.isEmpty ? 'Select To Language!' : 'Type Something to Translate!');
      return;
    }

    status.value = Status.loading;
    
    resultC.text = await APIs.googleTranslate(
      from: jsonLang[from.value] ?? 'auto',
      to: jsonLang[to.value] ?? 'en',
      text: textC.text,
    );

    status.value = Status.complete;
  }

  /// Language mapping
  late final lang = jsonLang.keys.toList();
  static const jsonLang = {
    'Afrikaans': 'af', 'Albanian': 'sq', 'Amharic': 'am', 'Arabic': 'ar', 'Armenian': 'hy',
    'Assamese': 'as', 'Aymara': 'ay', 'Azerbaijani': 'az', 'Bambara': 'bm', 'Basque': 'eu',
    'Belarusian': 'be', 'Bengali': 'bn', 'Bhojpuri': 'bho', 'Bosnian': 'bs', 'Bulgarian': 'bg',
    'Catalan': 'ca', 'Cebuano': 'ceb', 'Chinese (Simplified)': 'zh-cn', 'Chinese (Traditional)': 'zh-tw',
    'Corsican': 'co', 'Croatian': 'hr', 'Czech': 'cs', 'Danish': 'da', 'Dhivehi': 'dv', 'Dogri': 'doi',
    'Dutch': 'nl', 'English': 'en', 'Esperanto': 'eo', 'Estonian': 'et', 'Ewe': 'ee', 'Filipino (Tagalog)': 'tl',
    'Finnish': 'fi', 'French': 'fr', 'Frisian': 'fy', 'Galician': 'gl', 'Georgian': 'ka', 'German': 'de',
    'Greek': 'el', 'Guarani': 'gn', 'Gujarati': 'gu', 'Haitian Creole': 'ht', 'Hausa': 'ha', 'Hawaiian': 'haw',
    'Hebrew': 'iw', 'Hindi': 'hi', 'Hmong': 'hmn', 'Hungarian': 'hu', 'Icelandic': 'is', 'Igbo': 'ig',
    'Ilocano': 'ilo', 'Indonesian': 'id', 'Irish': 'ga', 'Italian': 'it', 'Japanese': 'ja', 'Javanese': 'jw',
    'Kannada': 'kn', 'Kazakh': 'kk', 'Khmer': 'km', 'Kinyarwanda': 'rw', 'Konkani': 'gom', 'Korean': 'ko',
    'Krio': 'kri', 'Kurdish (Kurmanji)': 'ku', 'Kurdish (Sorani)': 'ckb', 'Kyrgyz': 'ky', 'Lao': 'lo',
    'Latin': 'la', 'Latvian': 'lv', 'Lithuanian': 'lt', 'Luganda': 'lg', 'Luxembourgish': 'lb', 'Macedonian': 'mk',
    'Malagasy': 'mg', 'Maithili': 'mai', 'Malay': 'ms', 'Malayalam': 'ml', 'Maltese': 'mt', 'Maori': 'mi',
    'Marathi': 'mr', 'Meiteilon (Manipuri)': 'mni-mtei', 'Mizo': 'lus', 'Mongolian': 'mn', 'Myanmar (Burmese)': 'my',
    'Nepali': 'ne', 'Norwegian': 'no', 'Nyanja (Chichewa)': 'ny', 'Odia (Oriya)': 'or', 'Oromo': 'om', 'Pashto': 'ps',
    'Persian': 'fa', 'Polish': 'pl', 'Portuguese': 'pt', 'Punjabi': 'pa', 'Quechua': 'qu', 'Romanian': 'ro',
    'Russian': 'ru', 'Samoan': 'sm', 'Sanskrit': 'sa', 'Scots Gaelic': 'gd', 'Sepedi': 'nso', 'Serbian': 'sr',
    'Sesotho': 'st', 'Shona': 'sn', 'Sindhi': 'sd', 'Sinhala': 'si', 'Slovak': 'sk', 'Slovenian': 'sl',
    'Somali': 'so', 'Spanish': 'es', 'Sundanese': 'su', 'Swahili': 'sw', 'Swedish': 'sv', 'Tajik': 'tg',
    'Tamil': 'ta', 'Tatar': 'tt', 'Telugu': 'te', 'Thai': 'th', 'Tigrinya': 'ti', 'Tsonga': 'ts', 'Turkish': 'tr',
    'Turkmen': 'tk', 'Twi (Akan)': 'ak', 'Ukrainian': 'uk', 'Urdu': 'ur', 'Uyghur': 'ug', 'Uzbek': 'uz',
    'Vietnamese': 'vi', 'Welsh': 'cy', 'Xhosa': 'xh', 'Yiddish': 'yi', 'Yoruba': 'yo', 'Zulu': 'zu'
  };
}
