import 'dart:math' as math;

import 'package:face_app/bloc/data_classes/app_color.dart';
import 'package:flutter/material.dart';

class ColorCircle extends StatelessWidget {
  final int index;
  final double page;
  final circleAnimation;
  final scaleAnimation;
  final Function(AppColor color, Offset offset) onSelected;
  final AppColor color;

  const ColorCircle({
    Key key,
    this.index = 0,
    this.page = 0,
    this.circleAnimation,
    this.scaleAnimation,
    this.onSelected,
    this.color,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final dif = index - page;
    final value = math.min(1.0, math.max(0.0, dif.abs()));

    final offset = circleAnimation.transform(value) * (dif < 0 ? 1 : -1);
    return GestureDetector(
      onTapDown: (det) => onSelected(color, det.globalPosition),
      child: Align(
        alignment: Alignment(0, offset),
        child: Transform.scale(
          scale: scaleAnimation.transform(value),
          child: SimpleColorCircle(color: color),
        ),
      ),
    );
  }
}

class SimpleColorCircle extends StatelessWidget {
  final AppColor color;
  final double size;
  const SimpleColorCircle({Key key, this.color, this.size}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    final circleSize = size ?? MediaQuery.of(context).size.shortestSide * 0.2;

    return Container(
      height: circleSize,
      width: circleSize,
      decoration: BoxDecoration(
        border: Border.all(color: Colors.white70, width: 3),
        shape: BoxShape.circle,
        gradient: LinearGradient(
          colors: color.colors,
          begin: Alignment.bottomLeft,
          end: Alignment.topRight,
        ),
      ),
    );
  }
}
