import 'package:face_app/face_app.dart';
import 'package:face_app/util/constants.dart';
import 'package:flutter/material.dart';

main() async {
  final loggedIn = await auth.currentUser() != null;

  runApp(FaceApp(loggedIn: loggedIn));
}
