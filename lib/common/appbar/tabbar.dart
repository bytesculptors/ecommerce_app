import 'package:btl/utils/consts/colors.dart';
import 'package:btl/utils/device/device_utils.dart';
import 'package:btl/utils/helpers/helper_functions.dart';
import 'package:flutter/material.dart';

/// A custom tab bar widget with customizable appearance.
class MyTabBar extends StatelessWidget implements PreferredSizeWidget {
  /// Default constructor for the TTabBar.
  ///
  /// Parameters:
  ///   - tabs: List of widgets representing the tabs.
  const MyTabBar({super.key, required this.tabs});

  final List<Widget> tabs;

  @override
  Widget build(BuildContext context) {
    final dark = HelperFunctions.isDarkMode(context);
    return Material(
      color: dark ? MyColors.black : MyColors.white, // Background color of the tab bar
      child: TabBar(
        tabs: tabs, // List of tabs
        isScrollable: true, // Enable scrollable tabs
        indicatorColor: MyColors.primary, // Color of the tab indicator
        labelColor: dark ? MyColors.white : MyColors.primary, // Color of the selected tab label
        unselectedLabelColor: MyColors.darkGrey, // Color of unselected tab labels
      ),
    );
  }

  @override
  Size get preferredSize => Size.fromHeight(DeviceUtils.getAppBarHeight()); // Preferred size of the tab bar
}