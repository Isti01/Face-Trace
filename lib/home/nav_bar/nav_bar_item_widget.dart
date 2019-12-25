import 'package:face_app/bloc/data_classes/app_color.dart';
import "package:flutter/material.dart";

const duration = Duration(milliseconds: 250);

class NavBarItemWidget extends StatelessWidget {
  final AppColor appColor;
  final int selectedIndex;
  final String title;
  final IconData icon;
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

    final theme = Theme.of(context);
    final themeData = theme.copyWith(
      iconTheme: theme.iconTheme.copyWith(
        color: selected ? Colors.white : Colors.grey[500],
      ),
    );

    return GestureDetector(
      onTap: () => onItemSelected(index),
      child: AnimatedContainer(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(999),
          color: selected ? appColor.color : Color(0x00ffffff),
        ),
        child: Padding(
          padding: const EdgeInsets.only(left: 12, top: 8, bottom: 8),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              AnimatedTheme(
                child: Icon(icon),
                data: themeData,
                duration: duration,
              ),
              animatedText
            ],
          ),
        ),
        duration: duration,
      ),
    );
  }

  get animatedText => Padding(
        padding: const EdgeInsets.all(4),
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
                    padding: const EdgeInsets.only(right: 12),
                    child: Text(
                      title,
                      textAlign: TextAlign.center,
                      style: TextStyle(color: Colors.white),
                    ),
                  ),
                )
              : SizedBox(),
          duration: duration,
        ),
      );
}
