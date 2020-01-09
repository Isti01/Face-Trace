import 'package:face_app/bloc/data_classes/app_color.dart';
import 'package:face_app/splash_screen/shape.dart';
import 'package:face_app/util/constants.dart';
import 'package:flutter/material.dart';

const MaxOffset = 25.0;
const PlusOffset = 15;

class SplashScreen extends StatefulWidget {
  @override
  _SplashScreenState createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen>
    with TickerProviderStateMixin {
  AnimationController _textController;
  Animation<double> textAnimation;

  List<AnimationController> _controllers;
  List<Animation<double>> offsets;

  anim(i) => offsets[i].value * (MaxOffset + i * PlusOffset);

  @override
  void initState() {
    _controllers = List.generate(3, (i) => i)
        .map((i) => AnimationController(
              vsync: this,
              duration: Duration(milliseconds: 2000),
            ))
        .toList()
          ..forEach((c) => c.repeat(
                reverse: true,
              ));

    offsets = List.generate(3, (i) => i)
        .map((i) => Tween(begin: 1.0, end: .0).animate(CurvedAnimation(
            parent: _controllers[i],
            curve: Interval(
              (2 - i) * 0.15,
              1 - (2 - i) * 0.15,
              curve: Curves.easeInOut,
            ))))
        .toList();

    _controllers[0].addListener(() {
      if (mounted) setState(() {});
    });

    _textController = AnimationController(
      vsync: this,
      duration: Duration(milliseconds: 750),
    );

    textAnimation =
        CurvedAnimation(parent: _textController, curve: Curves.bounceOut);

    _textController.forward();

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    // todo make it better
    //todo design https://dribbble.com/shots/4654928-Redesign-of-HQ-trivia
    final height = MediaQuery.of(context).size.height;
    final color = AppColor.purple;
    return Scaffold(
        body: Stack(
      children: [
        ShapePair(
          color: color.color[700].withAlpha(60),
          pos: height / 1.5 + anim(2),
        ),
        ShapePair(
          color: color.color[700].withAlpha(120),
          pos: height / 1.35 + anim(1),
        ),
        ShapePair(
          color: color.color[700],
          pos: height / 1.2 + anim(0),
        ),
        Center(
          child: Transform.scale(
            scale: textAnimation.value,
            child: Text(
              AppName,
              style: Theme.of(context).textTheme.title.copyWith(
                    fontSize: (MediaQuery.of(context).size.width / 6),
                  ),
            ),
          ),
        ),
      ],
    ));
  }

  @override
  void dispose() {
    _textController.dispose();
    _controllers.forEach((c) => c.dispose());
    super.dispose();
  }
}
