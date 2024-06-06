import 'package:btl/common/widgets/appbar/tabbar.dart';
import 'package:btl/common/widgets/custom_shapes/containers/primary_header_container.dart';
import 'package:btl/common/widgets/list_tiles/user_profile_tile.dart';
import 'package:btl/features/personalization/screens/my_store/widgets/category_tab.dart';
import 'package:btl/features/personalization/screens/my_store/widgets/order_tab.dart';
import 'package:btl/features/personalization/screens/my_store/widgets/product_tab.dart';
import 'package:btl/features/personalization/screens/my_store/widgets/statistics_tab.dart';
import 'package:btl/features/personalization/screens/profile/profile.dart';
import 'package:btl/features/personalization/screens/setting/settings.dart';
import 'package:btl/features/shop/screens/home/widgets/header_search_container.dart';
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
                      title: Text('My Shop',
                          style: Theme.of(context)
                              .textTheme
                              .headlineMedium!
                              .apply(color: MyColors.white))),

                  /// User Profile Card
                  TUserProfileTile(
                      onPressed: () => Get.to(() => const ProfileScreen())),
                  const SizedBox(height: Sizes.spaceBtwItems),
                  const TSearchContainer(
                      text: 'Search in Shop',
                      showBorder: true,
                      showBackground: false,
                      padding: EdgeInsets.zero),
                  const SizedBox(height: Sizes.spaceBtwSections),
                ],
              ),
            ),
            NestedScrollView(
              headerSliverBuilder: (_, innerBoxIsScrolled) {
                return [
                  const SliverAppBar(
                    pinned: true,
                    floating: true,
                    bottom: MyTabBar(tabs: [
                      Tab(text: 'Products'),
                      Tab(text: 'Categories'),
                      Tab(text: 'Orders'),
                      Tab(text: 'Statistics')
                    ]),
                  )
                ];
              },
              body: const TabBarView(
                children: [
                  ProductTab(),
                  CategoryTab(),
                  OrderTab(),
                  StatisticsTab()
                ],
              ),
            )
          ],
        ))),
      ),
    );
  }
}
