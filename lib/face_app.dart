import 'package:face_app/bloc/data_classes/user.dart';
import 'package:face_app/bloc/user_bloc/user_bloc.dart';
import 'package:face_app/home/face_app_home.dart';
import 'package:face_app/localizations/localizations.dart';
import 'package:face_app/login/login.dart';
import 'package:face_app/splash_screen/splash_screen.dart';
import 'package:face_app/util/constants.dart';
import 'package:face_app/util/current_user.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:permission_handler/permission_handler.dart';

class FaceApp extends StatefulWidget {
  @override
  _FaceAppState createState() => _FaceAppState();
}

class _FaceAppState extends State<FaceApp> {
  UserBloc userBloc;

  @override
  void initState() {
    SystemChrome.setPreferredOrientations([DeviceOrientation.portraitUp]);

    userBloc = UserBloc();
    _requestPermissions();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider.value(
      value: userBloc,
      child: BlocBuilder<UserBloc, User>(
        bloc: userBloc,
        builder: (BuildContext context, User state) => MaterialApp(
          debugShowCheckedModeBanner: false,
          localizationsDelegates: [
            AppLocalizationsDelegate(state.language),
            GlobalMaterialLocalizations.delegate,
            GlobalWidgetsLocalizations.delegate,
          ],
          title: AppName,
          home: _buildHome(context, state),
        ),
      ),
    );
  }

  Widget _buildHome(BuildContext context, User state) {
    if (state.initial) return SplashScreen();
    final user = state.user;

    if (user == null) return Login();
    if (!state.fetchedData) return SplashScreen();

    if (!state.hasData) return Login(startPage: 1, initialUser: user);

    return CurrentUser(
      key: ValueKey(user.uid),
      user: state,
      child: FaceAppHome(user: user),
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

  final permissions = await Stream.fromIterable([
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
