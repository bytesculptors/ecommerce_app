import 'package:btl/utils/consts/colors.dart';
import 'package:btl/utils/consts/image_paths.dart';
import 'package:btl/utils/consts/sizes.dart';
import 'package:flutter/material.dart';

class SocialButtons extends StatelessWidget {
  const SocialButtons({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Row (
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Container(
          decoration: BoxDecoration(border: Border.all(color: MyColors.grey), borderRadius: BorderRadius.circular(100)),
          child: IconButton(
            onPressed: () {},
            icon: const Image(
              width: Sizes.iconMd,
              height: Sizes.iconMd,
              image: AssetImage(Images.googleLogo),
            )
          )
        ),
        const SizedBox(height: Sizes.spaceBetweenItems),
        Container(
          decoration: BoxDecoration(border: Border.all(color: MyColors.grey), borderRadius: BorderRadius.circular(100)),
          child: IconButton(
            onPressed: () {},
            icon: const Image(
              width: Sizes.iconMd,
              height: Sizes.iconMd,
              image: AssetImage(Images.facebookLogo),
            )
          )
        )
      ],
    );
  }
}