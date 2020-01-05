import 'dart:math' as math;
import 'dart:ui';

import 'package:face_app/bloc/data_classes/app_color.dart';
import 'package:face_app/bloc/data_classes/gender.dart';
import 'package:face_app/bloc/data_classes/user.dart';
import 'package:face_app/home/face_app_home.dart';
import 'package:flutter/material.dart';

final random = math.Random();

class LoadingCard extends StatefulWidget {
  final User currentUser;

  const LoadingCard({Key key, this.currentUser}) : super(key: key);
  @override
  _LoadingCardState createState() => _LoadingCardState();

  static Widget loadingEmoji(String emoji) => Center(
        child: Text(
          emoji,
          style: TextStyle(fontSize: 200),
        ),
      );
}

class _LoadingCardState extends State<LoadingCard>
    with SingleTickerProviderStateMixin {
  AnimationController _controller;
  Animation<Color> _animation;

  String _genderEmoji;

  ColorSwatch get _color => widget.currentUser.appColor.color;
  get _initAnimation => ColorTween(begin: _color[400], end: _color[800])
      .animate(CurvedAnimation(parent: _controller, curve: Curves.ease));

  String get _emoji {
    final attractedTo = widget.currentUser.attractedTo;
    if (attractedTo?.isEmpty ?? true) return Gender.other.emoji;
    final length = attractedTo.length;
    return attractedTo[random.nextInt(length)].emoji;
  }

  @override
  void initState() {
    super.initState();

    _genderEmoji = _emoji;

    _controller = AnimationController(
      vsync: this,
      duration: Duration(milliseconds: 1500),
    );

    _animation = _initAnimation;
    _controller.addListener(() {
      if (mounted) setState(() {});
    });
    _controller.repeat(reverse: true);
  }

  @override
  Widget build(BuildContext context) {
    final borderRadius = BorderRadius.circular(12);

    final size = MediaQuery.of(context).size;

    return Padding(
      padding: PagePadding,
      child: Material(
        borderRadius: borderRadius,
        elevation: 4,
        child: ClipRRect(
          borderRadius: borderRadius,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              SizedBox(
                height: size.shortestSide * 0.9,
                child: Material(child: LoadingCard.loadingEmoji(_genderEmoji)),
              ),
              Padding(
                padding: const EdgeInsets.all(12),
                child: SizedBox(
                  width: double.infinity,
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      _textBar(true),
                      Padding(padding: const EdgeInsets.all(4)),
                      _textBar(),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _textBar([smaller = false]) => Container(
      height: 16,
      width: smaller ? 180 : 240,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(12),
        color: _animation.value,
      ));

  @override
  void dispose() {
    _controller?.dispose();
    super.dispose();
  }
}
