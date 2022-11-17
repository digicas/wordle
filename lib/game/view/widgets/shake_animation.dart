import 'package:flutter/material.dart';

class ShakeAnimation extends StatelessWidget {
  const ShakeAnimation({
    super.key,
    required this.child,
    required this.controller,
    required this.animation,
    this.duration = const Duration(milliseconds: 400),
    this.offset = 140,
  });

  final Widget child;
  final AnimationController controller;
  final Animation<double> animation;
  final Duration duration;
  final double offset;

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: controller,
      child: child,
      builder: (context, child) => Transform.translate(
        offset: Offset(
          animation.value != 1 ? animation.value * offset * -1 : 0,
          0,
        ),
        child: child,
      ),
    );
  }
}
