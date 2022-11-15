import 'package:flutter/material.dart';

class WordleTile extends StatelessWidget {
  const WordleTile({
    super.key,
    this.letter,
    required this.state,
    required this.isFocused,
  });

  final String? letter;
  final TileState state;
  final bool isFocused;

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;

    final fontSize = screenWidth > 1078
        ? 32
        : screenWidth > 768
            ? 26
            : screenWidth > 350
                ? 24
                : 16;
    return Expanded(
      child: Container(
        padding: const EdgeInsets.all(4),
        alignment: Alignment.center,
        decoration: BoxDecoration(
          color: state.background,
          borderRadius: BorderRadius.circular(4),
          border: Border.all(
            color: isFocused ? Colors.blueAccent : Colors.transparent,
            width: 3,
          ),
        ),
        child: Text(
          letter != null ? letter!.toUpperCase() : ' ',
          style: TextStyle(
            fontSize: fontSize.toDouble(),
            fontWeight: FontWeight.w600,
          ),
        ),
      ),
    );
  }
}

enum TileState {
  empty(0),
  wrong(1),
  wrongIndex(2),
  correct(3);

  const TileState(this.value);
  final int value;

  Color get background => value == 0
      ? const Color(0xffE4E4E4)
      : value == 1
          ? const Color(0xffC4C4C4)
          : value == 2
              ? Colors.orange
              : Colors.green;
}
