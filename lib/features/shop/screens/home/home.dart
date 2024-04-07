import 'package:btl/features/shop/controllers/product/product_controller.dart';
import 'package:btl/utils/consts/sizes.dart';
import 'package:btl/utils/consts/text_strings.dart';
import 'package:btl/utils/device/device_utils.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../../common/widgets/custom_shapes/containers/primary_header_container.dart';
import '../../../../common/widgets/layouts/grid_layout.dart';
import '../../../../common/widgets/products/product_cards/product_card_vertical.dart';
import '../../../../common/widgets/shimmers/vertical_product_shimmer.dart';
import '../../../../common/widgets/texts/section_heading.dart';
import '../../../../data/repositories/product/product_repository.dart';
import '../all_products/all_products.dart';
import 'widgets/header_categories.dart';
import 'widgets/header_search_container.dart';
import 'widgets/home_appbar.dart';
import 'widgets/promo_slider.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = Get.put(ProductController());
    return Scaffold(
      body: SingleChildScrollView(
        child: Column(
          children: [
            /// Header
            const TPrimaryHeaderContainer(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  /// -- Appbar
                  THomeAppBar(),
                  SizedBox(height: Sizes.spaceBtwSections),

                  /// -- Searchbar
                  TSearchContainer(text: 'Search in Store', showBorder: false),
                  SizedBox(height: Sizes.spaceBtwSections),

                  /// -- Categories
                  THeaderCategories(),
                  SizedBox(height: Sizes.spaceBtwSections * 2),
                ],
              ),
            ),

            /// -- Body
            Container(
              padding: const EdgeInsets.all(Sizes.defaultSpace),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  /// -- Promo Slider 1
                  const TPromoSlider(),
                  const SizedBox(height: Sizes.spaceBtwSections),

                  /// -- Products Heading
                  TSectionHeading(
                    title: Texts.popularProducts,
                    onPressed: () => Get.to(
                      () => AllProducts(
                        title: Texts.popularProducts,
                        futureMethod: ProductRepository.instance.getAllFeaturedProducts(),
                      ),
                    ),
                  ),
                  const SizedBox(height: Sizes.spaceBtwItems),

                  /// Products Section
                  Obx(
                    () {
                      // Display loader while products are loading
                      if (controller.isLoading.value) return const TVerticalProductShimmer();

                      // Check if no featured products are found
                      if (controller.featuredProducts.isEmpty) {
                        return Center(child: Text('No Data Found!', style: Theme.of(context).textTheme.bodyMedium));
                      } else {
                        // Featured Products Found! 🎊
                        return TGridLayout(
                          itemCount: controller.featuredProducts.length,
                          itemBuilder: (_, index) =>
                              TProductCardVertical(product: controller.featuredProducts[index], isNetworkImage: true),
                        );
                      }
                    },
                  ),

                  SizedBox(height: DeviceUtils.getBottomNavigationBarHeight() + Sizes.defaultSpace),
                ],
              ),
            )
          ],
        ),
      ),
    );
  }
}
