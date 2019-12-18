import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class CurrentUser extends InheritedWidget {
  final FirebaseUser user;
  const CurrentUser({
    Key key,
    @required Widget child,
    @required this.user,
  })  : assert(child != null),
        super(key: key, child: child);

  static CurrentUser of(BuildContext context) =>
      context.dependOnInheritedWidgetOfExactType<CurrentUser>();

  @override
  bool updateShouldNotify(CurrentUser old) {
    return old.user != this.user;
  }
}
