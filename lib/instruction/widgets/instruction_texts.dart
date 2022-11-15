// ignore_for_file: lines_longer_than_80_chars

import 'package:flutter/material.dart';

class InstructionTexts extends StatelessWidget {
  const InstructionTexts({super.key});

  static final texts = <String>[
    'Trochen Šprechen vám ukáže, že němčina je nám blízká.',
    'Spisovná i hovorová němčina, varianty od Bavor až po Vídeň. Moderní i lehce archaické výrazy.',
    'Cílem není nabídnout ucelený seznam germanismů, ale dokázat, že německy se může naučit každý, protože velké množství slov už dávno znáte z češtiny!'
  ];

  @override
  Widget build(BuildContext context) {
    return Column(
      children: texts.map((t) {
        return Container(
          alignment: Alignment.center,
          padding: const EdgeInsets.symmetric(vertical: 8),
          child: Text(
            t,
            overflow: TextOverflow.clip,
            style: const TextStyle(
              fontSize: 16,
            ),
          ),
        );
      }).toList(),
    );
  }
}
