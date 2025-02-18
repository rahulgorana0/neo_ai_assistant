import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_tts/flutter_tts.dart';
import 'package:speech_to_text/speech_to_text.dart' as stt;
import 'package:get/get.dart';

import '../../controller/translate_controller.dart';
import '../../widget/custom_btn.dart';
import '../../widget/language_sheet.dart';

class TranslatorFeature extends StatefulWidget {
  const TranslatorFeature({super.key});

  @override
  State<TranslatorFeature> createState() => _TranslatorFeatureState();
}

class _TranslatorFeatureState extends State<TranslatorFeature> {
  final TranslateController _c = TranslateController();
  late Size mq;
  final FlutterTts _flutterTts = FlutterTts();
  final stt.SpeechToText _speech = stt.SpeechToText();

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    mq = MediaQuery.of(context).size;
  }

  /// Speak text in the selected language
  Future<void> _speak(String text, String languageCode) async {
    if (text.trim().isNotEmpty) {
      try {
        await _flutterTts.setLanguage(languageCode);
        await _flutterTts.setPitch(1.0);
        await _flutterTts.speak(text);
      } catch (e) {
        debugPrint('TTS Error: $e');
      }
    }
  }

  /// Start Speech-to-Text for input
  Future<void> _startListening() async {
    if (await _speech.initialize()) {
      _speech.listen(
        onResult: (result) {
          _c.textC.text = result.recognizedWords;
          setState(() {});
        },
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Multi-Language Translator')),
      body: ListView(
        physics: const BouncingScrollPhysics(),
        padding: EdgeInsets.only(top: mq.height * 0.02, bottom: mq.height * 0.1),
        children: [
          _languageSelectionRow(),
          const SizedBox(height: 20),
          _inputTextField(),
          const SizedBox(height: 20),
          _translateResult(),
          const SizedBox(height: 20),
          CustomBtn(onTap: _c.googleTranslate, text: 'Translate'),
          const SizedBox(height: 10),
          Center(
            child: FloatingActionButton(
              onPressed: _startListening,
              backgroundColor: Colors.blue,
              child: const Icon(Icons.mic, color: Colors.white),
            ),
          ),
        ],
      ),
    );
  }

  /// Language Selection Row
  Widget _languageSelectionRow() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        _languageSelector('Auto', _c.from),
        IconButton(
          onPressed: _c.swapLanguages,
          icon: Obx(() => Icon(
                CupertinoIcons.repeat,
                color: (_c.to.value.isNotEmpty && _c.from.value.isNotEmpty)
                    ? Colors.blue
                    : Colors.grey,
              )),
        ),
        _languageSelector('To', _c.to),
      ],
    );
  }

  /// Language Selector Widget
  Widget _languageSelector(String defaultText, RxString selectedLanguage) {
    return InkWell(
      onTap: () => Get.bottomSheet(LanguageSheet(c: _c, s: selectedLanguage)),
      borderRadius: BorderRadius.circular(15),
      child: Container(
        height: 50,
        width: mq.width * 0.4,
        alignment: Alignment.center,
        decoration: BoxDecoration(
          border: Border.all(color: Colors.blue),
          borderRadius: BorderRadius.circular(15),
        ),
        child: Obx(() => Text(selectedLanguage.value.isEmpty ? defaultText : selectedLanguage.value)),
      ),
    );
  }

  /// Input Text Field (Translate From)
  Widget _inputTextField() {
    return Row(
      children: [
        Expanded(
          child: Padding(
            padding: EdgeInsets.symmetric(horizontal: mq.width * 0.04),
            child: TextFormField(
              controller: _c.textC,
              minLines: 5,
              maxLines: null,
              onTapOutside: (_) => FocusScope.of(context).unfocus(),
              decoration: const InputDecoration(
                hintText: 'Translate anything you want...',
                hintStyle: TextStyle(fontSize: 13.5),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.all(Radius.circular(10)),
                ),
              ),
            ),
          ),
        ),
        IconButton(
          icon: const Icon(Icons.volume_up, color: Colors.blue),
          onPressed: () => _speak(_c.textC.text, _getLanguageCode(_c.from.value)),
        ),
      ],
    );
  }

  /// Translation Result Box
  Widget _translateResult() {
    return Row(
      children: [
        Expanded(
          child: Padding(
            padding: EdgeInsets.symmetric(horizontal: mq.width * 0.04),
            child: TextFormField(
              controller: _c.resultC,
              maxLines: null,
              onTapOutside: (_) => FocusScope.of(context).unfocus(),
              decoration: const InputDecoration(
                hintText: 'Translation will appear here...',
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.all(Radius.circular(10)),
                ),
              ),
            ),
          ),
        ),
        IconButton(
          icon: const Icon(Icons.volume_up, color: Colors.blue),
          onPressed: () => _speak(_c.resultC.text, _getLanguageCode(_c.to.value)),
        ),
      ],
    );
  }

  /// Convert Language Name to Language Code
  String _getLanguageCode(String language) {
    const Map<String, String> languageCodes = {
       'Afrikaans': 'af',
      'Albanian': 'sq',
      'Amharic': 'am',
      'Arabic': 'ar',
      'Armenian': 'hy',
      'Assamese': 'as',
      'Aymara': 'ay',
      'Azerbaijani': 'az',
      'Bambara': 'bm',
      'Basque': 'eu',
      'Belarusian': 'be',
      'Bengali': 'bn',
      'Bhojpuri': 'bho',
      'Bosnian': 'bs',
      'Bulgarian': 'bg',
      'Catalan': 'ca',
      'Cebuano': 'ceb',
      'Chinese (Simplified)': 'zh-cn',
      'Chinese (Traditional)': 'zh-tw',
      'Corsican': 'co',
      'Croatian': 'hr',
      'Czech': 'cs',
      'Danish': 'da',
      'Dhivehi': 'dv',
      'Dogri': 'doi',
      'Dutch': 'nl',
      'English': 'en',
      'Esperanto': 'eo',
      'Estonian': 'et',
      'Ewe': 'ee',
      'Filipino (Tagalog)': 'tl',
      'Finnish': 'fi',
      'French': 'fr',
      'Frisian': 'fy',
      'Galician': 'gl',
      'Georgian': 'ka',
      'German': 'de',
      'Greek': 'el',
      'Guarani': 'gn',
      'Gujarati': 'gu',
      'Haitian Creole': 'ht',
      'Hausa': 'ha',
      'Hawaiian': 'haw',
      'Hebrew': 'iw',
      'Hindi': 'hi',
      'Hmong': 'hmn',
      'Hungarian': 'hu',
      'Icelandic': 'is',
      'Igbo': 'ig',
      'Ilocano': 'ilo',
      'Indonesian': 'id',
      'Irish': 'ga',
      'Italian': 'it',
      'Japanese': 'ja',
      'Javanese': 'jw',
      'Kannada': 'kn',
      'Kazakh': 'kk',
      'Khmer': 'km',
      'Kinyarwanda': 'rw',
      'Konkani': 'gom',
      'Korean': 'ko',
      'Krio': 'kri',
      'Kurdish (Kurmanji)': 'ku',
      'Kurdish (Sorani)': 'ckb',
      'Kyrgyz': 'ky',
      'Lao': 'lo',
      'Latin': 'la',
      'Latvian': 'lv',
      'Lithuanian': 'lt',
      'Luganda': 'lg',
      'Luxembourgish': 'lb',
      'Macedonian': 'mk',
      'Malagasy': 'mg',
      'Maithili': 'mai',
      'Malay': 'ms',
      'Malayalam': 'ml',
      'Maltese': 'mt',
      'Maori': 'mi',
      'Marathi': 'mr',
      'Meiteilon (Manipuri)': 'mni-mtei',
      'Mizo': 'lus',
      'Mongolian': 'mn',
      'Myanmar (Burmese)': 'my',
      'Nepali': 'ne',
      'Norwegian': 'no',
      'Nyanja (Chichewa)': 'ny',
      'Odia (Oriya)': 'or',
      'Oromo': 'om',
      'Pashto': 'ps',
      'Persian': 'fa',
      'Polish': 'pl',
      'Portuguese': 'pt',
      'Punjabi': 'pa',
      'Quechua': 'qu',
      'Romanian': 'ro',
      'Russian': 'ru',
      'Samoan': 'sm',
      'Sanskrit': 'sa',
      'Scots Gaelic': 'gd',
      'Sepedi': 'nso',
      'Serbian': 'sr',
      'Sesotho': 'st',
      'Shona': 'sn',
      'Sindhi': 'sd',
      'Sinhala': 'si',
      'Slovak': 'sk',
      'Slovenian': 'sl',
      'Somali': 'so',
      'Spanish': 'es',
      'Sundanese': 'su',
      'Swahili': 'sw',
      'Swedish': 'sv',
      'Tajik': 'tg',
      'Tamil': 'ta',
      'Tatar': 'tt',
      'Telugu': 'te',
      'Thai': 'th',
      'Tigrinya': 'ti',
      'Tsonga': 'ts',
      'Turkish': 'tr',
      'Turkmen': 'tk',
      'Twi (Akan)': 'ak',
      'Ukrainian': 'uk',
      'Urdu': 'ur',
      'Uyghur': 'ug',
      'Uzbek': 'uz',
      'Vietnamese': 'vi',
      'Welsh': 'cy',
      'Xhosa': 'xh',
      'Yiddish': 'yi',
      'Yoruba': 'yo',
      'Zulu': 'zu'
    };

    return languageCodes[language] ?? "en"; // Default to English
  }
}
