import 'package:btl/utils/consts/colors.dart';
import 'package:flutter/material.dart';

class MyAppBarTheme {
  MyAppBarTheme._();

  static const appBarTheme = AppBarTheme(
      elevation: 0,
      centerTitle: false,
      scrolledUnderElevation: 0,
      backgroundColor: MyColors.transparent,
      surfaceTintColor: MyColors.transparent,
      iconTheme: IconThemeData(color: MyColors.black, size: 24),
      actionsIconTheme: IconThemeData(color: MyColors.black, size: 24),
      titleTextStyle: TextStyle(fontSize: 18, fontWeight: FontWeight.w600, color: MyColors.black),
  );
}