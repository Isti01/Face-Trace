import 'dart:math' as math;

import 'package:face_app/bloc/app_bloc_states.dart';
import 'package:face_app/login/register_form/pages/form_page.dart';
import 'package:flutter/material.dart';

class ColorPage extends StatelessWidget {
  final AppColor initialColor;
  final Function(AppColor newColor, Offset offset) onColorChanged;

  const ColorPage({
    Key key,
    this.initialColor,
    this.onColorChanged,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return FormPage(
      removeChildPadding: true,
      title: "Válassz egy színt, ami tetszik!",
      child: ColorChooser(
        initialColor: initialColor,
        onColorChanged: onColorChanged,
      ),
    );
  }
}

class ColorChooser extends StatefulWidget {
  final AppColor initialColor;
  final Function(AppColor newColor, Offset offset) onColorChanged;

  const ColorChooser({
    Key key,
    this.initialColor,
    this.onColorChanged,
  }) : super(key: key);

  @override
  _ColorChooserState createState() => _ColorChooserState();
}

class _ColorChooserState extends State<ColorChooser> {
  PageController controller;
  final numPages = AppColor.values.length;
  final circleAnimation =
      Tween(begin: .0, end: .8).chain(CurveTween(curve: Curves.ease));
  final scaleAnimation =
      Tween(begin: 1.0, end: .8).chain(CurveTween(curve: Curves.ease));

  double page;

  @override
  void initState() {
    controller = PageController(
      viewportFraction: 0.34,
      initialPage: AppColor.values.indexOf(widget.initialColor),
    );
    page = controller.initialPage.toDouble();
    controller.addListener(() => setState(() => page = controller.page));
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final height = MediaQuery.of(context).size.height;

    return SizedBox(
      height: height * 0.35,
      child: PageView.builder(
        pageSnapping: true,
        itemCount: numPages,
        controller: controller,
        scrollDirection: Axis.horizontal,
        itemBuilder: (BuildContext context, int index) => ColorCircle(
          index: index,
          circleAnimation: circleAnimation,
          page: page,
          scaleAnimation: scaleAnimation,
          onSelected: widget.onColorChanged,
        ),
      ),
    );
  }

  @override
  void dispose() {
    controller.dispose();
    super.dispose();
  }
}

class ColorCircle extends StatelessWidget {
  final int index;
  final double page;
  final circleAnimation;
  final scaleAnimation;
  final Function(AppColor color, Offset offset) onSelected;

  const ColorCircle({
    Key key,
    this.index,
    this.page,
    this.circleAnimation,
    this.scaleAnimation,
    this.onSelected,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final color = AppColor.values[index];
    final circleSize = MediaQuery.of(context).size.shortestSide * 0.2;

    final dif = index - page;
    final value = math.min(1.0, math.max(0.0, dif.abs()));
    final offset = circleAnimation.transform(value) * (dif < 0 ? 1 : -1);
    return GestureDetector(
      onTapDown: (det) => onSelected(color, det.globalPosition),
      child: Align(
        alignment: Alignment(0, offset),
        child: Container(
          height: circleSize * scaleAnimation.transform(value),
          width: circleSize * scaleAnimation.transform(value),
          decoration: BoxDecoration(
            border: Border.all(color: Colors.white70, width: 3),
            shape: BoxShape.circle,
            gradient: LinearGradient(
              colors: appColorToColors(color),
              begin: Alignment.bottomLeft,
              end: Alignment.topRight,
            ),
          ),
        ),
      ),
    );
  }
}
