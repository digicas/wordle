import 'package:flutter/material.dart';
import 'package:wordle/instruction/widgets/instruction_texts.dart';

class InstructionsPage extends StatelessWidget {
  const InstructionsPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.fromLTRB(32, 64, 32, 0),
        child: SizedBox.expand(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              Container(
                padding:
                    const EdgeInsets.symmetric(vertical: 16, horizontal: 24),
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
              GestureDetector(
                onTap: () => Navigator.of(context).popAndPushNamed('/game'),
                child: Container(
                  padding: const EdgeInsets.symmetric(
                    vertical: 16,
                    horizontal: 24,
                  ),
                  decoration: BoxDecoration(
                    color: const Color(0xffE4E4E4),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: const Text(
                    'Hrát',
                    style: TextStyle(
                      fontSize: 24,
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
