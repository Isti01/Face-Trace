import 'package:flutter/material.dart';

enum AppColor {
  red,
  green,
  blue,
  purple,
}

extension AppColorExtension on AppColor {
  AppColor get next {
    final colors = AppColor.values;
    return colors[(colors.indexOf(this) + 1) % colors.length];
  }

  ColorSwatch get color {
    switch (this) {
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

  List<Color> get colors {
    switch (this) {
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

  static AppColor parse(String source) {
    switch (source?.toLowerCase()) {
      case 'red':
        return AppColor.red;
      case 'purple':
        return AppColor.purple;
      case 'blue':
        return AppColor.blue;
      default:
        return AppColor.green;
    }
  }
}
