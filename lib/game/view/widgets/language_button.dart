import 'package:flutter/material.dart';
import 'package:wordle/game/view/game_page.dart';

class LanguageButton extends StatelessWidget {
  const LanguageButton({
    super.key,
    required this.activeLangs,
    required this.selectedLang,
    required this.onChangeLang,
  });

  final List<Language> activeLangs;
  final Language selectedLang;
  final void Function(Language) onChangeLang;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => onChangeLang(
        selectedLang.nextLanguge(),
      ),
      child: Container(
        padding: const EdgeInsets.all(4),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(8),
          color: const Color(0xffC4C4C4),
        ),
        child: Text(
          '$selectedLang'.toUpperCase(),
          style: const TextStyle(
            fontSize: 18,
            color: Colors.white,
          ),
        ),
      ),
    );
  }
}

enum Language {
  german('de'),
  czech('cs'),
  english('en');

  const Language(this.code);

  factory Language.fromCode(String code) {
    if (code == 'cs') return Language.czech;
    if (code == 'en') return Language.english;
    return Language.german;
  }

  final String code;

  Language nextLanguge() {
    var index = GameScreen.activeLangs.indexOf(this) + 1;
    index = index >= allLangs.length ? 0 : index;
    return allLangs.elementAt(index);
  }

  List<Language> get allLangs => Language.values;

  @override
  String toString() {
    return code;
  }
}
