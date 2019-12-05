import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

FirebaseAuth auth = FirebaseAuth.instance;

const AppName = 'Face App';
const AppTextColor = Colors.white;
const BorderRadius AppBorderRadius = BorderRadius.all(Radius.circular(12));
const AppBorder = RoundedRectangleBorder(borderRadius: AppBorderRadius);
const BoxConstraints ButtonConstraints = const BoxConstraints(
  minWidth: 88,
  minHeight: 36,
);
const EdgeInsets ButtonPadding = const EdgeInsets.symmetric(
  vertical: 12,
  horizontal: 24,
);

const faceFunction =
    'https://europe-west1-face-app-c3aee.cloudfunctions.net/faceFunction';
