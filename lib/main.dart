import 'package:face_app/bloc/data_classes/app_color.dart';
import 'package:face_app/face_app.dart';
import 'package:face_app/util/constants.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

main() async {
  WidgetsFlutterBinding.ensureInitialized();
  final user = await auth.currentUser();

  final prefs = await SharedPreferences.getInstance();
  final appColor = AppColorExtension.parse(prefs.getString('appColor'));

  runApp(FaceApp(
    loggedIn: user != null,
    appColor: appColor,
    user: user,
  ));
}
