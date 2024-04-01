import 'package:btl/utils/consts/colors.dart';
import 'package:btl/utils/theme/appbar_theme.dart';
import 'package:btl/utils/theme/button_theme.dart';
import 'package:btl/utils/theme/text_theme.dart';
import 'package:flutter/material.dart';

class AppTheme {
  AppTheme._();

  static ThemeData appTheme = ThemeData(
    useMaterial3: true,
    fontFamily: 'Poppins',
    brightness: Brightness.light,
    primaryColor: MyColors.darkGreen,
    textTheme: MyTextTheme.textTheme,
    scaffoldBackgroundColor: MyColors.white,
    elevatedButtonTheme: MyElevatedButtonTheme.elevatedButtonTheme,
    appBarTheme: MyAppBarTheme.appBarTheme
  );
}