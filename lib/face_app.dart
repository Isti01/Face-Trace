import 'package:face_app/home/face_app_home.dart';
import 'package:face_app/login/login.dart';
import 'package:face_app/login/login_theme.dart';
import 'package:flutter/material.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:rxdart/rxdart.dart';

class FaceApp extends StatefulWidget {
  final bool loggedIn;

  const FaceApp({Key key, this.loggedIn = true}) : super(key: key);

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
    return MaterialApp(
      theme:
          widget.loggedIn ? ThemeData(primarySwatch: Colors.blue) : loginTheme,
      home: widget.loggedIn ? FaceAppHome() : Login(),
    );
  }
}
