import 'package:flutter_tts/flutter_tts.dart';

FlutterTts flutterTts = FlutterTts();

Future speak(String str) async {
  flutterTts.setLanguage("ko-KR");
  flutterTts.setPitch(0.85);
  print(await flutterTts.getVoices);
  await flutterTts.speak(str);
}
