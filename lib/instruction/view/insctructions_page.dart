import 'package:flutter/material.dart';
import 'package:wordle/game/view/widgets/language_button.dart';

class InstructionsView extends StatelessWidget {
  const InstructionsView({
    super.key,
    required this.activeLang,
    this.showGerman = false,
  });

  final Language activeLang;
  final bool showGerman;

  TextStyle get baseStyle => const TextStyle(
        fontSize: 22,
        fontWeight: FontWeight.normal,
      );

  TextStyle get boldStyle => baseStyle.copyWith(
        fontWeight: FontWeight.bold,
        fontSize: 22,
      );

  TextStyle get baseGerman => baseStyle.copyWith(fontSize: 20);
  TextStyle get boldGerman => boldStyle.copyWith(fontSize: 20);

  int get wordLength => activeLang == Language.german ? 6 : 5;

  String get exampleWords => activeLang == Language.german
      ? 'NEHMEN, LAUFEN, BOSENS '
      : activeLang == Language.czech
          ? 'SOSÁK, RYTÍŘ, OCHOZ'
          : activeLang == Language.english
              ? 'TENIS, TABLE, CHAIR'
              : '';

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(12, 16, 12, 16),
      child: Column(
        children: [
          Text.rich(
            TextSpan(
              children: [
                const TextSpan(
                  text: 'Pravidla',
                  style: TextStyle(
                    fontSize: 44,
                    fontWeight: FontWeight.w500,
                  ),
                ),
                if (showGerman)
                  const TextSpan(
                    text: ' (Regeln)',
                    style: TextStyle(
                      fontSize: 44,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
              ],
            ),
          ),

          const SizedBox(height: 24),

          Text(
            'Hádáte podstatné jméno $wordLength znaků dlouhé, které hra zná. Např.',
            maxLines: 4,
            style: baseStyle,
          ),
          const SizedBox(height: 8),
          Text.rich(
            TextSpan(
              children: [
                TextSpan(text: '$exampleWords, ', style: boldStyle),
                TextSpan(
                  text: 'apod.',
                  style: baseStyle,
                ),
              ],
            ),
          ),

          if (showGerman)
            Column(
              children: [
                const SizedBox(height: 8),
                Text(
                  '(Sie erraten ein Wort mit $wordLength Buchstaben. Zum Beispiel.',
                  style: baseGerman,
                ),
                const SizedBox(height: 8),
                Text.rich(
                  TextSpan(
                    children: [
                      TextSpan(text: '$exampleWords ', style: boldStyle),
                      TextSpan(text: 'usw.)', style: baseGerman),
                    ],
                  ),
                ),
              ],
            ),
          const SizedBox(height: 12),
          Text(
            'Postupně zadávejte své tipy.',
            style: baseStyle,
          ),
          if (showGerman)
            Column(
              children: [
                const SizedBox(height: 8),
                Text(
                  '(Sie versuchen, Ihre Tipps nacheinander einzugeben.)',
                  style: baseGerman,
                ),
              ],
            ),
          const SizedBox(height: 8),

//           FittedBox(
//             fit: BoxFit.scaleDown,
//             child: Row(
//               mainAxisAlignment: MainAxisAlignment.center,
//               children: [
//                 Text('Musí to být vždy ', style: baseStyle),
//                 Text('podstatáné jméno ', style: boldStyle),
//                 Text('(které hra zná)', style: baseStyle),
//               ],
//             ),
//           ),
//           const SizedBox(height: 8),
//           FittedBox(
//             fit: BoxFit.scaleDown,
//             child: Text('dlouhé $wordLength písmen', style: baseStyle),
//           ),
//           if (showGerman)
//             Column(
//               children: [
//                 const SizedBox(height: 8),
//                 FittedBox(
//                   fit: BoxFit.scaleDown,
//                   child: Row(
//                     mainAxisAlignment: MainAxisAlignment.center,
//                     children: [
//                       Text('(Es muss immer ein ', style: baseGerman),
//                       Text('Substantiv sein, ', style: boldGerman),
//                       Text('das das Spiel markiert)', style: baseGerman),
//                     ],
//                   ),
//                 ),
//                 const SizedBox(height: 8),
//                 FittedBox(
//                   fit: BoxFit.scaleDown,
//                   child:
//                       Text('lange $wordLength Buchstaben', style: baseGerman),
//                 ),
//               ],
//             ),
//           const SizedBox(height: 8),
          Text.rich(
            TextSpan(
              children: [
                TextSpan(text: 'Mazat můžete klávesou ', style: baseStyle),
                TextSpan(
                  text: 'Backspace (⌫) ',
                  style: boldStyle,
                ),
              ],
            ),
          ),

          const SizedBox(height: 4),
          if (showGerman)
            Text.rich(
              TextSpan(
                children: [
                  TextSpan(text: '(Sie können mit der ', style: baseGerman),
                  TextSpan(
                    text: 'Rückschritttaste (⌫)',
                    style: boldGerman,
                  ),
                  TextSpan(
                    text: ' löschen',
                    style: baseGerman,
                  ),
                ],
              ),
            ),
          const SizedBox(height: 4),
          Text.rich(
            TextSpan(
              children: [
                TextSpan(text: 'Tipy potvrzujte klávesou ', style: baseStyle),
                TextSpan(
                  text: 'Enter (⏎) ',
                  style: boldStyle,
                ),
              ],
            ),
          ),
          const SizedBox(height: 4),
          Text('Hra každý tip vyhodnotí a označí:', style: baseStyle),
          if (showGerman)
            Column(
              children: [
                const SizedBox(height: 8),
                Text.rich(
                  TextSpan(
                    children: [
                      TextSpan(
                          text: '(Bestätigen Sie mit der Taste ',
                          style: baseGerman),
                      TextSpan(
                        text: 'Enter (⏎) ',
                        style: boldGerman,
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  'und das Spiel markiert dieses Wort)',
                  style: baseGerman,
                ),
              ],
            ),
          const SizedBox(height: 12),
          Text.rich(
            TextSpan(
              children: [
                TextSpan(
                    text: 'Pokud písmena v hledaném slově ', style: baseStyle),
                TextSpan(
                  text: 'nejsou:',
                  style: boldStyle,
                ),
              ],
            ),
          ),

          if (showGerman)
            Column(
              children: [
                const SizedBox(height: 8),
                Text.rich(
                  TextSpan(
                    children: [
                      TextSpan(
                          text: '(Wenn die Buchstaben des Suchworts ',
                          style: baseGerman),
                      TextSpan(
                        text: 'night:)',
                        style: boldGerman,
                      ),
                    ],
                  ),
                ),
              ],
            ),
          const SizedBox(height: 8),
          Image.asset('packages/wordle/assets/wrong_$activeLang.png'),
          const SizedBox(height: 18),
          Text('Písmena v hledaném slově ', style: baseStyle),
          Text.rich(
            TextSpan(
              children: [
                TextSpan(text: 'jsou, ', style: baseStyle),
                TextSpan(
                  text: 'ale na jiné pozici:',
                  style: boldStyle,
                ),
              ],
            ),
          ),
          if (showGerman)
            Column(
              children: [
                const SizedBox(height: 8),
                FittedBox(
                  fit: BoxFit.scaleDown,
                  child: Text(
                    '(Die im Suchwort enthaltenen Buchstaben,',
                    style: baseStyle,
                  ),
                ),
                Text.rich(
                  TextSpan(
                    children: [
                      TextSpan(text: 'aber Raupen ', style: baseGerman),
                      TextSpan(
                        text: 'in der falschen Position:)',
                        style: boldGerman,
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
                TextSpan(text: 'Písmena ležící ', style: baseStyle),
                TextSpan(
                  text: 'na správné pozici:',
                  style: boldStyle,
                ),
              ],
            ),
          ),
          if (showGerman)
            Column(
              children: [
                const SizedBox(height: 8),
                Text.rich(
                  TextSpan(
                    children: [
                      TextSpan(
                          text: '(Der Buchstabe klettert ', style: baseGerman),
                      TextSpan(
                        text: 'an der richtigen Stelle:)',
                        style: boldGerman,
                      ),
                    ],
                  ),
                ),
              ],
            ),
          const SizedBox(height: 8),
          Image.asset('packages/wordle/assets/correct_$activeLang.png'),
          const SizedBox(height: 18),
          Text('Uhádnuté slovo:', style: baseStyle),
          if (showGerman)
            Column(
              children: [
                const SizedBox(height: 8),
                Text('(Ein erratenes Wort:)', style: baseGerman),
              ],
            ),
          const SizedBox(height: 8),
          Image.asset('packages/wordle/assets/win_$activeLang.png'),
          const SizedBox(height: 12),
          Text('Máte 6 pokusů.', style: baseStyle),
          if (showGerman)
            Column(
              children: [
                const SizedBox(height: 8),
                Text('(Du hast sechs Versuche.)', style: baseGerman),
              ],
            ),
          // const SizedBox(height: 24),
          // FittedBox(
          //   fit: BoxFit.scaleDown,
          //   child:
          //       Text('Zpracoval Kvalitní digičas, z.s. ', style: baseStyle),
          // ),
          // if (showGerman)
          //   Column(
          //     children: [
          //       const SizedBox(height: 4),
          //       FittedBox(
          //         fit: BoxFit.scaleDown,
          //         child: Text(
          //           'Produziert von Kvalitní digičas, z.s. ',
          //           style: baseGerman,
          //         ),
          //       ),

          //     ],
          //   ),
          // const SizedBox(height: 4),
          // Text('www.edukids.cz', style: baseStyle),
        ],
      ),
    );
  }
}
