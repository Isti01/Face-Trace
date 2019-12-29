import 'package:flutter/material.dart';

class GradientRaisedButton extends StatefulWidget {
  final Widget child;
  final Gradient gradient;
  final VoidCallback onTap;
  final BorderRadius borderRadius;
  final BoxShape shape;

  const GradientRaisedButton({
    Key key,
    this.gradient,
    this.onTap,
    this.child,
    this.borderRadius,
    this.shape = BoxShape.rectangle,
  }) : super(key: key);

  factory GradientRaisedButton.circle({
    Widget child,
    Gradient gradient,
    VoidCallback onTap,
    BorderRadius borderRadius,
  }) =>
      GradientRaisedButton(
        gradient: gradient,
        onTap: onTap,
        child: child,
        borderRadius: borderRadius,
        shape: BoxShape.circle,
      );

  @override
  _GradientRaisedButtonState createState() => _GradientRaisedButtonState();
}

class _GradientRaisedButtonState extends State<GradientRaisedButton> {
  bool tapping = false;

  @override
  Widget build(BuildContext context) {
    final circle = widget.shape == BoxShape.circle;

    final constraints = circle
        ? BoxConstraints(minWidth: 64, minHeight: 64)
        : BoxConstraints(minWidth: 88, minHeight: 36);
    final type = circle ? MaterialType.circle : MaterialType.button;
    final borderRadius =
        circle ? null : (widget.borderRadius ?? BorderRadius.circular(12));
    return ConstrainedBox(
      constraints: constraints,
      child: Material(
        borderRadius: borderRadius,
        color: Colors.white,
        type: type,
        elevation: tapping ? 8 : 4,
        child: DecoratedBox(
          decoration: BoxDecoration(
            gradient: widget.gradient,
            borderRadius: borderRadius,
            shape: widget.shape,
          ),
          child: Material(
            borderRadius: borderRadius,
            type: type,
            elevation: 0,
            color: Colors.transparent,
            child: InkWell(
              borderRadius: borderRadius ?? BorderRadius.circular(999),
              onTapCancel: () => setState(() => tapping = false),
              onTapDown: (d) => setState(() => tapping = true),
              onTap: () {
                setState(() => tapping = false);
                widget.onTap();
              },
              child: Center(child: widget.child ?? Container()),
            ),
          ),
        ),
      ),
    );
  }
}
