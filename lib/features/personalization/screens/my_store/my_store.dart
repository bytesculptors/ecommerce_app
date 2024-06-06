import 'package:btl/common/widgets/custom_shapes/containers/primary_header_container.dart';
import 'package:btl/common/widgets/list_tiles/user_profile_tile.dart';
import 'package:btl/features/personalization/screens/profile/profile.dart';
import 'package:btl/features/personalization/screens/setting/settings.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';


import '../../../../common/widgets/appbar/appbar.dart';
import '../../../../utils/constants/colors.dart';
import '../../../../utils/constants/sizes.dart';

class MyStoreScreen extends StatelessWidget {
  const MyStoreScreen({super.key});

  @override
  Widget build(BuildContext context) {
    // final myStoreController = Get.put(MyStoreController());
    return PopScope(
      canPop: false,
      // Intercept the back button press and redirect to Home Screen
      onPopInvoked: (value) async => Get.offAll(const SettingsScreen()),
      child: DefaultTabController(
        length: 4,
        child: Scaffold(
            body: SingleChildScrollView(
                child: Column(
          children: [
            TPrimaryHeaderContainer(
              child: Column(
                children: [
                  /// AppBar
                  MyAppBar(
                      showBackArrow: true,
                      title: Text('My Store',
                          style: Theme.of(context)
                              .textTheme
                              .headlineMedium!
                              .apply(color: MyColors.white))),

                  /// User Profile Card
                  TUserProfileTile(
                      onPressed: () => Get.to(() => const ProfileScreen())),
                  const SizedBox(height: Sizes.spaceBtwSections),
                ],
              ),
            ),
            const TabBarView(
              children: [const ProductTab(), const CategoryTab(), const OrderTab(), const StatisticsTab()],
            ),
          ],
        ))),
      ),
    );
  }
}
