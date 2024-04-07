import 'package:btl/utils/consts/colors.dart';
import 'package:btl/utils/consts/sizes.dart';
import 'package:flutter/material.dart';

class MyAppBarTheme {
  MyAppBarTheme._();

  static const lightAppBarTheme = AppBarTheme(
      elevation: 0,
      centerTitle: false,
      scrolledUnderElevation: 0,
      backgroundColor: Colors.transparent,
      surfaceTintColor: Colors.transparent,
      iconTheme: IconThemeData(color: MyColors.black, size: Sizes.iconMd),
      actionsIconTheme: IconThemeData(color: MyColors.black, size: Sizes.iconMd),
      titleTextStyle: TextStyle(fontSize: 18, fontWeight: FontWeight.w600, color: MyColors.black),
  );

  static const darkAppBarTheme = AppBarTheme(
    elevation: 0,
    centerTitle: false,
    scrolledUnderElevation: 0,
    backgroundColor: Colors.transparent,
    surfaceTintColor: Colors.transparent,
    iconTheme: IconThemeData(color: MyColors.black, size: Sizes.iconMd),
    actionsIconTheme: IconThemeData(color: MyColors.white, size: Sizes.iconMd),
    titleTextStyle: TextStyle(fontSize: 18.0, fontWeight: FontWeight.w600, color: MyColors.white, fontFamily: 'Poppins'),
  );
}