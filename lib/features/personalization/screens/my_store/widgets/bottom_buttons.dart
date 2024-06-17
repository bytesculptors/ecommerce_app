import 'package:btl/features/shop/controllers/product/product_controller.dart';
import 'package:btl/features/shop/models/product_model.dart';
import 'package:btl/utils/constants/colors.dart';
import 'package:btl/utils/constants/sizes.dart';
import 'package:btl/utils/helpers/helper_functions.dart';
import 'package:flutter/material.dart';
import 'package:iconsax/iconsax.dart';

class BottomEditDeleteButtons extends StatelessWidget {
  const BottomEditDeleteButtons({
    super.key,
    required this.product
  });

  final ProductModel product;

  @override
  Widget build(BuildContext context) {
    final dark = HelperFunctions.isDarkMode(context);
    final controller = ProductController.instance;

    return Container(
      padding: const EdgeInsets.symmetric(
          horizontal: Sizes.defaultSpace, vertical: Sizes.defaultSpace / 2),
      decoration: BoxDecoration(
        color: dark ? MyColors.darkerGrey : MyColors.light,
        borderRadius: const BorderRadius.only(
          topLeft: Radius.circular(Sizes.cardRadiusLg),
          topRight: Radius.circular(Sizes.cardRadiusLg),
        ),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          SizedBox(
              width: 120,
              child: OutlinedButton(
                  style: OutlinedButton.styleFrom(
                    padding: const EdgeInsets.all(Sizes.md),
                    side: const BorderSide(color: MyColors.primary),
                  ),
                  child: const Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(Iconsax.edit, color: MyColors.primary),
                      SizedBox(width: Sizes.spaceBtwItems / 2),
                      Text('Edit', style: TextStyle(color: MyColors.primary))
                    ],
                  ),
                  onPressed: () {})),
          SizedBox(
              width: 120,
              child: OutlinedButton(
                  style: OutlinedButton.styleFrom(
                    padding: const EdgeInsets.all(Sizes.md),
                    side: const BorderSide(color: Colors.red),
                  ),
                  child: const Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(Iconsax.trash, color: Colors.red),
                      SizedBox(width: Sizes.spaceBtwItems / 2),
                      Text('Delete', style: TextStyle(color: Colors.red)),
                    ],
                  ),
                  onPressed: () => controller.showConfirmDialog(context, product))),
        ],
      ),
    );
  }
}
