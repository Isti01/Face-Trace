import 'package:face_app/bloc/data_classes/user.dart';
import 'package:face_app/bloc/user_bloc/user_bloc.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class CurrentUser extends InheritedWidget {
  final User user;
  const CurrentUser({
    Key key,
    @required Widget child,
    @required this.user,
  })  : assert(child != null),
        super(key: key, child: child);

  static CurrentUser of(BuildContext context) =>
      context.dependOnInheritedWidgetOfExactType<CurrentUser>();

  static Widget passOverUser({BuildContext context, Widget child}) =>
      BlocBuilder<UserBloc, User>(
        bloc: BlocProvider.of<UserBloc>(context),
        builder: (context, user) => CurrentUser(
          user: user,
          child: child,
        ),
      );

  @override
  bool updateShouldNotify(CurrentUser old) => old.user != this.user;
}
