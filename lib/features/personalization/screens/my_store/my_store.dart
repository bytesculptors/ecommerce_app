import 'package:btl/common/widgets/appbar/tabbar.dart';
import 'package:btl/common/widgets/custom_shapes/containers/primary_header_container.dart';
import 'package:btl/common/widgets/list_tiles/store_info_tile.dart';
import 'package:btl/features/personalization/controllers/store_controller.dart';
import 'package:btl/features/personalization/controllers/user_controller.dart';
import 'package:btl/features/personalization/screens/my_store/widgets/category_tab.dart';
import 'package:btl/features/personalization/screens/my_store/widgets/order_tab.dart';
import 'package:btl/features/personalization/screens/my_store/widgets/product_tab.dart';
import 'package:btl/features/personalization/screens/my_store/widgets/statistics_tab.dart';
import 'package:btl/features/shop/controllers/product/product_controller.dart';
import 'package:btl/features/shop/screens/home/widgets/header_search_container.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:iconsax/iconsax.dart';

import '../../../../utils/constants/colors.dart';
import '../../../../utils/constants/sizes.dart';

class MyStoreScreen extends StatelessWidget {
  const MyStoreScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final storeController = Get.put(StoreController());
    final productController = ProductController.instance;
    final userController = UserController.instance;
    storeController.fetchStoreRecord(userController.user.value.storeId);
    productController.fetchStoreProducts(userController.user.value.storeId!);
    return DefaultTabController(
        length: 4,
        child: Scaffold(
            body: Column(
          children: [
            TPrimaryHeaderContainer(
              child: Column(
                children: [
                  AppBar(
                      leading: IconButton(
                          onPressed: () => Get.back(),
                          icon: const Icon(Iconsax.arrow_left,
                              color: MyColors.white))),

                  /// User Profile Card
                StoreInfoTile(
                      onPressed: () {}),
                  const Padding(
                    padding: EdgeInsets.all(Sizes.defaultSpace),
                    child: TSearchContainer(
                      text: 'Search in Shop',
                      showBorder: true,
                      showBackground: false,
                      padding: EdgeInsets.zero),
                  ),
                  const SizedBox(height: Sizes.spaceBtwSections),
                ],
              ),
            ),
            Expanded(
                child: NestedScrollView(
              headerSliverBuilder: (_, innerBoxIsScrolled) {
                return [
                  const SliverAppBar(
                    automaticallyImplyLeading: false, 
                    pinned: true,
                    floating: true,
                    centerTitle: true,
                    title: MyTabBar(tabs: [
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
            )),
          ],
        )));
  }
}
