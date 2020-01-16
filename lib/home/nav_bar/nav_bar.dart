import 'package:face_app/bloc/data_classes/gender.dart';
import 'package:face_app/bloc/data_classes/user.dart';
import 'package:face_app/home/nav_bar/nav_bar_item_widget.dart';
import 'package:face_app/localizations/localizations.dart';
import 'package:face_app/util/current_user.dart';
import 'package:flutter/material.dart';

class NavBar extends StatefulWidget {
  final int pageIndex;
  final Function(int index) onItemTapped;

  const NavBar({
    Key key,
    this.pageIndex,
    this.onItemTapped,
  }) : super(key: key);

  @override
  NavBarState createState() => NavBarState();
}

class NavBarState extends State<NavBar> {
  int chatNotifications = 0;

  User getUser(context) => CurrentUser.of(context).user;

  Map<int, TabBase> tabData(context) {
    final localizations = AppLocalizations.of(context);
    return {
      0: TabBase('💖', localizations.discover),
      1: TabBase('💬', localizations.chat, chatNotifications),
      2: TabBase(getUser(context).gender.emoji, localizations.profile),
    };
  }

  incrementNotificationCount() => setState(() {
        if (widget.pageIndex != 1) chatNotifications++;
      });

  void removeNotifications() => setState(() => chatNotifications = 0);

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.white,
      elevation: 4,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: tabData(context)
            .entries
            .map((tab) => NavBarItemWidget(
                  selectedIndex: widget.pageIndex,
                  index: tab.key,
                  icon: tab.value.icon,
                  appColor: getUser(context).appColor,
                  title: tab.value.title,
                  onItemSelected: widget.onItemTapped,
                  numNotifications: tab.value.numNotifications,
                ))
            .toList(),
      ),
    );
  }
}

class TabBase {
  final String icon;
  final String title;
  final int numNotifications;

  const TabBase(this.icon, this.title, [this.numNotifications]);
}
