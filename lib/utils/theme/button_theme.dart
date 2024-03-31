import 'package:btl/utils/consts/colors.dart';
import 'package:flutter/material.dart';

class MyElevatedButtonTheme {
  MyElevatedButtonTheme._();

  static final elevatedButtonTheme = ElevatedButtonThemeData(
    style: ElevatedButton.styleFrom(
      elevation: 0,
      foregroundColor: MyColors.white,
      backgroundColor: MyColors.darkGreen,
      disabledForegroundColor: MyColors.grey,
      disabledBackgroundColor: MyColors.grey,
      side: const BorderSide(color: MyColors.darkGreen),
      padding: const EdgeInsets.symmetric(vertical: 18),
      textStyle: const TextStyle(fontSize: 16, color: MyColors.white, fontWeight: FontWeight.w600),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12))
    )

  );
}