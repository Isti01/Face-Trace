import 'package:circular_reveal_animation/circular_reveal_animation.dart';
import 'package:face_app/bloc/app_bloc_states.dart';
import 'package:flutter/material.dart';

class DynamicGradientBackground extends StatefulWidget {
  final AppColor initialColor;
  final Widget child;

  const DynamicGradientBackground({
    Key key,
    this.initialColor,
    this.child,
  }) : super(key: key);

  @override
  DynamicGradientBackgroundState createState() =>
      DynamicGradientBackgroundState();
}

class DynamicGradientBackgroundState extends State<DynamicGradientBackground>
    with SingleTickerProviderStateMixin {
  AppColor _gradient;
  AppColor _prevGradient;
  AnimationController _controller;
  Animation<double> _revealAnimation;
  Offset _startOffset;

  @override
  void initState() {
    _prevGradient = _gradient = widget.initialColor;
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: Duration(milliseconds: 750),
    );
    _revealAnimation = CurvedAnimation(parent: _controller, curve: Curves.ease);

    _controller.addListener(() {
      if (mounted) this.setState(() {});
    });
  }

  changeGradient({AppColor gradient, Offset startOffset}) {
    _prevGradient = this._gradient;
    this._gradient = gradient;
    this._startOffset = startOffset;
    _controller.reset();
    _controller.forward();
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      fit: StackFit.expand,
      children: [
        Container(
            decoration: BoxDecoration(
                gradient: LinearGradient(
          colors: appColorToColors(_prevGradient),
          begin: Alignment.bottomLeft,
          end: Alignment.topRight,
        ))),
        Positioned.fill(
          child: CircularRevealAnimation(
            centerOffset: _startOffset,
            minRadius: 0,
            child: Container(
                decoration: BoxDecoration(
                    gradient: LinearGradient(
              colors: appColorToColors(_gradient),
              begin: Alignment.bottomLeft,
              end: Alignment.topRight,
            ))),
            animation: _revealAnimation,
          ),
        ),
        Positioned.fill(child: widget.child),
      ],
    );
  }
}
