import 'package:face_app/bloc/data_classes/app_color.dart';
import 'package:face_app/home/face_app_home.dart';
import 'package:face_app/login/login.dart';
import 'package:face_app/login/login_theme.dart';
import 'package:face_app/util/constants.dart';
import 'package:face_app/util/current_user.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:rxdart/rxdart.dart';

class FaceApp extends StatefulWidget {
  final bool loggedIn;
  final AppColor appColor;
  final FirebaseUser user;

  const FaceApp({
    Key key,
    this.loggedIn = true,
    this.appColor,
    this.user,
  }) : super(key: key);

  @override
  FaceAppState createState() => FaceAppState();
}

class FaceAppState extends State<FaceApp> {
  @override
  void initState() {
    super.initState();
    _requestPermissions();
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

  update() => setState(() {});

  @override
  Widget build(BuildContext context) {
    final homeTheme = ThemeData(primarySwatch: widget.appColor.color);
    return MaterialApp(
      theme: widget.loggedIn ? homeTheme : loginTheme,
      home: widget.loggedIn ? _home : Login(),
    );
  }

  Widget get _home => StreamBuilder(
        initialData: widget.user,
        stream: auth.onAuthStateChanged,
        builder: (BuildContext context, AsyncSnapshot<FirebaseUser> snapshot) =>
            CurrentUser(
          key: ValueKey(snapshot.data.uid),
          user: snapshot.data,
          child: FaceAppHome(
            appColor: widget.appColor,
            user: snapshot.data,
          ),
        ),
      );
}
