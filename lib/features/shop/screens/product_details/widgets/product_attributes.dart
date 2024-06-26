import 'package:ecommerce_app_mobile/common/styles/product_price_text.dart';
import 'package:ecommerce_app_mobile/common/styles/product_title_text.dart';
import 'package:ecommerce_app_mobile/common/styles/section_heading.dart';
import 'package:ecommerce_app_mobile/common/widgets/chips/choice_color_chip.dart';
import 'package:ecommerce_app_mobile/common/widgets/chips/choice_size_chip.dart';
import 'package:ecommerce_app_mobile/common/widgets/custom_shapes/container/rounded_container.dart';
import 'package:ecommerce_app_mobile/features/shop/controllers/cart_controller/cart_controller.dart';
import 'package:ecommerce_app_mobile/features/shop/models/product_model/product_model.dart';
import 'package:ecommerce_app_mobile/features/shop/models/product_model/product_variant_model.dart';
import 'package:ecommerce_app_mobile/utils/constants/colors.dart';
import 'package:ecommerce_app_mobile/utils/constants/sizes.dart';
import 'package:ecommerce_app_mobile/utils/helpers/helper_functions.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class TProductAttributes extends StatefulWidget {
  const TProductAttributes(
      {super.key, required this.listVariants, required this.product});

  final List<ProductVariantModel> listVariants;
  final ProductModel product;

  @override
  State<TProductAttributes> createState() => _TProductAttributesState();
}

class _TProductAttributesState extends State<TProductAttributes> {
  int currentIndex = -1;
  bool isViewAllDescription = false;
  int chooseColor = -1;
  int chooseSize = -1;
  List<String> sizeList = [];
  @override
  void initState() {
    super.initState();
    sizeList.add(widget.listVariants[0].size);
    for (int i = 0; i < widget.listVariants.length; i++) {
      for (int j = 0; j < sizeList.length; j++) {
        if (widget.listVariants[i].size != sizeList[j]) {
          sizeList.add(widget.listVariants[i].size);
          continue;
        }
        break;
      }
    }
    Get.put(CartController());
  }

  @override
  Widget build(BuildContext context) {
    final dark = THelperFunctions.isDarkMode(context);
    ProductVariantModel? variant =
        currentIndex > -1 ? widget.listVariants[currentIndex] : null;

    return Column(
      children: [
        /// Selected Attributes
        currentIndex > -1
            ? TRoundedContainer(
                padding: const EdgeInsets.all(TSizes.md),
                backgroundColor: dark ? TColors.darkerGrey : TColors.grey,
                child: Column(
                  children: [
                    /// Title, Price Stack status
                    Row(
                      children: [
                        TSectionHeading(
                          title: 'Variation',
                          showActionButton: true,
                          onPressed: () {
                            setState(() {
                              isViewAllDescription = !isViewAllDescription;
                            });
                          },
                        ),
                        const SizedBox(
                          width: TSizes.spaceBtwItems,
                        ),
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Row(
                              children: [
                                const TProductTitleText(
                                  title: 'Price : ',
                                  smallSize: true,
                                ),

                                /// Actual Price
                                Text(
                                  "\$${variant!.price}",
                                  style: Theme.of(context)
                                      .textTheme
                                      .titleSmall!
                                      .apply(
                                          decoration:
                                              TextDecoration.lineThrough),
                                ),
                                const SizedBox(
                                  width: TSizes.spaceBtwItems,
                                ),

                                /// Sale Price
                                TProductPriceText(
                                    price: priceAfterDis(variant.price,
                                        widget.product.discount!)),
                              ],
                            ),

                            /// Stock
                            Row(
                              children: [
                                const TProductTitleText(
                                  title: 'Stock : ',
                                  smallSize: true,
                                ),
                                variant.quantity > 0
                                    ? Text(
                                        'In Stock',
                                        style: Theme.of(context)
                                            .textTheme
                                            .titleMedium,
                                      )
                                    : Text(
                                        'Out of Stock',
                                        style: Theme.of(context)
                                            .textTheme
                                            .titleMedium
                                            ?.copyWith(
                                                color: Colors.red.shade900),
                                      ),
                              ],
                            ),
                          ],
                        ),
                      ],
                    ),

                    /// Variation Description
                    TProductTitleText(
                      title: variant.descriptionVariant,
                      smallSize: true,
                      maxLines: isViewAllDescription ? 100 : 4,
                    )
                  ],
                ))
            : Container(),
        const SizedBox(
          height: TSizes.spaceBtwItems,
        ),

        /// Attributes
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const TSectionHeading(
              title: 'Colors',
              showActionButton: false,
            ),
            const SizedBox(
              height: TSizes.spaceBtwItems / 2,
            ),
            Wrap(
              spacing: 8,
              children: List.generate(
                  widget.listVariants.length,
                  (index) => TColorChoiceChip(
                        text: widget.listVariants[index].color,
                        selected: chooseColor == index,
                        onSelected: (value) {
                          setState(() {
                            chooseColor = index ;
                            chooseSize = -1;
                            currentIndex = index;
                            CartController.instance.chosenVariant =
                                widget.listVariants[index];
                          });
                        },
                      )),
            )
          ],
        ),
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const TSectionHeading(title: 'Size'),
            const SizedBox(
              height: TSizes.spaceBtwItems / 2,
            ),
            Wrap(
              spacing: 8,
              children: List.generate(
                  sizeList.length,
                  (index) => TSizeChoiceChip(
                        isIndex: index == chooseColor,
                        quantity: variant?.quantity,
                        text: widget.listVariants[index].size,
                        selected: chooseSize == index,
                        onSelected: (value) {
                          setState(() {
                            chooseSize = value ? index : -1;
                          });
                        },
                      )),
            ),
          ],
        ),
      ],
    );
  }
}

String priceAfterDis(double price, int discount) {
  double res = price * ((100 - discount) / 100);
  return res.toStringAsFixed(1);
}

int hexColor(String color) {
  String newColor = '0xff$color';
  return int.parse(newColor);
}
