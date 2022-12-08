import 'package:flutter/material.dart';
import 'package:wordle/instruction/widgets/instruction_texts.dart';

class InstructionsView extends StatelessWidget {
  const InstructionsView({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.spaceAround,
      children: [
        const SizedBox(height: 32),
        Container(
          padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 24),
          decoration: BoxDecoration(
            color: const Color(0xffE4E4E4),
            borderRadius: BorderRadius.circular(24),
          ),
          child: const Text(
            'WORDLE!',
            style: TextStyle(
              fontSize: 28,
            ),
          ),
        ),
        const InstructionTexts(),
      ],
    );
  }
}
