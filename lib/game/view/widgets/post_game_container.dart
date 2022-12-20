import 'package:flutter/material.dart';
import 'package:wordle/models/answer_word.dart';

class PostGameContainer extends StatelessWidget {
  const PostGameContainer({
    super.key,
    required this.gameWon,
    required this.answerWord,
    required this.onContinue,
  });

  final bool gameWon;
  final AnswerWord answerWord;
  final VoidCallback onContinue;

  bool get gameLost => !gameWon;

  String get translation =>
      answerWord.czechTr != null ? '(${answerWord.czechTr})' : '';

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.symmetric(vertical: 16),
      decoration: BoxDecoration(
        color: (gameWon ? Colors.green : Colors.red).withOpacity(0.8),
        borderRadius: BorderRadius.circular(16),
      ),
      child: Column(
        children: [
          Text(
            gameWon ? 'SPRÁVNĚ' : 'ŠPATNĚ',
            style: const TextStyle(
              color: Colors.white,
              fontSize: 28,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            '${answerWord.word} $translation',
            textAlign: TextAlign.center,
            style: const TextStyle(
              fontSize: 24,
              color: Colors.white,
            ),
          ),
          const SizedBox(
            height: 8,
          ),
          GestureDetector(
            onTap: onContinue,
            child: Container(
              padding: const EdgeInsets.symmetric(
                vertical: 12,
                horizontal: 16,
              ),
              decoration: BoxDecoration(
                color: const Color(0xffE4E4E4),
                borderRadius: BorderRadius.circular(12),
              ),
              child: const Text(
                'Pokračovat',
                style: TextStyle(
                  fontSize: 22,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
