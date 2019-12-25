import 'package:face_app/bloc/data_classes/app_color.dart';
import 'package:face_app/home/nav_bar/nav_bar_item_widget.dart';
import 'package:flutter/material.dart';

const tabData = const {
  0: TabBase(Icons.favorite_border, "Felfedezés"),
  1: TabBase(Icons.chat_bubble_outline, "Chat"),
  2: TabBase(Icons.person_outline, "Profile"),
};

class NavBar extends StatelessWidget {
  final AppColor appColor;
  final int pageIndex;
  final Function(int index) onItemTapped;

  const NavBar({
    Key key,
    this.appColor,
    this.pageIndex,
    this.onItemTapped,
  }) : super(key: key);

  Iterable<Widget> get tabs => tabData.entries.map((tab) => NavBarItemWidget(
        selectedIndex: pageIndex,
        index: tab.key,
        icon: tab.value.icon,
        appColor: appColor,
        title: tab.value.title,
        onItemSelected: onItemTapped,
      ));

  @override
  Widget build(BuildContext context) {
    return Material(
      elevation: 4,
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 8),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: tabs.toList(),
        ),
      ),
    );
  }
}

class TabBase {
  final IconData icon;
  final String title;

  const TabBase(this.icon, this.title);
}
