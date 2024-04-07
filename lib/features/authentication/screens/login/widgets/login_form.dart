import 'package:btl/features/authentication/screens/password_configuration/forget_password.dart';
import 'package:btl/features/authentication/screens/signup/signup_screen.dart';
import 'package:btl/utils/consts/colors.dart';
import 'package:btl/utils/consts/sizes.dart';
import 'package:btl/utils/consts/text_strings.dart';
import 'package:btl/validators/validation.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:iconsax/iconsax.dart';

class LoginForm extends StatelessWidget {
  const LoginForm({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Form(
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: Sizes.spaceBtwSections),
        child: Column(
          children: [
            TextFormField(
              validator: Validator.validateEmail,
              decoration: const InputDecoration(
                prefixIcon: Icon(Iconsax.direct_right),
                labelText: Texts.email,
              ),
            ),
            const SizedBox(height: Sizes.spaceBtwInputFields),
            TextFormField(
              validator: (value) => Validator.validateEmptyText('Password', value),
              decoration: const InputDecoration(
                  prefixIcon: Icon(Iconsax.password_check),
                  labelText: Texts.password,
                  suffixIcon: Icon(Iconsax.eye_slash)),
            ),
            const SizedBox(
                height: Sizes.spaceBtwInputFields / 2),
    
            // forget password
            Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                TextButton(
                    onPressed: () => Get.to(() => const ForgetPasswordScreen()),
                    child: const Text(Texts.forgetPassword, style: TextStyle(color: MyColors.darkerGrey),))
              ],
            ),
            const SizedBox(height: Sizes.spaceBtwSections),
    
            // sign in button
            SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                    onPressed: () {},
                    child: const Text(Texts.signIn))),
            const SizedBox(height: Sizes.spaceBtwItems),
    
            // create account button
            SizedBox(
                width: double.infinity,
                child: OutlinedButton(
                    onPressed: () => Get.to(() => const SignupScreen()),
                    child: const Text(Texts.createAccount))),
          ],
        ),
      ));
  }
}

