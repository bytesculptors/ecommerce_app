import 'package:btl/features/authentication/controllers/login_in_controller.dart';
import 'package:btl/utils/constants/colors.dart';
import 'package:btl/utils/constants/image_paths.dart';
import 'package:btl/utils/constants/sizes.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class SocialButtons extends StatelessWidget {
  const SocialButtons({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    final controller = Get.put(LoginController());
    return Row (
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        // Google
        Container(
          padding: const EdgeInsets.all(Sizes.xs),
          decoration: BoxDecoration(border: Border.all(color: MyColors.grey), borderRadius: BorderRadius.circular(100)),
          child: IconButton(
            onPressed: () => controller.googleSignIn(),
            icon: const Image(
              width: Sizes.iconMd,
              height: Sizes.iconMd,
              image: AssetImage(Images.googleLogo),
            )
          )
        ),
        const SizedBox(height: Sizes.spaceBtwItems),

        // Facebook
        Container(
          padding: const EdgeInsets.all(Sizes.xs),
          decoration: BoxDecoration(border: Border.all(color: MyColors.grey), borderRadius: BorderRadius.circular(100)),
          child: IconButton(
            onPressed: () => controller.facebookSignIn(),
            icon: const Image(
              width: Sizes.iconMd + 8,
              height: Sizes.iconMd + 8,
              image: AssetImage(Images.facebookLogo),
            )
          )
        )
      ],
    );
  }
}