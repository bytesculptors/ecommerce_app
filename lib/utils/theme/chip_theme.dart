import 'package:btl/utils/consts/colors.dart';
import 'package:flutter/material.dart';

class MyChipTheme {
  MyChipTheme._();

  static ChipThemeData lightChipTheme = ChipThemeData(
    checkmarkColor: MyColors.white,
    selectedColor: MyColors.primary,
    disabledColor: MyColors.grey.withOpacity(0.4),
    padding: const EdgeInsets.symmetric(horizontal: 12.0, vertical: 12),
    labelStyle: const TextStyle(color: MyColors.black, fontFamily: 'Poppins'),
  );

  static ChipThemeData darkChipTheme = const ChipThemeData(
    checkmarkColor: MyColors.white,
    selectedColor: MyColors.primary,
    disabledColor: MyColors.darkerGrey,
    padding: EdgeInsets.symmetric(horizontal: 12.0, vertical: 12),
    labelStyle: TextStyle(color: MyColors.white, fontFamily: 'Poppins'),
  );
}
