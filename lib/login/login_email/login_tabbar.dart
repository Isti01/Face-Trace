import 'package:flutter/material.dart';

class LoginTabBar extends StatelessWidget {
  final TabController controller;

  const LoginTabBar({Key key, this.controller}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 50),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(999),
        child: Material(
          color: Colors.black26,
          child: TabBar(
            labelColor: Colors.black,
            unselectedLabelColor: Colors.white,
            indicatorPadding: EdgeInsets.zero,
            indicatorSize: TabBarIndicatorSize.label,
            labelPadding: EdgeInsets.zero,
            controller: controller,
            indicator: ShapeDecoration(
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(999),
              ),
              color: Colors.white,
            ),
            indicatorColor: Colors.transparent,
            tabs: [
              Tab(child: Center(child: Text('Meglévő'))),
              Tab(child: Center(child: Text('Új')))
            ],
          ),
        ),
      ),
    );
  }
}
