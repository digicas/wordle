library wordle;

import 'package:flutter/material.dart';
import 'package:flutter_localization/flutter_localization.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:wordle/app_locale.dart';
import 'package:wordle/game/view/game_page.dart';
import 'package:wordle/game/view/widgets/language_button.dart';

class WordleGame extends StatefulWidget {
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
  State<WordleGame> createState() => _WordleGameState();
}

class _WordleGameState extends State<WordleGame> {
  final FlutterLocalization _localization = FlutterLocalization.instance;

  @override
  void initState() {
    _localization
      ..init(
        mapLocales: [
          const MapLocale(
            'cs',
            AppLocale.CS,
            countryCode: 'CS',
          ),
          const MapLocale(
            'en',
            AppLocale.EN,
            countryCode: 'US',
          ),
          const MapLocale(
            'de',
            AppLocale.DE,
            countryCode: 'DE',
          ),
        ],
        initLanguageCode: widget.langs.first,
      )
      ..onTranslatedLanguage = _onTranslatedLanguage;

    super.initState();
  }

  void _onTranslatedLanguage(Locale? locale) {
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: _buildTheme(Brightness.light),
      debugShowCheckedModeBanner: false,
      supportedLocales: _localization.supportedLocales,
      localizationsDelegates: _localization.localizationsDelegates,
      home: GameScreen(
        activeLangs: widget.langs.map(Language.fromCode).toList(),
        onLevelStarted: widget.onLevelStarted,
        onFinished: widget.onFinished,
        menuImage: widget.menuImage,
        langsWithHints: widget.langsWithHints.map(Language.fromCode).toList(),
        showTranslation: widget.showTranslation,
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
