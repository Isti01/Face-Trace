import 'package:flutter/material.dart';

class GradientRaisedButton extends StatefulWidget {
  final Widget child;
  final Gradient gradient;
  final VoidCallback onTap;
  final BorderRadius borderRadius;

  const GradientRaisedButton({
    Key key,
    this.gradient,
    this.onTap,
    this.child,
    this.borderRadius,
  }) : super(key: key);

  @override
  _GradientRaisedButtonState createState() => _GradientRaisedButtonState();
}

class _GradientRaisedButtonState extends State<GradientRaisedButton> {
  bool tapping = false;

  @override
  Widget build(BuildContext context) {
    final borderRadius = widget.borderRadius ?? BorderRadius.circular(12);
    return Material(
      borderRadius: borderRadius,
      elevation: tapping ? 8 : 4,
      child: DecoratedBox(
        decoration: BoxDecoration(
          gradient: widget.gradient,
          borderRadius: borderRadius,
        ),
        child: Material(
          borderRadius: borderRadius,
          type: MaterialType.transparency,
          child: InkWell(
            borderRadius: borderRadius,
            onTapCancel: () => setState(() => tapping = false),
            onTapDown: (d) => setState(() => tapping = true),
            onTap: () {
              setState(() => tapping = false);
              widget.onTap();
            },
            child: ConstrainedBox(
              child: widget.child ?? Container(),
              constraints: BoxConstraints(minWidth: 88, minHeight: 36),
            ),
          ),
        ),
      ),
    );
  }
}
