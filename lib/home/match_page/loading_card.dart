import 'dart:ui';

import 'package:face_app/bloc/data_classes/app_color.dart';
import 'package:face_app/util/current_user.dart';
import 'package:flutter/material.dart';

class LoadingCard extends StatefulWidget {
  @override
  _LoadingCardState createState() => _LoadingCardState();
}

class _LoadingCardState extends State<LoadingCard>
    with SingleTickerProviderStateMixin {
  AnimationController _controller;
  Animation<double> animation;

  get _initAnimation => CurvedAnimation(parent: _controller, curve: Curves.ease)
      .drive(Tween<double>(begin: 0, end: 1));

  Color get colorAnimation {
    AppColor appColor =
        mounted ? CurrentUser.of(context).user.appColor : AppColor.green;

    ColorSwatch color = appColor.color;

    return Color.lerp(color[400], color[800], animation.value);
  }

  @override
  void initState() {
    super.initState();

    _controller = AnimationController(
      vsync: this,
      duration: Duration(milliseconds: 1500),
    );

    animation = _initAnimation;
    _controller.addListener(() {
      if (mounted) setState(() {});
    });
    _controller.repeat(reverse: true);
  }

  @override
  Widget build(BuildContext context) {
    final borderRadius = BorderRadius.circular(25);

    return Material(
      borderRadius: borderRadius,
      elevation: 4,
      child: ClipRRect(
        borderRadius: borderRadius,
        child: Stack(
          children: [
            Positioned.fill(
                child: Material(
              child: Icon(Icons.person, size: 120, color: colorAnimation),
            )),
            Align(
              alignment: Alignment.bottomCenter,
              child: ClipRect(
                child: BackdropFilter(
                  filter: ImageFilter.blur(sigmaX: 5, sigmaY: 5),
                  child: Container(
                    color: Colors.black12,
                    child: Padding(
                      padding: const EdgeInsets.only(
                          bottom: 12, left: 8, top: 8, right: 8),
                      child: SizedBox(
                        width: double.infinity,
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.start,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            _gradientBar(true),
                            Padding(padding: const EdgeInsets.all(4)),
                            _gradientBar(),
                          ],
                        ),
                      ),
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _gradientBar([smaller = false]) => Container(
      height: 16,
      width: smaller ? 180 : 240,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(12),
        color: colorAnimation,
      ));

  @override
  void dispose() {
    _controller?.dispose();
    super.dispose();
  }
}
