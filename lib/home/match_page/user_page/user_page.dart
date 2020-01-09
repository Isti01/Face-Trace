import 'package:face_app/bloc/data_classes/app_color.dart';
import 'package:face_app/bloc/data_classes/user.dart';
import 'package:face_app/home/match_page/card_button.dart';
import 'package:face_app/home/match_page/user_page/user_details.dart';
import 'package:face_app/localizations/localizations.dart';
import 'package:face_app/util/current_user.dart';
import 'package:face_app/util/dynamic_gradient.dart';
import 'package:face_app/util/simple_scroll_behavior.dart';
import 'package:face_app/util/transparent_appbar.dart';
import 'package:flutter/material.dart';

class UserPage extends StatefulWidget {
  final User user;
  final Function(bool right, String uid) swipe;

  const UserPage({Key key, this.user, this.swipe}) : super(key: key);
  @override
  _UserPageState createState() => _UserPageState();
}

class _UserPageState extends State<UserPage> {
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final localizations = AppLocalizations.of(context);
    final currentUser = CurrentUser.of(context).user;
    final theme = Theme.of(context);

    return ScrollConfiguration(
      behavior: SimpleScrollBehavior(),
      child: AnimatedTheme(
        data: ThemeData(primarySwatch: currentUser.appColor.color),
        child: Scaffold(
          body: DynamicGradientBackground(
            color: currentUser.appColor,
            child: Stack(
              children: [
                Positioned.fill(
                  child: SingleChildScrollView(
                    child: UserDetails(user: widget.user),
                  ),
                ),
                Positioned(
                  top: 0,
                  right: 0,
                  left: 0,
                  child: TransparentAppBar(
                    color: Colors.white12,
                    leading: IconButton(
                      icon: Icon(Icons.arrow_back_ios, color: Colors.white),
                      onPressed: () => Navigator.pop(context),
                    ),
                    title: Text(
                      localizations.discover,
                      style: theme.textTheme.title.apply(color: Colors.white),
                    ),
                  ),
                ),
                Positioned(
                  bottom: 24,
                  right: 24,
                  left: 24,
                  child: CardButtons(
                    uid: widget.user.uid,
                    swipe: (right) {
                      widget.swipe(right, widget.user.uid);
                      Navigator.pop(context);
                    },
                    color: currentUser.appColor,
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
