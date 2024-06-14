import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../../../common/widgets/products/cart/add_remove_cart_button.dart';
import '../../../../../common/widgets/products/cart/cart_item.dart';
import '../../../../../common/widgets/texts/t_product_price_text.dart';
import '../../../../../utils/constants/colors.dart';
import '../../../../../utils/constants/sizes.dart';
import '../../../../../utils/helpers/helper_functions.dart';
import '../../../controllers/product/cart_controller.dart';

class TCartItems extends StatelessWidget {
  const TCartItems({
    super.key,
    this.showAddRemoveButtons = true,
  });

  final bool showAddRemoveButtons;

  @override
  Widget build(BuildContext context) {
    final cartController = CartController.instance;
    return Obx(
      () {
        final cartItemsByStore = cartController.cartItemsByStore;
        return Column(
          children: [
            ...cartItemsByStore.entries.map((entry) {
              final storeId = entry.key;
              final storeItems = entry.value;
              final storeName = storeItems.first.store?.storeName ?? '';

              return Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(storeName, style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                      Checkbox(
                        value: storeItems.every((item) => item.isSelected),
                        onChanged: (bool? value) {
                          cartController.toggleSelectionForStore(storeId);
                        },
                      ),
                    ],
                  ),
                  ListView.separated(
                    shrinkWrap: true,
                    itemCount: storeItems.length,
                    physics: const NeverScrollableScrollPhysics(),
                    separatorBuilder: (context, index) => const SizedBox(height: Sizes.spaceBtwSections),
                    itemBuilder: (context, index) {
                      final item = storeItems[index];
                      return Obx(
                        () {
                          return Column(
                            children: [
                              TCartItem(item: item),
                              if (showAddRemoveButtons) const SizedBox(height: Sizes.spaceBtwItems),
                              if (showAddRemoveButtons)
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                  children: [
                                    Row(
                                      children: [
                                        const SizedBox(width: 70),
                                        TProductQuantityWithAddRemoveButton(
                                          width: 32,
                                          height: 32,
                                          iconSize: Sizes.md,
                                          addBackgroundColor: MyColors.primary,
                                          removeForegroundColor: HelperFunctions.isDarkMode(context) ? MyColors.white : MyColors.black,
                                          removeBackgroundColor: HelperFunctions.isDarkMode(context) ? MyColors.darkerGrey : MyColors.light,
                                          quantity: item.quantity,
                                          add: () => cartController.addOneToCart(item),
                                          remove: () => cartController.removeOneFromCart(item),
                                        ),
                                      ],
                                    ),
                                    TProductPriceText(price: (item.price * item.quantity).toStringAsFixed(1)),
                                  ],
                                ),
                            ],
                          );
                        },
                      );
                    },
                  ),
                ],
              );
            }).toList(),
            const SizedBox(height: Sizes.spaceBtwSections),
            Text(
              'Total: \$${cartController.totalSelectedPrice.toStringAsFixed(2)}',
              style: const TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
              ),
            ),
          ],
        );
      },
    );
  }
}