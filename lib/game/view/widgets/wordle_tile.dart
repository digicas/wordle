import 'package:flutter/material.dart';

class WordleTile extends StatefulWidget {
  const WordleTile({
    super.key,
    this.letter,
    required this.state,
    required this.isFocused, required this.size,
  });

  final String? letter;
  final TileState state;
  final bool isFocused;
  final Size size;

  @override
  State<WordleTile> createState() => _WordleTileState();
}

class _WordleTileState extends State<WordleTile>
    with SingleTickerProviderStateMixin {
  final duration = const Duration(milliseconds: 1000);
  final curve = Curves.bounceOut;
  late final AnimationController controller;

  @override
  void initState() {
    super.initState();
    controller = AnimationController(
      vsync: this,
      duration: duration,
    )
      ..forward()
      ..addListener(() {
        if (controller.isCompleted) {
          controller.reverse();
        }
        if (controller.isDismissed) {
          controller.forward();
        }
      });
  }

  @override
  void dispose() {
    controller.dispose();
    super.dispose();
  }

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
    return AnimatedBuilder(
      animation: controller,
      builder: (context, child) => Container(
        width: widget.size.width,
        height: widget.size.height,
        padding: const EdgeInsets.all(4),
        alignment: Alignment.center,
        decoration: BoxDecoration(
          color:
              widget.isFocused ? Colors.transparent : widget.state.background,
          borderRadius: BorderRadius.circular(4),
          boxShadow: widget.isFocused
              ? [
                  BoxShadow(
                    color: Colors.blueAccent.withOpacity(0.5),
                  ),
                  BoxShadow(
                    color: widget.state.background,
                    spreadRadius: -6 * controller.value,
                    blurRadius: 10 * controller.value,
                  ),
                ]
              : [],
        ),
        child: Text(
          widget.letter != null
              ? widget.letter != 'ẞ'
                  ? widget.letter!.toUpperCase()
                  : 'ẞ'
              : ' ',
          style: TextStyle(
            fontSize: fontSize.toDouble(),
            fontWeight:
                widget.letter == 'ẞ' ? FontWeight.w400 : FontWeight.w600,
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
