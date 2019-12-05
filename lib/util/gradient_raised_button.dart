import 'package:face_app/util/constants.dart';
import 'package:flutter/material.dart';

class GradientRaisedButton extends StatelessWidget {
  final Widget title;
  final onTap;
  final List<Color> gradientColors;
  final BorderRadius borderRadius;

  const GradientRaisedButton({
    Key key,
    this.title,
    this.onTap,
    this.gradientColors,
    this.borderRadius = AppBorderRadius,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return RaisedButton(
      onPressed: onTap,
      textColor: Colors.white,
      padding: const EdgeInsets.all(0.0),
      shape: RoundedRectangleBorder(borderRadius: borderRadius),
      child: Container(
        constraints: ButtonConstraints,
        decoration: BoxDecoration(
          gradient: LinearGradient(colors: gradientColors),
          borderRadius: borderRadius,
        ),
        padding: ButtonPadding,
        child: Center(
          widthFactor: 1.0,
          heightFactor: 1.0,
          child: title,
        ),
      ),
    );
  }
}
