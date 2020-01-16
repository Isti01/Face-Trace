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
  final int numNotifications;

  const NavBarItemWidget({
    Key key,
    this.selectedIndex,
    this.appColor,
    this.title,
    this.icon,
    this.index,
    this.onItemSelected,
    this.numNotifications,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;

    return GestureDetector(
      onTap: () => onItemSelected(index),
      child: Material(
        type: MaterialType.transparency,
        child: Padding(
          // this way it is easier to tap the navbar items
          padding: const EdgeInsets.symmetric(vertical: 6, horizontal: 8),
          child: Stack(
            children: <Widget>[
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 4, horizontal: 8),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [_iconWidget, animatedText],
                ),
              ),
              if (numNotifications != null && numNotifications > 0)
                _notificationCircle(textTheme)
            ],
          ),
        ),
      ),
    );
  }

  Widget _notificationCircle(TextTheme textTheme) => Positioned(
        top: 0,
        right: 0,
        child: Material(
          shape: CircleBorder(),
          color: Colors.red,
          elevation: 2,
          child: Padding(
            padding: const EdgeInsets.all(3),
            child: Text(
              numNotifications.toString(),
              style: textTheme.caption.copyWith(color: Colors.white),
            ),
          ),
        ),
      );

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
