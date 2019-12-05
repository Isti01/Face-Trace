import 'package:flutter/material.dart';

class AppState {}

abstract class AppEvent {}

enum AppColor {
  red,
  green,
  blue,
  purple,
}

AppColor nextColor(int index) {
  final colors = AppColor.values;
  return colors[(index + 1) % colors.length];
}

ColorSwatch appColorToColor(AppColor color) {
  switch (color) {
    case AppColor.red:
      return Colors.red;
    case AppColor.green:
      return Colors.green;
    case AppColor.blue:
      return Colors.blue;
    case AppColor.purple:
      return Colors.purple;
    default:
      return Colors.blue;
  }
}

List<Color> appColorToColors(AppColor color) {
  switch (color) {
    case AppColor.red:
      return [Colors.pink[700], Colors.red[900]];
    case AppColor.green:
      return [Colors.teal, Colors.green[700]];
    case AppColor.blue:
      return [Colors.blue[500], Colors.blue[800]];
    case AppColor.purple:
      return [Colors.deepPurple, Colors.purple[700]];
    default:
      return [Colors.white, Colors.black];
  }
}

enum Gender {
  female,
  male,
  other,
}

genderToString(Gender gender) {
  switch (gender) {
    case Gender.female:
      return "Nő 👩";
    case Gender.male:
      return "Férfi 👨";
    case Gender.other:
      return "Egyéb 🧑";
  }
}
