import 'package:btl/features/onboarding/controllers/onboarding_controller.dart';
import 'package:btl/utils/constants/colors.dart';
import 'package:btl/utils/constants/sizes.dart';
import 'package:btl/utils/device/device_utils.dart';
import 'package:flutter/material.dart';

class OnBoardingSkip extends StatelessWidget {
  const OnBoardingSkip({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Positioned(
      top: DeviceUtils.getAppBarHeight(), 
      right: Sizes.defaultSpace, 
      child: TextButton(
        onPressed: () => OnBoardingController.instance.skipPage(), 
        child: const Text('Skip', style: TextStyle(color: MyColors.darkerGrey)),
      )
    );
  }
}