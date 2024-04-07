import 'package:btl/common/styles/spacing_styles.dart';
import 'package:btl/common/widgets/login_signup/form_divider.dart';
import 'package:btl/common/widgets/login_signup/social_buttons.dart';
import 'package:btl/features/authentication/screens/login/widgets/login_form.dart';
import 'package:btl/features/authentication/screens/login/widgets/login_header.dart';
import 'package:btl/utils/constants/sizes.dart';
import 'package:btl/utils/constants/text_strings.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class LoginScreen extends StatelessWidget {
  const LoginScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
          child: Padding(
              padding: SpacingStyle.paddingWithAppBarHeight,
              child: Column(
                children: [
                  // logo, title, subtitle
                  const LoginHeader(),

                  // input form
                  const LoginForm(),

                  // Divider
                  FormDivider(dividerText: Texts.orSignInWith.capitalize!),
                  const SizedBox(height: Sizes.spaceBtwSections),

                  // Footer
                  const SocialButtons()
                ],
              ))),
    );
  }
}



