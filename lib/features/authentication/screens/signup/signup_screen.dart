import 'package:btl/common/widgets/appbar/appbar.dart';
import 'package:btl/common/widgets/login_signup/form_divider.dart';
import 'package:btl/common/widgets/login_signup/social_buttons.dart';
import 'package:btl/utils/constants/sizes.dart';
import 'package:btl/utils/constants/text_strings.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import 'widgets/signup_form.dart';

class SignupScreen extends StatelessWidget {
  const SignupScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const MyAppBar(showBackArrow: true),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(Sizes.defaultSpace),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              ///  Title
              Text(Texts.signupTitle, style: Theme.of(context).textTheme.headlineMedium),

              /// Form
              const SignupForm(),
              const SizedBox(height: Sizes.spaceBtwSections),

              /// Divider
              FormDivider(dividerText: Texts.orSignUpWith.capitalize!),
              const SizedBox(height: Sizes.spaceBtwSections),

              /// Social Buttons
              const SocialButtons()
            ],
          ),
        ),
      ),
    );
  }
}
