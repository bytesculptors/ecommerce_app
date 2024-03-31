import 'package:btl/utils/consts/image_paths.dart';
import 'package:btl/utils/helpers/helper_functions.dart';
import 'package:flutter/material.dart';

class OnBoardingScreen extends StatelessWidget {
  const OnBoardingScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          PageView(
            children: [
              Column(
                children: [
                  Image(
                      width: HelperFunctions.screenWidth() * 0.8,
                      height: HelperFunctions.screenHeight() * 0.6,
                      image: const AssetImage(Images.onboarding1)
                  )
                ],
              )
            ],
          )
        ],
      ),
    );
  }
}
