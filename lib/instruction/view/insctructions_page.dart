import 'package:flutter/material.dart';
import 'package:wordle/game/view/widgets/language_button.dart';

class InstructionsView extends StatelessWidget {
  const InstructionsView({super.key, required this.activeLang});

  final Language activeLang;

  TextStyle get baseStyle => const TextStyle(
        fontSize: 22,
        fontWeight: FontWeight.normal,
      );

  TextStyle get boldStyle => baseStyle.copyWith(
        fontWeight: FontWeight.bold,
        fontSize: 22,
      );

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
      padding: const EdgeInsets.fromLTRB(12,16,12,0),
      child: Column(
        children: [
          const FittedBox(
            fit: BoxFit.scaleDown,
            child: Text(
              'Pravidla',
              style: TextStyle(
                fontSize: 44,
                fontWeight: FontWeight.w500,
              ),
            ),
          ),
          const SizedBox(height: 24),
          FittedBox(
            fit: BoxFit.scaleDown,
            child: Text(
              'Hádáte slovo $wordLength znáků dlouhé. Např.',
              style: baseStyle,
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
                  'apod.',
                  style: baseStyle,
                )
              ],
            ),
          ),
          const SizedBox(height: 12),
          FittedBox(
            fit: BoxFit.scaleDown,
            child: Text(
              'Postupně zkoušíte zadat své tipy.',
              style: baseStyle,
            ),
          ),
          const SizedBox(height: 8),
          FittedBox(
            fit: BoxFit.scaleDown,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text('Musí to být vždy ', style: baseStyle),
                Text('podstatáné jméno ', style: boldStyle),
                Text('(které hra zná)', style: baseStyle),
              ],
            ),
          ),
          const SizedBox(height: 8),
          FittedBox(
            fit: BoxFit.scaleDown,
            child: Text('dlouhé $wordLength písmen', style: baseStyle),
          ),
          const SizedBox(height: 8),
          FittedBox(
            fit: BoxFit.scaleDown,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text('Potvrdíte jej klávesou ', style: baseStyle),
                Text('Enter (⏎) ', style: boldStyle),
              ],
            ),
          ),
          const SizedBox(height: 4),
          FittedBox(
            fit: BoxFit.scaleDown,
            child: Text('a hra zadané slovo označí:', style: baseStyle),
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
          const SizedBox(height: 8),
          Image.asset('packages/wordle/assets/instructions_wrong.png'),
          const SizedBox(height: 18),
          FittedBox(
            fit: BoxFit.scaleDown,
            child: Text('Písmena obsažena v hledaném slove,', style: baseStyle),
          ),
          FittedBox(
            fit: BoxFit.scaleDown,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text('ale ležící ', style: baseStyle),
                Text('na nesprávné pozici:', style: boldStyle),
              ],
            ),
          ),
          const SizedBox(height: 8),
          Image.asset('packages/wordle/assets/instructions_wrong_index.png'),
          const SizedBox(height: 18),
          FittedBox(
            fit: BoxFit.scaleDown,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text('Písmeno ležící ', style: baseStyle),
                Text('na správné pozici:', style: boldStyle),
              ],
            ),
          ),
          const SizedBox(height: 8),
          Image.asset('packages/wordle/assets/instructions_correct.png'),
          const SizedBox(height: 18),
          FittedBox(
            fit: BoxFit.scaleDown,
            child: Text('Máte 6 pokusů.', style: baseStyle),
          ),
          const SizedBox(height: 8),
          Image.asset('packages/wordle/assets/instructions_win.png'),
          const SizedBox(height: 24),
          FittedBox(
            fit: BoxFit.scaleDown,
            child:
                Text('Autorem původní hry v angličtine je', style: baseStyle),
          ),
          const SizedBox(height: 4),
          Text('Josh Wardle', style: baseStyle),
        ],
      ),
    );
  }
}
