import 'package:flutter/material.dart';
import 'package:wordle/game/view/widgets/language_button.dart';

class InstructionsView extends StatelessWidget {
  const InstructionsView({
    super.key,
    required this.activeLang,
  });

  final Language activeLang;

  TextStyle get baseStyle => const TextStyle(
        fontSize: 22,
        fontWeight: FontWeight.normal,
      );

  TextStyle get boldStyle => baseStyle.copyWith(
        fontWeight: FontWeight.bold,
        fontSize: 22,
      );

  TextStyle get baseTranslation => baseStyle.copyWith(fontSize: 20);
  TextStyle get boldTranslation => boldStyle.copyWith(fontSize: 20);

  int get wordLength => activeLang == Language.german ? 6 : 5;

  bool get showTranslation =>
      activeLang.code == 'de' || activeLang.code == 'en';

  String get exampleWords => activeLang == Language.german
      ? 'NEHMEN, LAUFEN, BOSENS '
      : activeLang == Language.czech
          ? 'SOSÁK, RYTÍŘ, OCHOZ'
          : activeLang == Language.english
              ? 'TENIS, TABLE, CHAIR'
              : '';

  Map<String, Map<String, String>> get translations  => {
    'cs': {
      'rules': 'Pravidla',
      'info': 'Hádáte podstatné jméno 5 znaků dlouhé, které hra zná. Např.',
      'etc': 'apod.',
      'guess': 'Postupně zadávejte své tipy.',
      'undo': 'Mazat můžete klávesou ',
      'undoKey': 'Backspace (⌫) ',
      'submit': 'Tipy potvrzujte klávesou ',
      'submitKey': 'Enter (⏎) ',
      'how': 'Hra každý tip vyhodnotí a označí:',
      'wrong': 'Pokud písmena v hledaném slově ',
      'wrongValue': 'nejsou: ',
      'index': 'Písmena v hledaném slově ',
      'indexValue': 'jsou, ',
      'indexValue2': 'ale na jiné pozici:',
      'correct': 'Písmena ležící ',
      'correctValue': 'na správné pozici:',
      'word': 'Uhádnuté slovo:',
      'tries': 'Máte 6 pokusů.',
    },
    'de': {
      'rules': ' (Regeln)',
      'info': '(Sie erraten ein Wort mit 6 Buchstaben. Zum Beispiel.',
      'etc': 'usw.)',
      'guess': '(Sie versuchen, Ihre Tipps nacheinander einzugeben.)',
      'undo': '(Sie können mit der  ',
      'undoKey': 'Rückschritttaste (⌫) löschen)',
      'submit': '(Bestätigen Sie mit der Taste ',
      'submitKey': 'Enter (⏎) ',
      'how': 'und das Spiel markiert dieses Wort)',
      'wrong': '(Wenn die Buchstaben des Suchworts ',
      'wrongValue': 'nicht:) ',
      'index': '(Die im Suchwort enthaltenen Buchstaben,',
      'indexValue': 'aber Raupen ',
      'indexValue2': 'in der falschen Position:)',
      'correct': '(Der Buchstabe klettert ',
      'correctValue': 'an der richtigen Stelle:)',
      'word': '(Ein erratenes Wort:)',
      'tries': '(Du hast 6 Versuche.)',
    },
    'en': {
      'rules': '(Rules)',
      'info':
          '(You guess a noun 5 characters long that the game knows. For example.',
      'etc': 'etc.)',
      'guess': '(Enter your tips one by one.)',
      'undo': '(You can delete by pressing ',
      'undoKey': 'Backspace (⌫) )',
      'submit': '(Confirm your picks with the key ',
      'submitKey': 'Enter (⏎) ',
      'how': 'The game evaluates and marks each guess: )',
      'wrong': '(If the letters in the guess word ',
      'wrongValue': 'are not:)',
      'index': '(Letters in the guess word ',
      'indexValue': 'are ',
      'indexValue2': 'but in a different position:)',
      'correct': '(Letters are ',
      'correctValue': 'on a correct position:',
      'word': '(Guessed Word:)',
      'tries': '(You have 6 tries.)',
    }
  };

  String translate(String key, [String? lang]) {
    return translations[lang ?? 'cs']![key] ?? '';
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(12, 16, 12, 16),
      child: Column(
        children: [
          Text.rich(
            TextSpan(
              children: [
                TextSpan(
                  text: translate('rules'),
                  style: const TextStyle(
                    fontSize: 44,
                    fontWeight: FontWeight.w500,
                  ),
                ),
                if (showTranslation)
                  TextSpan(
                    text: translate('rules', activeLang.code),
                    style: const TextStyle(
                      fontSize: 44,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
              ],
            ),
          ),
          const SizedBox(height: 24),
          Text(
            translate('info'),
            maxLines: 4,
            style: baseStyle,
          ),
          const SizedBox(height: 8),
          Text.rich(
            TextSpan(
              children: [
                TextSpan(text: '$exampleWords, ', style: boldStyle),
                TextSpan(
                  text: translate('etc'),
                  style: baseStyle,
                ),
              ],
            ),
          ),
          if (showTranslation)
            Column(
              children: [
                const SizedBox(height: 8),
                Text(
                  translate('info', activeLang.code),
                  style: baseTranslation,
                ),
                const SizedBox(height: 8),
                Text.rich(
                  TextSpan(
                    children: [
                      TextSpan(text: '$exampleWords ', style: boldStyle),
                      TextSpan(
                        text: translate('etc', activeLang.code),
                        style: baseTranslation,
                      ),
                    ],
                  ),
                ),
              ],
            ),
          const SizedBox(height: 12),
          Text(
            translate('guess'),
            style: baseStyle,
          ),
          if (showTranslation)
            Column(
              children: [
                const SizedBox(height: 8),
                Text(
                  translate('guess', activeLang.code),
                  style: baseTranslation,
                ),
              ],
            ),
          const SizedBox(height: 8),
          Text.rich(
            TextSpan(
              children: [
                TextSpan(text: translate('undo'), style: baseStyle),
                TextSpan(
                  text: translate('undoKey'),
                  style: boldStyle,
                ),
              ],
            ),
          ),
          const SizedBox(height: 4),
          if (showTranslation)
            Text.rich(
              TextSpan(
                children: [
                  TextSpan(
                      text: translate('undo', activeLang.code),
                      style: baseTranslation),
                  TextSpan(
                    text: translate('undoKey', activeLang.code),
                    style: boldTranslation,
                  ),
                ],
              ),
            ),
          const SizedBox(height: 4),
          Text.rich(
            TextSpan(
              children: [
                TextSpan(text: translate('submit'), style: baseStyle),
                TextSpan(
                  text: translate('submitKey'),
                  style: boldStyle,
                ),
              ],
            ),
          ),
          const SizedBox(height: 4),
          Text(translate('how'), style: baseStyle),
          if (showTranslation)
            Column(
              children: [
                const SizedBox(height: 8),
                Text.rich(
                  TextSpan(
                    children: [
                      TextSpan(
                        text: translate('submit', activeLang.code),
                        style: baseTranslation,
                      ),
                      TextSpan(
                        text: translate('submitKey', activeLang.code),
                        style: boldTranslation,
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  translate('how', activeLang.code),
                  style: baseTranslation,
                ),
              ],
            ),
          const SizedBox(height: 12),
          Text.rich(
            TextSpan(
              children: [
                TextSpan(
                  text: translate('wrong'),
                  style: baseStyle,
                ),
                TextSpan(
                  text: translate('wrongValue'),
                  style: boldStyle,
                ),
              ],
            ),
          ),
          if (showTranslation)
            Column(
              children: [
                const SizedBox(height: 8),
                Text.rich(
                  TextSpan(
                    children: [
                      TextSpan(
                        text: translate('wrong', activeLang.code),
                        style: baseTranslation,
                      ),
                      TextSpan(
                        text: translate('wrongValue', activeLang.code),
                        style: boldTranslation,
                      ),
                    ],
                  ),
                ),
              ],
            ),
          const SizedBox(height: 8),
          Image.asset('packages/wordle/assets/wrong_$activeLang.png'),
          const SizedBox(height: 18),
          Text(translate('index'), style: baseStyle),
          Text.rich(
            TextSpan(
              children: [
                TextSpan(text: translate('indexValue'), style: baseStyle),
                TextSpan(
                  text: translate('indexValue2'),
                  style: boldStyle,
                ),
              ],
            ),
          ),
          if (showTranslation)
            Column(
              children: [
                const SizedBox(height: 8),
                FittedBox(
                  fit: BoxFit.scaleDown,
                  child: Text(
                    translate('index', activeLang.code),
                    style: baseStyle,
                  ),
                ),
                Text.rich(
                  TextSpan(
                    children: [
                      TextSpan(
                        text: translate('indexValue', activeLang.code),
                        style: baseTranslation,
                      ),
                      TextSpan(
                        text: translate('indexValue2', activeLang.code),
                        style: boldTranslation,
                      ),
                    ],
                  ),
                ),
              ],
            ),
          const SizedBox(height: 8),
          Image.asset('packages/wordle/assets/wrong_index_$activeLang.png'),
          const SizedBox(height: 18),
          Text.rich(
            TextSpan(
              children: [
                TextSpan(text: translate('correct'), style: baseStyle),
                TextSpan(
                  text: translate('correctValue'),
                  style: boldStyle,
                ),
              ],
            ),
          ),
          if (showTranslation)
            Column(
              children: [
                const SizedBox(height: 8),
                Text.rich(
                  TextSpan(
                    children: [
                      TextSpan(
                        text: translate('correct', activeLang.code),
                        style: baseTranslation,
                      ),
                      TextSpan(
                        text: translate('correctValue', activeLang.code),
                        style: boldTranslation,
                      ),
                    ],
                  ),
                ),
              ],
            ),
          const SizedBox(height: 8),
          Image.asset('packages/wordle/assets/correct_$activeLang.png'),
          const SizedBox(height: 18),
          Text(translate('word'), style: baseStyle),
          if (showTranslation)
            Column(
              children: [
                const SizedBox(height: 8),
                Text(translate('word', activeLang.code), style: baseTranslation),
              ],
            ),
          const SizedBox(height: 8),
          Image.asset('packages/wordle/assets/win_$activeLang.png'),
          const SizedBox(height: 12),
          Text(translate('tries'), style: baseStyle),
          if (showTranslation)
            Column(
              children: [
                const SizedBox(height: 8),
                Text(translate('tries', activeLang.code), style: baseTranslation),
              ],
            ),
        ],
      ),
    );
  }
}
