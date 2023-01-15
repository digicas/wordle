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
          FittedBox(
            fit: BoxFit.scaleDown,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Text(
                  'Pravidla',
                  style: TextStyle(
                    fontSize: 44,
                    fontWeight: FontWeight.w500,
                  ),
                ),
                if (showGerman)
                  const Text(
                    '(Regeln)',
                    style: TextStyle(
                      fontSize: 44,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
              ],
            ),
          ),
          const SizedBox(height: 24),
          FittedBox(
            fit: BoxFit.scaleDown,
            child: Text(
              'Hádáte podstatné jméno $wordLength znaků dlouhé, které hra zná. Např.',
              style: baseStyle,
            ),
          ),
          const SizedBox(height: 8),
          FittedBox(
            fit: BoxFit.scaleDown,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text('$exampleWords, ', style: boldStyle),
                Text(
                  'apod.',
                  style: baseStyle,
                )
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
                    '(Sie erraten ein Wort mit $wordLength Buchstaben. Zum Beispiel.',
                    style: baseGerman,
                  ),
                ),
                const SizedBox(height: 8),
                FittedBox(
                  fit: BoxFit.scaleDown,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text('$exampleWords ', style: boldStyle),
                      Text(
                        'usw.)',
                        style: baseGerman,
                      )
                    ],
                  ),
                ),
              ],
            ),
          const SizedBox(height: 12),
          FittedBox(
            fit: BoxFit.scaleDown,
            child: Text(
              'Postupně zadávejte své tipy.',
              style: baseStyle,
            ),
          ),
          if (showGerman)
            Column(
              children: [
                const SizedBox(height: 8),
                FittedBox(
                  fit: BoxFit.scaleDown,
                  child: Text(
                    '(Sie versuchen, Ihre Tipps nacheinander einzugeben.)',
                    style: baseGerman,
                  ),
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
                    
          FittedBox(
            fit: BoxFit.scaleDown,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text('Tipy potvrzujte klávesou ', style: baseStyle),
                Text('Enter (⏎) ', style: boldStyle),
              ],
            ),
          ),
          const SizedBox(height: 4),
          FittedBox(
            fit: BoxFit.scaleDown,
            child: Text('Hra každý tip vyhodnotí a označí:', style: baseStyle),
          ),
          if (showGerman)
            Column(
              children: [
                const SizedBox(height: 8),
                FittedBox(
                  fit: BoxFit.scaleDown,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text('(Bestätigen Sie mit der Taste ', style: baseGerman),
                      Text('Enter (⏎) ', style: boldGerman),
                    ],
                  ),
                ),
                const SizedBox(height: 4),
                FittedBox(
                  fit: BoxFit.scaleDown,
                  child: Text(
                    'und das Spiel markiert dieses Wort)',
                    style: baseGerman,
                  ),
                ),
              ],
            ),
          const SizedBox(height: 12),
          FittedBox(
            fit: BoxFit.scaleDown,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text('Pokud písmena v hledaném slově ', style: baseStyle),
                Text('nejsou:', style: boldStyle),
              ],
            ),
          ),
          if (showGerman)
            Column(
              children: [
                const SizedBox(height: 8),
                FittedBox(
                  fit: BoxFit.scaleDown,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text('(Wenn die Buchstaben des Suchworts ',
                          style: baseGerman),
                      Text('night:)', style: boldGerman),
                    ],
                  ),
                ),
              ],
            ),
          const SizedBox(height: 8),
          Image.asset('packages/wordle/assets/wrong_$activeLang.png'),
          const SizedBox(height: 18),
          FittedBox(
            fit: BoxFit.scaleDown,
            child: Text('Písmena v hledaném slově ', style: baseStyle),
          ),
          FittedBox(
            fit: BoxFit.scaleDown,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text('jsou, ', style: baseStyle),
                Text('ale na jiné pozici:', style: boldStyle),
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
                FittedBox(
                  fit: BoxFit.scaleDown,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text('aber Raupen ', style: baseGerman),
                      Text('in der falschen Position:)', style: boldGerman),
                    ],
                  ),
                ),
              ],
            ),
          const SizedBox(height: 8),
          Image.asset('packages/wordle/assets/wrong_index_$activeLang.png'),
          const SizedBox(height: 18),
          FittedBox(
            fit: BoxFit.scaleDown,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text('Písmena ležící ', style: baseStyle),
                Text('na správné pozici:', style: boldStyle),
              ],
            ),
          ),
          if (showGerman)
            Column(
              children: [
                const SizedBox(height: 8),
                FittedBox(
                  fit: BoxFit.scaleDown,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text('(Der Buchstabe klettert ', style: baseGerman),
                      Text('an der richtigen Stelle:)', style: boldGerman),
                    ],
                  ),
                ),
              ],
            ),
          const SizedBox(height: 8),
          Image.asset('packages/wordle/assets/correct_$activeLang.png'),
          const SizedBox(height: 18),
          FittedBox(
            fit: BoxFit.scaleDown,
            child: Text('Máte 6 pokusů.', style: baseStyle),
          ),
          if (showGerman)
            Column(
              children: [
                const SizedBox(height: 8),
                FittedBox(
                  fit: BoxFit.scaleDown,
                  child: Text('(Du hast sechs Versuche.)', style: baseGerman),
                ),
              ],
            ),
          const SizedBox(height: 8),
          Image.asset('packages/wordle/assets/win_$activeLang.png'),
          const SizedBox(height: 24),
          FittedBox(
            fit: BoxFit.scaleDown,
            child:
                Text('Zpracoval Kvalitní digičas, z.s. ', style: baseStyle),
          ),
          if (showGerman)
            Column(
              children: [
                const SizedBox(height: 4),
                FittedBox(
                  fit: BoxFit.scaleDown,
                  child: Text(
                    'Produziert von Kvalitní digičas, z.s. ',
                    style: baseGerman,
                  ),
                ),
                
              ],
            ),
          const SizedBox(height: 4),
          Text('www.edukids.cz', style: baseStyle),
        ],
      ),
    );
  }
}
