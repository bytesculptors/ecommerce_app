import 'package:btl/common/widgets/layouts/grid_layout.dart';
import 'package:btl/common/widgets/products/product_cards/product_card_vertical.dart';
import 'package:btl/common/widgets/shimmers/vertical_product_shimmer.dart';
import 'package:btl/features/personalization/screens/my_store/add_new_product.dart';
import 'package:btl/features/personalization/screens/my_store/widgets/product_card.dart';
import 'package:btl/features/shop/controllers/product/product_controller.dart';
import 'package:btl/utils/constants/colors.dart';
import 'package:btl/utils/constants/sizes.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:iconsax/iconsax.dart';

class ProductTab extends StatelessWidget {
  const ProductTab({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = Get.put(ProductController());
    return Scaffold(
      body: Obx(
        () {
          // Display loader while products are loading
          if (controller.isLoading.value) {
            return const TVerticalProductShimmer();
          }

          // Check if no store products are found
          if (controller.storeProducts.isEmpty) {
            return Center(
                child: Text('No Products Found!',
                    style: Theme.of(context).textTheme.bodyMedium));
          } else {
            // Products Found! 🎊
            return Container(
                padding: const EdgeInsets.all(Sizes.defaultSpace),
                child: TGridLayout(
                  itemCount: controller.storeProducts.length,
                  itemBuilder: (_, index) => MyStoreProductCard(
                      product: controller.storeProducts[index],
                      isNetworkImage: true),
                ));
          }
        },
      ),

      /// Add new product button
      floatingActionButton: FloatingActionButton(
        backgroundColor: MyColors.primary,
        onPressed: () => Get.to(() => AddNewProductScreen()),
        child: const Icon(Iconsax.add, color: MyColors.white),
      ),
    );
  }
}
