import 'package:face_app/bloc/data_classes/gender.dart';
import 'package:face_app/bloc/data_classes/user.dart';
import 'package:face_app/home/nav_bar/nav_bar_item_widget.dart';
import 'package:face_app/util/current_user.dart';
import 'package:flutter/material.dart';

class NavBar extends StatelessWidget {
  final int pageIndex;
  final Function(int index) onItemTapped;

  const NavBar({
    Key key,
    this.pageIndex,
    this.onItemTapped,
  }) : super(key: key);

  User getUser(context) => CurrentUser.of(context).user;

  Map<int, TabBase> tabData(context) => {
        0: TabBase('💖', "Felfedezés"),
        1: TabBase('💬', "Chat"),
        2: TabBase(getUser(context).gender.emoji, "Profil"),
      };

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
                selectedIndex: pageIndex,
                index: tab.key,
                icon: tab.value.icon,
                appColor: getUser(context).appColor,
                title: tab.value.title,
                onItemSelected: onItemTapped))
            .toList(),
      ),
    );
  }
}

class TabBase {
  final String icon;
  final String title;

  const TabBase(this.icon, this.title);
}
