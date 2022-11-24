import 'package:flutter/material.dart';

class Keyboard extends StatelessWidget {
  const Keyboard({
    super.key,
    required this.disabledLetters,
    this.hasSpecialChars = false,
    this.canSubmit = false,
    required this.onTap,
    required this.onSubmitWord,
  });

  static final specialChars = ['ä', 'ö', 'ü', 'ẞ', '⌫'];

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
  final bool hasSpecialChars;
  final bool canSubmit;
  final void Function(String) onTap;
  final void Function(String) onSubmitWord;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        LayoutBuilder(
          builder: (context, constraints) => Row(
            children: [
              ...(hasSpecialChars ? specialChars : [specialChars.last]).map(
                (ch) => KeyboardTile(
                  width: constraints.maxWidth / specialChars.length,
                  char: ch,
                  isDisabled: disabledLetters.contains(ch),
                  onTap: onTap,
                  isCompact: false,
                ),
              ),
            ],
          ),
        ),
        LayoutBuilder(
          builder: (context, constraints) => Row(
            children: List.generate(
              10,
              (index) => KeyboardTile(
                width: constraints.maxWidth / 10,
                char: chars[index],
                isDisabled: disabledLetters.contains(chars[index]),
                onTap: onTap,
              ),
            ),
          ),
        ),
        LayoutBuilder(
          builder: (context, constraints) => Row(
            children: List.generate(
              9,
              (index) => KeyboardTile(
                width: constraints.maxWidth / 9,
                char: chars[index + 10],
                isDisabled: disabledLetters.contains(chars[index + 10]),
                onTap: onTap,
              ),
            ),
          ),
        ),
        LayoutBuilder(
          builder: (context, constraints) => Row(
            children: [
              ...List.generate(
                7,
                (index) => KeyboardTile(
                  width: constraints.maxWidth / 8,
                  char: chars[index + 19],
                  isDisabled: disabledLetters.contains(chars[index + 19]),
                  onTap: onTap,
                ),
              ),
              if (canSubmit)
                KeyboardTile(
                  onTap: onSubmitWord,
                  char: '✅',
                  color: Colors.transparent,
                  width: constraints.maxWidth / 8,
                ),
            ],
          ),
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
    required this.width,
    this.color,
  });

  final void Function(String) onTap;
  final String char;
  final double width;
  final bool isDisabled;
  final bool isCompact;
  final Color? color;

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
      behavior: HitTestBehavior.opaque,
      onTap: isDisabled ? null : () => onTap(char),
      child: SizedBox(
        width: width,
        child: Container(
          margin: EdgeInsets.all(
            screenWidth > 1078 ? 6 : 4,
          ),
          width: _getSize(screenWidth),
          height: _getSize(screenWidth),
          alignment: Alignment.center,
          decoration: BoxDecoration(
            color: isDisabled
                ? Colors.black.withOpacity(0.3)
                : color ?? const Color(0xffE4E4E4),
            borderRadius: BorderRadius.circular(6),
          ),
          child: Text(
            char != 'ẞ' ? char.toUpperCase() : 'ẞ',
            style: TextStyle(
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
      ),
    );
  }
}
