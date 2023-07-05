library wordle;

import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:wordle/game/view/game_page.dart';
import 'package:wordle/game/view/widgets/language_button.dart';

class WordleGame extends StatelessWidget {
  const WordleGame({
    super.key,
    required this.langs,
    required this.onFinished,
    required this.onLevelStarted,
    required this.menuImage,
    required this.langsWithHints,
    required this.showTranslation,
  });
  final List<String> langs;
  final List<String> langsWithHints;
  final void Function(int) onFinished;
  final void Function() onLevelStarted;
  final Image menuImage;
  final bool showTranslation;

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: _buildTheme(Brightness.light),
      debugShowCheckedModeBanner: false,
      home: GameScreen(
        activeLangs: langs.map(Language.fromCode).toList(),
        onLevelStarted: onLevelStarted,
        onFinished: onFinished,
        menuImage: menuImage,
        langsWithHints: langsWithHints.map(Language.fromCode).toList(),
        showTranslation: showTranslation,
      ),
    );
  }

  ThemeData _buildTheme(Brightness brightness) {
    final baseTheme = ThemeData(brightness: brightness);

    return baseTheme.copyWith(
      textTheme: GoogleFonts.latoTextTheme(baseTheme.textTheme),
    );
  }
}
