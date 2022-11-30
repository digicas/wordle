import 'package:flutter/material.dart';

class Keyboard extends StatelessWidget {
  const Keyboard({
    super.key,
    this.specialCharsLang,
    this.canSubmit = false,
    required this.keyStates,
    required this.onTap,
    required this.onSubmitWord,
  });

  static final germanChars = ['ä', 'ö', 'ü', 'ẞ'];

  static final czechChars = ['ě', 'š', 'č', 'ř', 'ž', 'ý', 'á', 'í', 'é', 'ů'];

  List<String> get specialChars {
    if (specialCharsLang == null) return <String>[];
    if (specialCharsLang == 'cs') return czechChars;
    return germanChars;
  }

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

  final String? specialCharsLang;
  final bool canSubmit;
  final Map<String, KeyState> keyStates;
  final void Function(String) onTap;
  final void Function(String) onSubmitWord;

  KeyState getStateByChar(String char) {
    return keyStates[char] ?? KeyState.clear;
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        LayoutBuilder(
          builder: (context, constraints) => Row(
            children: [
              ...(specialChars.isNotEmpty ? specialChars : [specialChars.last])
                  .map(
                (ch) => KeyboardTile(
                  width: constraints.maxWidth / specialChars.length,
                  char: ch,
                  state: getStateByChar(ch),
                  onTap: onTap,
                  isCompact: specialCharsLang != 'de',
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
                onTap: onTap,
                char: chars[index],
                state: getStateByChar(chars[index]),
                width: constraints.maxWidth / 10,
              ),
            ),
          ),
        ),
        LayoutBuilder(
          builder: (context, constraints) => Row(
            children: List.generate(
              9,
              (index) => KeyboardTile(
                onTap: onTap,
                char: chars[index + 10],
                state: getStateByChar(chars[index + 10]),
                width: constraints.maxWidth / 9,
              ),
            ),
          ),
        ),
        LayoutBuilder(
          builder: (context, constraints) => Row(
            children: [
              KeyboardTile(
                onTap: onTap,
                char: '⌫',
                state: KeyState.clear,
                width: constraints.maxWidth / 9,
              ),
              ...List.generate(
                7,
                (index) => KeyboardTile(
                  onTap: onTap,
                  char: chars[index + 19],
                  state: getStateByChar(chars[index + 19]),
                  width: constraints.maxWidth / 9,
                ),
              ),
              if (canSubmit)
                KeyboardTile(
                  onTap: onSubmitWord,
                  char: '⏎',
                  state: KeyState.clear,
                  width: constraints.maxWidth / 9,
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
    required this.state,
    required this.width,
    this.isCompact = true,
  });

  final void Function(String) onTap;
  final String char;
  final double width;
  final bool isCompact;
  final KeyState state;

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
      onTap: () => onTap(char),
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
            color: state == KeyState.correct
                ? Colors.green
                : state == KeyState.contains
                    ? Colors.orange
                    : state == KeyState.wrong
                        ? const Color(0xffC4C4C4)
                        : const Color(0xffE4E4E4),
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
              fontFamily: 'Roboto',
            ),
          ),
        ),
      ),
    );
  }
}

enum KeyState {
  clear,
  wrong,
  contains,
  correct;
}
