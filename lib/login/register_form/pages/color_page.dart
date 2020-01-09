import 'package:face_app/bloc/data_classes/app_color.dart';
import 'package:face_app/localizations/localizations.dart';
import 'package:face_app/login/register_form/pages/form_page.dart';
import 'package:face_app/util/color_circle.dart';
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
    final localizations = AppLocalizations.of(context);

    return FormPage(
      removeChildPadding: true,
      title: localizations.colorQuestion,
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
          color: AppColor.values[index],
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
