import 'package:ecommerce_app_mobile/common/widgets/custom_shapes/container/rounded_container.dart';
import 'package:ecommerce_app_mobile/utils/constants/colors.dart';
import 'package:ecommerce_app_mobile/utils/constants/sizes.dart';
import 'package:flutter/material.dart';
import 'package:iconsax/iconsax.dart';

class VoucherList extends StatelessWidget {
  const VoucherList({
    super.key,
    required this.dark,
  });

  final bool dark;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(TSizes.spaceBtwItems),
      child: ListView.separated(
        shrinkWrap: true,
        itemCount: 2,
        itemBuilder: (context, index) {
          return Column(children: [
            TRoundedContainer(
                showBorder: true,
                backgroundColor: dark ? TColors.dark : TColors.light,
                padding: const EdgeInsets.all(TSizes.xs),
                child: Column(mainAxisSize: MainAxisSize.min, children: [
                  //-- Row 2
                  Row(children: [
                    Expanded(
                      flex: 1,
                      child: Image.asset(
                        'assets/images/voucher/voucher25.png',
                        fit: BoxFit.cover,
                      ),
                    ),
                    const SizedBox(
                      width: 20,
                    ),
                    Expanded(
                      flex: 3,
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Container(
                            height: 80,
                            child: Column(
                              mainAxisSize: MainAxisSize.min,
                              crossAxisAlignment: CrossAxisAlignment.start,
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text('Giảm 50%',
                                        style: Theme.of(context)
                                            .textTheme
                                            .titleMedium),
                                    Text(
                                      "Gỉảm đơn tối thiểu 70k",
                                      style: Theme.of(context)
                                          .textTheme
                                          .labelLarge,
                                    )
                                  ],
                                ),
                                Text(
                                  "Hạn sử dụng: 01/07/2024",
                                  style: Theme.of(context)
                                      .textTheme
                                      .labelSmall
                                      ?.copyWith(color: Colors.red),
                                )
                              ],
                            ),
                          ),
                          Container(
                              child: TextButton(
                            child: Text("Dùng ngay"),
                            onPressed: () {},
                          )),
                        ],
                      ),
                    ),
                  ])
                ])),
            const SizedBox(height: TSizes.sm),
            TRoundedContainer(
                showBorder: true,
                backgroundColor: dark ? TColors.dark : TColors.light,
                padding: const EdgeInsets.all(TSizes.xs),
                child: Column(mainAxisSize: MainAxisSize.min, children: [
                  //-- Row 2
                  Row(children: [
                    Expanded(
                      flex: 1,
                      child: Image.asset(
                        'assets/images/voucher/voucher25.png',
                        fit: BoxFit.cover,
                      ),
                    ),
                    const SizedBox(
                      width: 20,
                    ),
                    Expanded(
                      flex: 3,
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          SizedBox(
                            height: 80,
                            child: Column(
                              mainAxisSize: MainAxisSize.min,
                              crossAxisAlignment: CrossAxisAlignment.start,
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text('Giảm 30%',
                                        style: Theme.of(context)
                                            .textTheme
                                            .titleMedium),
                                    Text(
                                      "Gỉảm đơn tối thiểu 30k",
                                      style: Theme.of(context)
                                          .textTheme
                                          .labelLarge,
                                    )
                                  ],
                                ),
                                Text(
                                  "Hạn sử dụng: 20/06/2024",
                                  style: Theme.of(context)
                                      .textTheme
                                      .labelSmall
                                      ?.copyWith(color: Colors.red),
                                )
                              ],
                            ),
                          ),
                          TextButton(
                            child: const Text("Dùng ngay"),
                            onPressed: () {},
                          ),
                        ],
                      ),
                    ),
                  ])
                ]))
          ]);
        },
        separatorBuilder: (ctx, index) => const SizedBox(height: TSizes.sm),
      ),
    );
  }
}
