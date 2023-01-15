import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class Keyboard extends StatefulWidget {
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

  @override
  State<Keyboard> createState() => _KeyboardState();
}

class _KeyboardState extends State<Keyboard> {
  List<String> get specialChars {
    if (widget.specialCharsLang == 'de') return Keyboard.germanChars;
    if (widget.specialCharsLang == 'cs') return Keyboard.czechChars;
    return <String>[];
  }

  final keyboardKey = GlobalKey<RawGestureDetectorState>();

  KeyState getStateByChar(String char) {
    return widget.keyStates[char] ?? KeyState.clear;
  }

  bool get hasSpecialChars =>
      widget.specialCharsLang == 'cs' || widget.specialCharsLang == 'de';

  String? shownKey;
  Offset? shownKeyPosition;
  double? shownTileSize;

  void onShowKey(Offset pos, BuildContext context) {
    final keyContext = keyboardKey.currentContext;
    if (keyContext == null) return;
    if (keyContext.findRenderObject() == null) return;
    final size = (keyContext.findRenderObject()! as RenderBox).size;

    if (pos.dx < 0 ||
        pos.dx > size.width ||
        pos.dy < 0 ||
        pos.dy > size.height) {
      shownKey = null;
      shownKeyPosition = null;
      shownTileSize = null;
      setState(() {});
      return;
    }

    final rowHeight = size.height / (hasSpecialChars ? 4 : 3);
    final currentRow = (pos.dy / rowHeight).floor();
    var tileSize = 0.0;
    if (hasSpecialChars) {
      tileSize = size.width /
          (currentRow == 0
              ? specialChars.length
              : currentRow == 1
                  ? 10
                  : 9);
    } else {
      tileSize = size.width / (currentRow == 0 ? 10 : 0);
    }
    shownTileSize = tileSize;
    final currentColumn = (pos.dx / tileSize).floor();
    final currentRowChars = hasSpecialChars
        ? currentRow == 0
            ? specialChars
            : currentRow == 1
                ? getCharsFromIndex(0, 10)
                : currentRow == 2
                    ? getCharsFromIndex(10, 9)
                    : getCharsFromIndex(19, 7)
        : currentRow == 0
            ? getCharsFromIndex(0, 10)
            : currentRow == 1
                ? getCharsFromIndex(10, 9)
                : getCharsFromIndex(19, 7);
    if (currentRowChars.length - 1 < currentColumn) return;
    shownKey = currentRowChars[currentColumn];
    final screenWidth = MediaQuery.of(context).size.width;
    final x = currentColumn * tileSize;

    final y = (screenWidth > 1078 ? 4 : 2) +
        (currentRow * KeyboardTile._getSize(screenWidth)) +
        (currentRow * (screenWidth > 1078 ? 8 : 4));
    shownKeyPosition = Offset(x, y);
    setState(() {});
  }

  void onShownKeyChanged(Offset pos, BuildContext context) {
    onShowKey(pos, context);
  }

  List<String> getCharsFromIndex(int index, int length) {
    final result = <String>[];
    if (index > 18) {
      result
        ..add('⌫')
        ..addAll(List.generate(length, (index) => Keyboard.chars[index + 19]))
        ..add('⏎');
    } else {
      for (var i = index; i - index < length; i++) {
        result.add(Keyboard.chars[i]);
      }
    }
    return result;
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      clipBehavior: Clip.none,
      children: [
        GestureDetector(
          key: keyboardKey,
          onPanDown: (details) => onShowKey(details.localPosition, context),
          onPanUpdate: (details) =>
              onShownKeyChanged(details.localPosition, context),
          onPanEnd: (details) => setState(
            () => {
              shownKey = null,
              shownKeyPosition = null,
              shownTileSize = null,
            },
          ),
          onPanCancel: () => setState(
            () => {
              shownKey = null,
              shownKeyPosition = null,
              shownTileSize = null,
            },
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              if (specialChars.isNotEmpty)
                LayoutBuilder(
                  builder: (context, constraints) {
                    final width = constraints.maxWidth / specialChars.length;
                    return Row(
                      children: [
                        ...specialChars.map(
                          (ch) => KeyboardTile(
                            onTap: widget.onTap,
                            char: ch,
                            state: getStateByChar(ch),
                            width: width,
                          ),
                        ),
                      ],
                    );
                  },
                ),
              LayoutBuilder(
                builder: (context, constraints) {
                  final width = constraints.maxWidth / 10;
                  return Row(
                    children: List.generate(
                      10,
                      (index) => KeyboardTile(
                        onTap: widget.onTap,
                        char: Keyboard.chars[index],
                        state: getStateByChar(Keyboard.chars[index]),
                        width: width,
                      ),
                    ),
                  );
                },
              ),
              LayoutBuilder(
                builder: (context, constraints) {
                  final width = constraints.maxWidth / 9;
                  return Row(
                    children: List.generate(
                      9,
                      (index) => KeyboardTile(
                        onTap: widget.onTap,
                        char: Keyboard.chars[index + 10],
                        state: getStateByChar(Keyboard.chars[index + 10]),
                        width: width,
                      ),
                    ),
                  );
                },
              ),
              LayoutBuilder(
                builder: (context, constraints) {
                  return Row(
                    children: [
                      KeyboardTile(
                        onTap: widget.onTap,
                        char: '⌫',
                        state: KeyState.clear,
                        width: constraints.maxWidth / 9,
                      ),
                      ...List.generate(
                        7,
                        (index) => KeyboardTile(
                          onTap: widget.onTap,
                          char: Keyboard.chars[index + 19],
                          state: getStateByChar(Keyboard.chars[index + 19]),
                          width: constraints.maxWidth / 9,
                        ),
                      ),
                      if (widget.canSubmit)
                        KeyboardTile(
                          onTap: widget.onSubmitWord,
                          char: '⏎',
                          state: KeyState.clear,
                          width: constraints.maxWidth / 9,
                        ),
                    ],
                  );
                },
              ),
            ],
          ),
        ),
        if (shownKey != null &&
            shownKeyPosition != null &&
            shownTileSize != null)
          Builder(
            builder: (context) {
              final size =
                  KeyboardTile._getSize(MediaQuery.of(context).size.width);
              return Positioned(
                top: 0,
                left: shownKeyPosition!.dx,
                child: Transform.translate(
                  offset: Offset(
                    Keyboard.germanChars.contains(shownKey)
                        ? 0
                        : -(shownTileSize! / 4),
                    shownKeyPosition!.dy -
                        (size * 1.5) -
                        (KeyboardTile.padding(
                              MediaQuery.of(context).size.width,
                            ) *
                            2),
                  ),
                  child: Container(
                    width: Keyboard.germanChars.contains(shownKey)
                        ? shownTileSize
                        : shownTileSize! * 1.5,
                    height: size * 1.5,
                    alignment: Alignment.center,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(16),
                      border: Border.all(color: const Color(0xffC4C4C4)),
                      color: const Color(0xffE4E4E4),
                    ),
                    child: Text(
                      shownKey!.toUpperCase(),
                      style: const TextStyle(
                        fontSize: 48,
                      ),
                    ),
                  ),
                ),
              );
            },
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
  });

  final void Function(String) onTap;
  final String char;
  final double width;
  final KeyState state;

  static double _getSize(double s) {
    if (s > 768 && s < 1078) {
      return 56;
    }

    if (s > 1078) {
      return 48;
    }

    if (s > 400 && s < 768) {
      return 50;
    }

    return 44;
  }

  static double padding(double s) {
    return s > 1078 ? 4 : 2;
  }

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    return GestureDetector(
      behavior: HitTestBehavior.opaque,
      onTap: () {
        HapticFeedback.lightImpact();
        onTap(char);
      },
      child: SizedBox(
        width: width,
        child: Container(
          margin: EdgeInsets.all(
            padding(screenWidth),
          ),
          width: width - screenWidth > 1078 ? 8 : 4,
          height: _getSize(screenWidth),
          alignment: Alignment.center,
          decoration: BoxDecoration(
            color: state == KeyState.correct
                ? Colors.green
                : state == KeyState.contains
                    ? Colors.orange
                    : state == KeyState.wrong
                        ? const Color(0xffC4C4C4)
                        : char == '⏎'
                            ? Colors.lightBlue
                            : char == '⌫'
                                ? Colors.red
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
