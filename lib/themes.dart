import 'package:flutter/material.dart';

class FontSizes {
  static const extraSmall = 14.0;
  static const small = 16.0;
  static const standar = 18.0;
  static const large = 20.0;
  static const extraLarge = 24.0;
  static const doubleExtraLarge = 26.0;
}

ThemeData LightMode = ThemeData(
    brightness: Brightness.light,
    colorScheme: ColorScheme.light(
      background: Color(0xffffffff),
      primary: Color(0xff3369ff),
      secondary: Color(0xffffffff),
    ),
    textTheme: TextTheme(
        titleLarge: TextStyle(
      color: Color(0xff000000),
    )));

ThemeData DarkMode = ThemeData(
  brightness: Brightness.dark,
  colorScheme: ColorScheme.dark(
    background: Color(0xff000000),
    primary: Color(0xff3369ff),
    secondary: Color(0xffffffff),
  ),
  textTheme: TextTheme(
    titleLarge: TextStyle(color: Color(0xffffffff)),
  ),
);
