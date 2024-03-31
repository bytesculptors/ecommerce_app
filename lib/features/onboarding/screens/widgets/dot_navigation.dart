import 'package:btl/features/onboarding/controllers/onboarding_controller.dart';
import 'package:btl/utils/consts/colors.dart';
import 'package:btl/utils/consts/sizes.dart';
import 'package:btl/utils/device/device_utils.dart';
import 'package:flutter/material.dart';
import 'package:smooth_page_indicator/smooth_page_indicator.dart';

class OnBoardingDotNavigation extends StatelessWidget {
  const OnBoardingDotNavigation({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    final controller = OnBoardingController.instance;

    return Positioned(
        bottom: DeviceUtils.getBottomNavigationBarHeight() + 25,
        left: Sizes.defaultSpace,
        child: SmoothPageIndicator(
          controller: controller.pageController,
          onDotClicked: controller.dotNavigationClick,
          count: 3,
          effect: const ExpandingDotsEffect(
              activeDotColor: MyColors.dark, dotHeight: 6),
        ));
  }
}
