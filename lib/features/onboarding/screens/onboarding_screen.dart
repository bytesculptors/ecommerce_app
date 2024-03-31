import 'package:btl/features/onboarding/onboarding_controller.dart';
import 'package:btl/features/onboarding/screens/widgets/dot_navigation.dart';
import 'package:btl/features/onboarding/screens/widgets/next_button.dart';
import 'package:btl/features/onboarding/screens/widgets/onboarding_page.dart';
import 'package:btl/features/onboarding/screens/widgets/skip_button.dart';
import 'package:btl/utils/consts/image_paths.dart';
import 'package:btl/utils/consts/text_strings.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';


class OnBoardingScreen extends StatelessWidget {
  const OnBoardingScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = Get.put(OnBoardingController());
    return Scaffold(
      body: Stack(
        children: [
          // Horizontal Scrollable
          PageView(
            controller: controller.pageController,
            onPageChanged: controller.updatePageIndicator,
            children: const [
              OnBoardingPage(
                image: Images.onBoarding1,
                title: Texts.onBoardingTitle1,
                subTile: Texts.onBoardingSubTitle1,
              ),
              OnBoardingPage(
                image: Images.onBoarding2,
                title: Texts.onBoardingTitle2,
                subTile: Texts.onBoardingSubTitle2,
              ),
              OnBoardingPage(
                image: Images.onBoarding3,
                title: Texts.onBoardingTitle3,
                subTile: Texts.onBoardingSubTitle3,
              ),
            ],
          ),
          // Skip Button
          const OnBoardingSkip(),

          // Dot Navigation
          const OnBoardingDotNavigation(),
          const OnBoardingNextButton(),
        ],
      ),
    );
  }
}


