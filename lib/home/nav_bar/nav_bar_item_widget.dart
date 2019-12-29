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
    final selected = selectedIndex == index;

    return GestureDetector(
      onTap: () => onItemSelected(index),
      child: Material(
        type: MaterialType.transparency,
        child: Padding(
          // this way it is easier to tap the navbar items
          padding: const EdgeInsets.symmetric(vertical: 6, horizontal: 12),
          child: AnimatedContainer(
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(999),
              color: selected ? appColor.color[700] : Color(0x00ffffff),
            ),
            child: Padding(
              padding: const EdgeInsets.only(left: 4, top: 4, bottom: 4),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [_iconWidget, animatedText],
              ),
            ),
            duration: duration,
          ),
        ),
      ),
    );
  }

  Widget get _iconWidget => Container(
        child: Text(
          icon,
          style: TextStyle(inherit: true, fontSize: 20),
        ),
        padding: const EdgeInsets.all(4),
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          color: Colors.white30,
        ),
      );

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
              ? Container(
                  child: Padding(
                    padding: const EdgeInsets.only(right: 8),
                    child: Text(
                      title,
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                        letterSpacing: .6,
                      ),
                    ),
                  ),
                )
              : SizedBox(),
          duration: duration,
        ),
      );
}
