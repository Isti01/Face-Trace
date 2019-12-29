import 'package:circular_reveal_animation/circular_reveal_animation.dart';
import 'package:face_app/bloc/data_classes/app_color.dart';
import 'package:flutter/material.dart';

class DynamicGradientBackground extends StatefulWidget {
  final AppColor color;
  final Widget child;

  const DynamicGradientBackground({
    Key key,
    this.color,
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
    _prevGradient = _gradient = widget.color;
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
  void didUpdateWidget(DynamicGradientBackground oldWidget) {
    if (oldWidget.color != widget.color) {
      if (mounted) {
        final size = MediaQuery.of(context).size;
        changeGradient(
          gradient: widget.color,
          startOffset: Offset(size.width / 2, size.height / 2),
        );
      } else {
        changeGradient(
          gradient: widget.color,
          startOffset: Offset(0, 0),
        );
      }
    }
    super.didUpdateWidget(oldWidget);
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      fit: StackFit.expand,
      children: [
        Container(
            decoration: BoxDecoration(
                gradient: LinearGradient(
          colors: _prevGradient.colors,
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
                  colors: _gradient.colors,
                  begin: Alignment.bottomLeft,
                  end: Alignment.topRight,
                ),
              ),
            ),
            animation: _revealAnimation,
          ),
        ),
        Positioned.fill(child: widget.child),
      ],
    );
  }
}
