import 'package:btl/features/personalization/screens/my_store/widgets/bottom_buttons.dart';
import 'package:btl/features/personalization/screens/my_store/widgets/product_detail_slider.dart';
import 'package:btl/features/shop/models/product_model.dart';
import 'package:btl/features/shop/screens/product_detail/widgets/product_attributes.dart';
import 'package:btl/features/shop/screens/product_detail/widgets/product_meta_data.dart';
import 'package:btl/features/shop/screens/product_detail/widgets/rating_share_widget.dart';
import 'package:btl/features/shop/screens/product_reviews/product_reviews.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:iconsax/iconsax.dart';
import 'package:readmore/readmore.dart';

import '../../../../common/widgets/texts/section_heading.dart';
import '../../../../utils/constants/sizes.dart';

class MyProductDetailScreen extends StatelessWidget {
  const MyProductDetailScreen({super.key, required this.product});

  final ProductModel product;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            /// 1 - Product Image Slider
            MyProductImageSlider(product: product),

            /// 2 - Product Details
            Container(
              padding: const EdgeInsets.only(right: Sizes.defaultSpace, left: Sizes.defaultSpace, bottom: Sizes.defaultSpace),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  /// - Rating & Share
                  const TRatingAndShare(),

                  /// - Price, Title, Stock, & Brand
                  TProductMetaData(product: product),
                  const SizedBox(height: Sizes.spaceBtwSections / 2),

                  /// -- Attributes
                  // If Product has no variations do not show attributes as well.
                  if (product.productVariations != null && product.productVariations!.isNotEmpty) TProductAttributes(product: product),
                  if (product.productVariations != null && product.productVariations!.isNotEmpty) const SizedBox(height: Sizes.spaceBtwSections),
                  const SizedBox(height: Sizes.spaceBtwSections / 2),

                  /// - Description
                  const TSectionHeading(title: 'Description', showActionButton: false),
                  const SizedBox(height: Sizes.spaceBtwItems),
                  // Read more package
                  ReadMoreText(
                    product.description!,
                    trimLines: 2,
                    colorClickableText: Colors.pink,
                    trimMode: TrimMode.Line,
                    trimCollapsedText: ' Show more',
                    trimExpandedText: ' Less',
                    moreStyle: const TextStyle(fontSize: 14, fontWeight: FontWeight.w800),
                    lessStyle: const TextStyle(fontSize: 14, fontWeight: FontWeight.w800),
                  ),
                  const SizedBox(height: Sizes.spaceBtwSections),

                  /// - Reviews
                  const Divider(),
                  const SizedBox(height: Sizes.spaceBtwItems),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const TSectionHeading(title: 'Reviews (199)', showActionButton: false),
                      IconButton(
                        icon: const Icon(Iconsax.arrow_right_3, size: 18),
                        onPressed: () => Get.to(() => const ProductReviewsScreen(), fullscreenDialog: true),
                      )
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
      bottomNavigationBar: BottomEditDeleteButtons(product: product),
    );
  }
}
