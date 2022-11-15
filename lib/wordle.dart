library wordle;

import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:wordle/game/view/game_page.dart';
import 'package:wordle/instruction/view/insctructions_page.dart';

class WordleGame extends StatelessWidget {
  WordleGame({super.key, required this.langs}) {
    GameScreen.setActiveLanguagesFromCodes(langs);
  }
  final List<String> langs;

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: _buildTheme(Brightness.light),
      debugShowCheckedModeBanner: false,
      home: const InstructionsPage(),
      routes: {
        '/game': (_) => const GameScreen(),
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
