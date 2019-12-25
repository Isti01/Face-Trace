import 'package:face_app/bloc/data_classes/user.dart';
import 'package:face_app/bloc/user_bloc.dart';
import 'package:face_app/home/face_app_home.dart';
import 'package:face_app/login/login.dart';
import 'package:face_app/util/current_user.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:rxdart/rxdart.dart';

class FaceApp extends StatefulWidget {
  @override
  _FaceAppState createState() => _FaceAppState();
}

class _FaceAppState extends State<FaceApp> {
  UserBloc userBloc;

  @override
  void initState() {
    userBloc = UserBloc();
    _requestPermissions();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: BlocBuilder<UserBloc, User>(
        bloc: userBloc,
        builder: (BuildContext context, User state) {
          final user = state.user;
          if (state.initial)
            return Scaffold(
                body: Center(
              child: Text('some creative splash screen'),
            ));

          if (user == null) return Login();

          if (!state.fetchedData)
            return Scaffold(
                body: Center(
              child: Text(
                  'some creative splash screen'), //todo make a better splashscreen
            ));

          if (!state.hasData) return Login(startPage: 1, initialUser: user);

          return CurrentUser(
            key: ValueKey(user.uid),
            user: user,
            child: FaceAppHome(user: user, appColor: state.appColor),
          );
        },
      ),
    );
  }

  @override
  void dispose() {
    userBloc.close();
    super.dispose();
  }
}

_requestPermissions() async {
  final handler = PermissionHandler();
  // I used Observable because plain List doesnt have asyncMap
  final permissions = await Observable.fromIterable([
    PermissionGroup.storage,
    PermissionGroup.camera,
    PermissionGroup.location,
  ]).asyncMap(_isGranted).where((result) => result != null).toList();

  if (permissions.isEmpty) return;
  handler.requestPermissions(permissions);
}

Future<PermissionGroup> _isGranted(PermissionGroup permission) async {
  final result = await PermissionHandler().checkPermissionStatus(permission);
  final granted = result == PermissionStatus.granted;

  return granted ? null : permission;
}
