import 'dart:ui';

import 'package:face_app/bloc/data_classes/app_color.dart';
import 'package:flutter/material.dart';

class LoadingCard extends StatefulWidget {
  final appColor = AppColor.green;

  @override
  _LoadingCardState createState() => _LoadingCardState();
}

class _LoadingCardState extends State<LoadingCard>
    with SingleTickerProviderStateMixin {
  AnimationController _controller;
  Animation<Color> colorAnimation;
  Animation<double> gradAnimation;

  get _initAnimation =>
      CurvedAnimation(parent: _controller, curve: Curves.ease).drive(ColorTween(
        begin: widget.appColor.color[300],
        end: widget.appColor.color[600],
      ));

  @override
  void initState() {
    super.initState();

    _controller = AnimationController(
      vsync: this,
      duration: Duration(milliseconds: 1500),
    );

    colorAnimation = _initAnimation;
    _controller.addListener(() {
      if (mounted) setState(() {});
    });
    _controller.repeat(reverse: true);
  }

  @override
  void didUpdateWidget(LoadingCard oldWidget) {
    super.didUpdateWidget(oldWidget);
    colorAnimation = _initAnimation;
  }

  @override
  Widget build(BuildContext context) {
    final borderRadius = BorderRadius.circular(25);
    colorAnimation = _initAnimation;

    return Material(
      borderRadius: borderRadius,
      elevation: 4,
      child: ClipRRect(
        borderRadius: borderRadius,
        child: Stack(
          children: [
            Positioned.fill(
                child: Material(
              child: Icon(Icons.person, size: 120, color: colorAnimation.value),
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
        color: colorAnimation.value,
      ));

  @override
  void dispose() {
    _controller?.dispose();
    super.dispose();
  }
}
