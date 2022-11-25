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
    final screenWidth = MediaQuery.of(context).size.width;
    final padding = screenWidth > 768 ? screenWidth * 0.2 : 16;
    return Column(
      children: texts.map((t) {
        return Container(
          alignment: Alignment.center,
          padding: EdgeInsets.symmetric(
            vertical: 8,
            horizontal: padding.toDouble(),
          ),
          child: Text(
            t,
            overflow: TextOverflow.clip,
            style: TextStyle(
              fontSize: screenWidth > 1078
                  ? 22
                  : screenWidth > 768
                      ? 20
                      : 18,
            ),
          ),
        );
      }).toList(),
    );
  }
}
