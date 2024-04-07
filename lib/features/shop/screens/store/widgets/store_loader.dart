import 'package:flutter/material.dart';

import '../../../../../common/widgets/shimmers/boxes_shimmer.dart';
import '../../../../../common/widgets/shimmers/brands_shimmer.dart';
import '../../../../../common/widgets/shimmers/list_tile_shimmer.dart';
import '../../../../../common/widgets/shimmers/shimmer.dart';
import '../../../../../common/widgets/shimmers/vertical_product_shimmer.dart';
import '../../../../../utils/constants/sizes.dart';

class TStoreShimmerLoader extends StatelessWidget {
  const TStoreShimmerLoader({super.key});

  @override
  Widget build(BuildContext context) {
    return const SingleChildScrollView(
      child: Padding(
        padding: EdgeInsets.all(Sizes.defaultSpace),
        child: Column(
          children: [
            SizedBox(height: Sizes.spaceBtwSections),
            // AppBar
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                TShimmerEffect(width: 100, height: 15),
                TShimmerEffect(width: 55, height: 55, radius: 55),
              ],
            ),
            SizedBox(height: Sizes.spaceBtwSections * 2),
            // Search
            TShimmerEffect(width: double.infinity, height: 55),
            SizedBox(height: Sizes.spaceBtwSections),

            // Heading
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                TShimmerEffect(width: 100, height: 15),
                TShimmerEffect(width: 80, height: 12),
              ],
            ),
            SizedBox(height: Sizes.spaceBtwSections),

            // Brands
            TBrandsShimmer(),
            SizedBox(height: Sizes.spaceBtwSections * 2),

            // Categories
            Row(
              children: [
                Expanded(child: TShimmerEffect(width: 100, height: 15)),
                SizedBox(width: Sizes.spaceBtwItems),
                Expanded(child: TShimmerEffect(width: 100, height: 15)),
                SizedBox(width: Sizes.spaceBtwItems),
                Expanded(child: TShimmerEffect(width: 100, height: 15)),
                SizedBox(width: Sizes.spaceBtwItems),
                Expanded(child: TShimmerEffect(width: 100, height: 15)),
              ],
            ),
            SizedBox(height: Sizes.spaceBtwSections),

            // Category Brands
            TListTileShimmer(),
            SizedBox(height: Sizes.spaceBtwSections),
            TBoxesShimmer(),
            SizedBox(height: Sizes.spaceBtwSections),

            // Products
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                TShimmerEffect(width: 100, height: 15),
                TShimmerEffect(width: 80, height: 12),
              ],
            ),
            SizedBox(height: Sizes.spaceBtwSections),

            TVerticalProductShimmer(),
            SizedBox(height: Sizes.spaceBtwSections * 3),
          ],
        ),
      ),
    );
  }
}
