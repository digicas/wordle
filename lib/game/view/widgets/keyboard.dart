import 'package:flutter/material.dart';

class Keyboard extends StatelessWidget {
  const Keyboard({
    super.key,
    required this.disabledLetters,
    required this.onTap,
    required this.onSubmitWord,
  });

  static final specialChars = ['ä', 'ö', 'ü', 'ß', '⌫'];

  static final chars = [
    'q',
    'w',
    'e',
    'r',
    't',
    'y',
    'u',
    'i',
    'o',
    'p',
    'a',
    's',
    'd',
    'f',
    'g',
    'h',
    'j',
    'k',
    'l',
    'z',
    'x',
    'c',
    'v',
    'b',
    'n',
    'm',
  ];

  final List<String> disabledLetters;
  final void Function(String) onTap;
  final VoidCallback onSubmitWord;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Container(
          margin: const EdgeInsets.symmetric(horizontal: 16),
          padding: const EdgeInsets.all(8),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              ...specialChars.map(
                (ch) => KeyboardTile(
                  char: ch,
                  isDisabled: disabledLetters.contains(ch),
                  onTap: onTap,
                  isCompact: false,
                ),
              ),
            ],
          ),
        ),
        const SizedBox(height: 8),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: List.generate(
            10,
            (index) => KeyboardTile(
              char: chars[index],
              isDisabled: disabledLetters.contains(chars[index]),
              onTap: onTap,
            ),
          ),
        ),
        const SizedBox(height: 8),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: List.generate(
            9,
            (index) => KeyboardTile(
              char: chars[index + 10],
              isDisabled: disabledLetters.contains(chars[index + 10]),
              onTap: onTap,
            ),
          ),
        ),
        const SizedBox(height: 8),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            ...List.generate(
              7,
              (index) => KeyboardTile(
                char: chars[index + 19],
                isDisabled: disabledLetters.contains(chars[index + 19]),
                onTap: onTap,
              ),
            ),
            GestureDetector(
              onTap: onSubmitWord,
              child: Container(
                width: 32,
                height: 32,
                alignment: Alignment.center,
                child: const Text(
                  '✅',
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ),
            ),
          ],
        ),
      ],
    );
  }
}

class KeyboardTile extends StatelessWidget {
  const KeyboardTile({
    super.key,
    required this.onTap,
    required this.char,
    this.isCompact = true,
    this.isDisabled = false,
  });

  final void Function(String) onTap;
  final String char;
  final bool isDisabled;
  final bool isCompact;

  double _getSize(double s) {
    if (s > 768 && s < 1078) {
      return isCompact ? 40 : 56;
    }

    if (s > 1078) {
      return isCompact ? 32 : 48;
    }

    if (s > 400 && s < 768) {
      return isCompact ? 36 : 50;
    }

    return isCompact ? 28 : 44;
  }

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;

    return GestureDetector(
      onTap: isDisabled ? null : () => onTap(char),
      child: Container(
        width: _getSize(screenWidth),
        height: _getSize(screenWidth),
        alignment: Alignment.center,
        decoration: BoxDecoration(
          color: isDisabled
              ? Colors.black.withOpacity(0.3)
              : const Color(0xffE4E4E4),
          borderRadius: BorderRadius.circular(isCompact ? 12 : 16),
        ),
        child: Text(
          char != 'ß' ? char.toUpperCase() : 'ẞ',
          style: TextStyle(
            fontFamily: char == '⌫' ? 'Roboto' : 'Lato',
            fontSize: screenWidth > 1078
                ? 24
                : screenWidth > 768
                    ? 22
                    : screenWidth > 400
                        ? 22
                        : 18,
            fontWeight: FontWeight.w500,
          ),
        ),
      ),
    );
  }
}
