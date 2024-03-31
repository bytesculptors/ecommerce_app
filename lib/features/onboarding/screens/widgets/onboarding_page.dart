import 'package:btl/utils/consts/sizes.dart';
import 'package:btl/utils/helpers/helper_functions.dart';
import 'package:flutter/material.dart';

class OnBoardingPage extends StatelessWidget {
  const OnBoardingPage({
    super.key, required this.image, required this.title, required this.subTile,
  });

  final String image, title, subTile;

  @override
  Widget build(BuildContext context) {
    return Padding(
        padding: const EdgeInsets.all(Sizes.defaultSpace),
        child: Column(
          children: [
            Image(
                width: HelperFunctions.screenWidth() * 0.8,
                height: HelperFunctions.screenHeight() * 0.6,
                image: AssetImage(image)),
            Text(
              title,
              style: Theme.of(context).textTheme.headlineMedium,
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: Sizes.spaceBetweenItems),
            Text(
              subTile,
              style: Theme.of(context).textTheme.bodyMedium,
              textAlign: TextAlign.center,
            )
          ],
        ));
  }
}