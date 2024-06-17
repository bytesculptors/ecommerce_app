import 'package:btl/common/styles/shadows.dart';
import 'package:btl/common/widgets/custom_shapes/containers/rounded_container.dart';
import 'package:btl/common/widgets/images/t_rounded_image.dart';
import 'package:btl/common/widgets/products/product_cards/widgets/product_card_pricing_widget.dart';
import 'package:btl/common/widgets/products/product_cards/widgets/product_sale_tag.dart';
import 'package:btl/common/widgets/texts/t_brand_title_text_with_verified_icon.dart';
import 'package:btl/common/widgets/texts/t_product_title_text.dart';
import 'package:btl/features/personalization/screens/my_store/product_detail.dart';
import 'package:btl/features/shop/controllers/product/product_controller.dart';
import 'package:btl/features/shop/models/product_model.dart';
import 'package:btl/utils/constants/colors.dart';
import 'package:btl/utils/constants/enums.dart';
import 'package:btl/utils/constants/sizes.dart';
import 'package:btl/utils/helpers/helper_functions.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:iconsax/iconsax.dart';

class MyStoreProductCard extends StatelessWidget {
  const MyStoreProductCard(
      {super.key, required this.product, this.isNetworkImage = true});

  final ProductModel product;
  final bool isNetworkImage;

  @override
  Widget build(BuildContext context) {
    final productController = ProductController.instance;
    final salePercentage = productController.calculateSalePercentage(
        product.price, product.salePrice);
    final dark = HelperFunctions.isDarkMode(context);

    return GestureDetector(
      onTap: () => Get.to(() => MyProductDetailScreen(product: product)),

      /// Container with side paddings, color, edges, radius and shadow.
      child: Container(
        width: 180,
        padding: const EdgeInsets.all(1),
        decoration: BoxDecoration(
          boxShadow: [TShadowStyle.verticalProductShadow],
          borderRadius: BorderRadius.circular(Sizes.productImageRadius),
          color: dark ? MyColors.darkerGrey : MyColors.white,
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            /// Thumbnail, Discount Tag
            TRoundedContainer(
              height: 180,
              width: 180,
              padding: const EdgeInsets.all(Sizes.sm),
              backgroundColor: dark ? MyColors.dark : MyColors.light,
              child: Stack(
                children: [
                  /// -- Thumbnail Image
                  Center(
                      child: TRoundedImage(
                          imageUrl: product.thumbnail,
                          applyImageRadius: true,
                          isNetworkImage: isNetworkImage)),

                  /// -- Sale Tag
                  if (salePercentage != null)
                    ProductSaleTagWidget(salePercentage: salePercentage),
                ],
              ),
            ),
            const SizedBox(height: Sizes.spaceBtwItems / 2),

            /// -- Details
            Padding(
              padding: const EdgeInsets.only(left: Sizes.sm),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  TProductTitleText(title: product.title, smallSize: true),
                  const SizedBox(height: Sizes.spaceBtwItems / 2),
                  TBrandTitleWithVerifiedIcon(
                      title: product.brand!.name,
                      brandTextSize: TextSizes.small),
                ],
              ),
            ),

            /// Price
            /// Use Spacer() to utilize all the space and set the price at the bottom.
            /// This usually happens when Product title is in single line or 2 lines (Max)
            const Spacer(),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                /// Pricing
                PricingWidget(product: product),
                GestureDetector(
                    onTap: () =>
                        Get.to(() => MyProductDetailScreen(product: product)),
                    child: AnimatedContainer(
                      curve: Curves.easeInOutCubicEmphasized,
                      decoration: const BoxDecoration(
                        color: MyColors.primary,
                        borderRadius: BorderRadius.only(
                          topLeft: Radius.circular(Sizes.cardRadiusMd),
                          bottomRight:
                              Radius.circular(Sizes.productImageRadius),
                        ),
                      ),
                      duration: const Duration(milliseconds: 100),
                      child: const SizedBox(
                        width: Sizes.iconLg * 1.2,
                        height: Sizes.iconLg * 1.2,
                        child: Center(
                          child: Icon(Iconsax.eye, color: MyColors.white),
                        ),
                      ),
                    ))
              ],
            ),
          ],
        ),
      ),
    );
  }
}
