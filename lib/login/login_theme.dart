import 'package:face_app/util/constants.dart';
import 'package:flutter/material.dart';

final _origin = ThemeData(primarySwatch: Colors.blue);

get _textTheme => _origin.textTheme;

get loginTheme => _origin.copyWith(
      accentColor: Colors.white38,
      canvasColor: Colors.transparent,
      scaffoldBackgroundColor: Colors.transparent,
      textTheme: _origin.textTheme.apply(
        bodyColor: AppTextColor,
        displayColor: AppTextColor,
      ),
      cursorColor: Colors.white,
      buttonTheme: ButtonThemeData(shape: AppBorder),
      inputDecorationTheme: InputDecorationTheme(
        filled: true,
        contentPadding: EdgeInsets.symmetric(vertical: 16, horizontal: 12),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide.none,
        ),
        labelStyle: _textTheme.title.copyWith(color: Colors.white),
        hintStyle: _textTheme.title.copyWith(color: Colors.white),
      ),
      disabledColor: Colors.white38,
      iconTheme: IconThemeData(color: Colors.white),
      unselectedWidgetColor: Colors.white38,
      hintColor: Colors.white,
    );
