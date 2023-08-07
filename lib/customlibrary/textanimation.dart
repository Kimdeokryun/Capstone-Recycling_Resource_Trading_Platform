import 'package:flutter/material.dart';

class BouncingTextAnimation extends StatefulWidget {
  @override
  _BouncingTextAnimationState createState() => _BouncingTextAnimationState();
}

class _BouncingTextAnimationState extends State<BouncingTextAnimation>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late List<Animation<double>> _animations;

  final String text = "ecocycle";
  final TextStyle ecoStyle = TextStyle(color: Colors.black, fontFamily: 'HanB');
  final TextStyle cycleStyle = TextStyle(color: Color(0xff47ABFF), fontFamily: 'HanB');

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: Duration(milliseconds: 1000),
      vsync: this,
    );

    _animations = List.generate(text.length, (index) {
      final animation = TweenSequence([
        TweenSequenceItem<double>(
          tween: Tween(begin: 0.0, end: -25.0),
          weight: 1,
        ),
        TweenSequenceItem<double>(
          tween: Tween(begin: -25.0, end: 0.0),
          weight: 1,
        ),
      ]).animate(
        CurvedAnimation(
          parent: _controller,
          curve: Interval(
            index / text.length,
            (index + 0.5) / text.length,
            curve: Curves.bounceOut,
          ),
        ),
      );
      return animation;
    });

    _controller.repeat(reverse: true);
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: text.split('').asMap().entries.map((entry) {
        final index = entry.key;
        final char = entry.value;
        final style = (index < 3) ? ecoStyle : cycleStyle;

        return AnimatedBuilder(
          animation: _controller,
          builder: (context, child) {
            final animation = _animations[index];
            final translateY = animation.value;

            return Transform.translate(
              offset: Offset(0, translateY),
              child: Text(
                char,
                style: style.copyWith(),
                textScaleFactor: 1.5,
              ),
            );
          },
        );
      }).toList(),
    );
  }
}
