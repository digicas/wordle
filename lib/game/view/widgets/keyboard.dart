import 'package:flutter/material.dart';

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

  KeyState getStateByChar(String char) {
    return widget.keyStates[char] ?? KeyState.clear;
  }

  String? zoomedChar;
  int? zoomRow;
  int? zoomCol;
  double? currentKeyWidth;
  bool biggerKey = false;

  void setCurrentZoomChar({
    String? char,
    int? row,
    int? col,
    double? currentRowKeyWidth,
    bool bigKey = false,
  }) {
    setState(() {
      zoomedChar = char;
      zoomRow =
          widget.specialCharsLang != 'de' && widget.specialCharsLang != 'cs'
              ? row != null
                  ? row - 1
                  : null
              : row;
      zoomCol = col;
      currentKeyWidth = currentRowKeyWidth;
      biggerKey = bigKey;
    });
  }

  double _getSize(double s) {
    if (s > 768 && s < 1078) {
      return 40;
    }

    if (s > 1078) {
      return 36;
    }

    if (s > 400 && s < 768) {
      return 32;
    }

    return 28;
  }

  double zoomY(double s) {
    var x = 0 as double;
    if (zoomRow! - 1 > 0) {
      x = (zoomRow! - 1) * _getSize(s);
    } else {}
    x -= biggerKey ? 80 : 60;

    if (widget.specialCharsLang != 'de') x -= 20;
    return x;
  }

  double get zoomX {
    final x = zoomCol! * currentKeyWidth!;
    if (biggerKey) {
      return x + 5;
    }
    return x - currentKeyWidth! / 8;
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      clipBehavior: Clip.none,
      children: [
        Column(
          children: [
            if (specialChars.isNotEmpty)
              LayoutBuilder(
                builder: (context, constraints) {
                  final width = constraints.maxWidth / specialChars.length;
                  return Row(
                    children: [
                      ...specialChars.map(
                        (ch) => ZoomHitbox(
                          onEnter: () => setCurrentZoomChar(
                            char: ch,
                            row: 1,
                            col: specialChars.indexOf(ch),
                            currentRowKeyWidth: width,
                            bigKey: widget.specialCharsLang == 'de',
                          ),
                          onLeave: setCurrentZoomChar,
                          child: KeyboardTile(
                            onTap: widget.onTap,
                            char: ch,
                            state: getStateByChar(ch),
                            isCompact: widget.specialCharsLang != 'de',
                            width: width,
                          ),
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
                    (index) => ZoomHitbox(
                      onEnter: () => setCurrentZoomChar(
                        char: Keyboard.chars[index],
                        row: 2,
                        col: index,
                        currentRowKeyWidth: width,
                      ),
                      onLeave: setCurrentZoomChar,
                      child: KeyboardTile(
                        onTap: widget.onTap,
                        char: Keyboard.chars[index],
                        state: getStateByChar(Keyboard.chars[index]),
                        width: width,
                      ),
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
                    (index) => ZoomHitbox(
                      onEnter: () => setCurrentZoomChar(
                        char: Keyboard.chars[index + 10],
                        row: 3,
                        col: index,
                        currentRowKeyWidth: width,
                      ),
                      onLeave: setCurrentZoomChar,
                      child: KeyboardTile(
                        onTap: widget.onTap,
                        char: Keyboard.chars[index + 10],
                        state: getStateByChar(Keyboard.chars[index + 10]),
                        width: width,
                      ),
                    ),
                  ),
                );
              },
            ),
            LayoutBuilder(
              builder: (context, constraints) {
                final width = constraints.maxWidth / 9;
                return Row(
                  children: [
                    ZoomHitbox(
                      onEnter: () => setCurrentZoomChar(
                        char: '⌫',
                        row: 4,
                        col: 0,
                        currentRowKeyWidth: width,
                      ),
                      onLeave: setCurrentZoomChar,
                      child: KeyboardTile(
                        onTap: widget.onTap,
                        char: '⌫',
                        state: KeyState.clear,
                        width: constraints.maxWidth / 9,
                      ),
                    ),
                    ...List.generate(
                      7,
                      (index) => ZoomHitbox(
                        onEnter: () => setCurrentZoomChar(
                          char: Keyboard.chars[index + 19],
                          row: 4,
                          col: index + 1,
                          currentRowKeyWidth: width,
                        ),
                        onLeave: setCurrentZoomChar,
                        child: KeyboardTile(
                          onTap: widget.onTap,
                          char: Keyboard.chars[index + 19],
                          state: getStateByChar(Keyboard.chars[index + 19]),
                          width: constraints.maxWidth / 9,
                        ),
                      ),
                    ),
                    if (widget.canSubmit)
                      ZoomHitbox(
                        onEnter: () => setCurrentZoomChar(
                          char: '⏎',
                          row: 4,
                          col: 8,
                          currentRowKeyWidth: width,
                        ),
                        onLeave: setCurrentZoomChar,
                        child: KeyboardTile(
                          onTap: widget.onSubmitWord,
                          char: '⏎',
                          state: KeyState.clear,
                          width: constraints.maxWidth / 9,
                        ),
                      ),
                  ],
                );
              },
            ),
          ],
        ),
        if (zoomedChar != null && zoomRow != null && zoomCol != null)
          Positioned(
            top: zoomY(MediaQuery.of(context).size.width),
            left: zoomX,
            width: biggerKey ? currentKeyWidth! - 10 : 80,
            height: 80,
            child: Container(
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(8),
                color: const Color(0xffC4C4C4),
              ),
              alignment: Alignment.center,
              child: Text(
                zoomedChar!.toUpperCase(),
                textAlign: TextAlign.center,
                style: const TextStyle(
                  fontSize: 40,
                ),
              ),
            ),
          ),
      ],
    );
  }
}

class ZoomHitbox extends StatelessWidget {
  const ZoomHitbox({
    super.key,
    required this.child,
    required this.onEnter,
    required this.onLeave,
  });

  final Widget child;
  final void Function() onEnter;
  final VoidCallback onLeave;

  @override
  Widget build(BuildContext context) {
    return MouseRegion(
      cursor: SystemMouseCursors.click,
      hitTestBehavior: HitTestBehavior.opaque,
      onEnter: (event) {
        if (event.down) {
          onEnter();
        }
      },
      onExit: (_) => onLeave(),
      child: child,
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
