import 'package:flutter/material.dart';

class SlidePageRoute<T> extends PageRoute<T> {
  final bool fullscreenDialog;

  final WidgetBuilder builder;

  SlidePageRoute({
    @required this.builder,
    RouteSettings settings,
    this.fullscreenDialog = false,
  }) : super(settings: settings, fullscreenDialog: fullscreenDialog);

  @override
  Color get barrierColor => Color(0xffffff0);

  @override
  String get barrierLabel => null;

  @override
  Widget buildPage(BuildContext context, Animation<double> animation,
      Animation<double> secondaryAnimation) {
    print([animation.value, secondaryAnimation.value]);
    return builder(context) ?? SizedBox();
  }

  @override
  bool get maintainState => true;

  @override
  Duration get transitionDuration => const Duration(milliseconds: 1350);
}
