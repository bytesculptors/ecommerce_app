import 'package:flutter/material.dart';
import '../../../../../common/widgets/custom_shapes/containers/rounded_container.dart';
import '../../../../../common/widgets/images/t_circular_image.dart';
import '../../../../../common/widgets/texts/t_brand_title_text_with_verified_icon.dart';
import '../../../../../common/widgets/texts/t_product_price_text.dart';
import '../../../../../common/widgets/texts/t_product_title_text.dart';
import '../../../../../utils/constants/colors.dart';
import '../../../../../utils/constants/enums.dart';
import '../../../../../utils/constants/sizes.dart';
import '../../../../../utils/helpers/helper_functions.dart';
import '../../../controllers/product/product_controller.dart';
import '../../../models/product_model.dart';

class TProductMetaData extends StatelessWidget {
  const TProductMetaData({
    super.key,
    required this.product,
  });

  final ProductModel product;

  @override
  Widget build(BuildContext context) {
    final controller = ProductController.instance;
    final salePercentage = ProductController.instance.calculateSalePercentage(product.price, product.salePrice);
    final darkMode = HelperFunctions.isDarkMode(context);
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        /// Price & Sale Price
        Row(
          children: [
            /// -- Sale Tag
            if (salePercentage != null)
              Row(
                children: [
                  TRoundedContainer(
                    backgroundColor: MyColors.secondary,
                    radius: Sizes.sm,
                    padding: const EdgeInsets.symmetric(horizontal: Sizes.sm, vertical: Sizes.xs),
                    child: Text('$salePercentage%',
                        style: Theme.of(context).textTheme.labelLarge!.apply(color: MyColors.black)),
                  ),
                  const SizedBox(width: Sizes.spaceBtwItems)
                ],
              ),


            // Actual Price if sale price not null.
            if ((product.productVariations == null || product.productVariations!.isEmpty) && product.salePrice> 0.0)
              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(product.price.toString(), style: Theme.of(context).textTheme.titleSmall!.apply(decoration: TextDecoration.lineThrough),),
                  const SizedBox(width: Sizes.spaceBtwItems)
                ],
              ),

            // Price, Show sale price as main price if sale exist.
            TProductPriceText(price: controller.getProductPrice(product), isLarge: true),
          ],
        ),
        const SizedBox(height: Sizes.spaceBtwItems / 1.5),
        TProductTitleText(title: product.title),
        const SizedBox(height: Sizes.spaceBtwItems / 1.5),
        Row(
          children: [
            const TProductTitleText(title: 'Stock : ', smallSize: true),
            Text(controller.getProductStockStatus(product), style: Theme.of(context).textTheme.titleMedium),
          ],
        ),
        const SizedBox(height: Sizes.spaceBtwItems / 2),

        /// Brand
        Row(
          children: [
            TCircularImage(
              width: 32,
              height: 32,
              isNetworkImage: true,
              image: product.brand!.image,
              overlayColor: darkMode ? MyColors.white : MyColors.black,
            ),
            TBrandTitleWithVerifiedIcon(title: product.brand!.name, brandTextSize: TextSizes.medium),
          ],
        ),
      ],
    );
  }
}
