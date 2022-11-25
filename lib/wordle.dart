library wordle;

import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:wordle/game/view/game_page.dart';
import 'package:wordle/game/view/widgets/language_button.dart';
import 'package:wordle/instruction/view/insctructions_page.dart';

class WordleGame extends StatelessWidget {
  const WordleGame({
    super.key,
    required this.langs,
    required this.onFinished,
    required this.onLevelStarted,
  });
  final List<String> langs;
  final void Function(int) onFinished;
  final void Function() onLevelStarted;

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: _buildTheme(Brightness.light),
      debugShowCheckedModeBanner: false,
      home: const InstructionsPage(),
      routes: {
        '/game': (_) => GameScreen(
              activeLangs: langs.map(Language.fromCode).toList(),
              onLevelStarted: onLevelStarted,
              onFinished: onFinished,
            ),
      },
    );
  }

  ThemeData _buildTheme(Brightness brightness) {
    final baseTheme = ThemeData(brightness: brightness);

    return baseTheme.copyWith(
      textTheme: GoogleFonts.latoTextTheme(baseTheme.textTheme),
    );
  }
}
