import 'dart:math';

import 'package:flutter/material.dart';

class ShapePair extends StatelessWidget {
  final Color color;
  final double pos;

  const ShapePair({Key key, this.color, this.pos}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: <Widget>[
        SplashScreenShape(
          color: color,
          position: pos,
          inverted: true,
        ),
        SplashScreenShape(
          color: color,
          position: pos,
          inverted: false,
        ),
      ],
    );
  }
}

class SplashScreenShape extends StatelessWidget {
  final double position;
  final bool inverted;
  final Color color;

  const SplashScreenShape({
    Key key,
    this.position,
    this.inverted = false,
    this.color,
  }) : super(key: key);
  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    if (!inverted) return _child(size);

    return Transform(
      transform: Matrix4.identity()
        ..setEntry(3, 2, 0.001) // perspective
        ..rotateX(pi)
        ..rotateY(pi),
      alignment: FractionalOffset.center,
      child: _child(size),
    );
  }

  Widget _child(Size size) => Transform.translate(
      offset: Offset(0, position),
      child: CustomPaint(
        painter: ShapePainter(color),
        child: SizedBox(
          height: size.height,
          width: size.width,
        ),
      ));
}

class ShapePainter extends CustomPainter {
  final Color color;

  ShapePainter(this.color);

  @override
  void paint(Canvas canvas, Size size) {
    final path = Path();
    path.lineTo(0, size.height);
    path.lineTo(size.width, size.height);
    path.lineTo(size.width, 0);
    path.quadraticBezierTo(size.width * .9, -125, size.width / 2, 0);
    path.quadraticBezierTo(size.width * .1, 125, 0, 0);

    final paint = Paint()..color = color;
    canvas.drawPath(path, paint);
  }

  @override
  bool shouldRepaint(CustomPainter old) {
    if (!(old is ShapePainter)) return true;

    return (old as ShapePainter).color == color;
  }
}
