import 'package:face_app/bloc/data_classes/app_color.dart';
import "package:flutter/material.dart";

const duration = Duration(milliseconds: 250);

class NavBarItemWidget extends StatelessWidget {
  final AppColor appColor;
  final int selectedIndex;
  final String title;
  final String icon;
  final int index;
  final Function(int i) onItemSelected;

  const NavBarItemWidget({
    Key key,
    this.selectedIndex,
    this.appColor,
    this.title,
    this.icon,
    this.index,
    this.onItemSelected,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => onItemSelected(index),
      child: Material(
        type: MaterialType.transparency,
        child: Padding(
          // this way it is easier to tap the navbar items
          padding: const EdgeInsets.symmetric(vertical: 6, horizontal: 8),
          child: Padding(
            padding: const EdgeInsets.symmetric(vertical: 4, horizontal: 8),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [_iconWidget, animatedText],
            ),
          ),
        ),
      ),
    );
  }

  Widget get _iconWidget =>
      Text(icon, style: TextStyle(inherit: true, fontSize: 24));

  Widget get animatedText => Padding(
        padding: const EdgeInsets.symmetric(horizontal: 4),
        child: AnimatedSwitcher(
          transitionBuilder: (widget, animation) => SizeTransition(
            sizeFactor: animation,
            child: widget,
            axis: Axis.horizontal,
            axisAlignment: -1,
          ),
          child: selectedIndex == index
              ? Text(
                  title,
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    color: appColor.color[700],
                    fontWeight: FontWeight.bold,
                    fontSize: 16,
                  ),
                )
              : SizedBox(),
          duration: duration,
        ),
      );
}
