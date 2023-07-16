import 'package:flutter/material.dart';
import 'package:wordle/wordle.dart';

void main() {
  runApp(const WordleExampleApp());
}

class WordleExampleApp extends StatelessWidget {
  const WordleExampleApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      home: WordleGame(
        onFinished: (_) => print('FINISHED'),
        onLevelStarted: () => print('STARTED'),
        langsWithHints: const ['en', 'de'],
        langs: const ['cs', 'en', 'de'],
        showTranslation: true,
        menuImage: Image.network(
          'https://cdn-icons-png.flaticon.com/512/6780/6780485.png',
        ),
      ),
    );
  }
}
