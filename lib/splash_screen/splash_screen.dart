import 'package:flutter/material.dart';

class SplashScreen extends StatefulWidget {
  @override
  _SplashScreenState createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen>
    with TickerProviderStateMixin {
  AnimationController _textController;
  Animation<double> textAnimation;

  @override
  void initState() {
    _textController = AnimationController(
      vsync: this,
      duration: Duration(seconds: 5),
    )..addListener(() {
        if (mounted) setState(() {});
      });

    textAnimation = CurvedAnimation(
      parent: _textController,
      curve: Curves.ease,
    );

    _textController.repeat(reverse: true);

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Center(
        child: Transform.scale(
          scale: .8 + textAnimation.value * 0.1,
          child: Image.asset('assets/logo.png'),
        ),
      ),
    );
  }

  @override
  void dispose() {
    _textController.dispose();
    super.dispose();
  }
}
