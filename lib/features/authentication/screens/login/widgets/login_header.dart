import 'package:btl/utils/consts/image_paths.dart';
import 'package:btl/utils/consts/sizes.dart';
import 'package:btl/utils/consts/text_strings.dart';
import 'package:flutter/material.dart';

class LoginHeader extends StatelessWidget {
  const LoginHeader({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Image(
            height: 140,
            image: AssetImage(Images.appLogo),
          ),
          Text(Texts.loginTitle,
              style: Theme.of(context).textTheme.headlineMedium),
          const SizedBox(height: Sizes.sm),
          Text(
            Texts.loginSubTitle,
            style: Theme.of(context).textTheme.bodyMedium,
          )
        ]);
  }
}
