import 'package:btl/features/authentication/controllers/login_in_controller.dart';
import 'package:btl/features/authentication/screens/password_configuration/forget_password.dart';
import 'package:btl/features/authentication/screens/signup/signup_screen.dart';
import 'package:btl/utils/constants/colors.dart';
import 'package:btl/utils/constants/sizes.dart';
import 'package:btl/utils/constants/text_strings.dart';
import 'package:btl/utils/validators/validation.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:iconsax/iconsax.dart';

class LoginForm extends StatelessWidget {
  const LoginForm({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    final controller = Get.put(LoginController());
    return Form(
      key: controller.loginFormKey,
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: Sizes.spaceBtwSections),
        child: Column(
          children: [
            /// Email
            TextFormField(
              controller: controller.email,
              validator: Validator.validateEmail,
              decoration: const InputDecoration(prefixIcon: Icon(Iconsax.direct_right), labelText: Texts.email),
            ),
            const SizedBox(height: Sizes.spaceBtwInputFields),

            /// Password
            Obx(
              () => TextFormField(
                obscureText: controller.hidePassword.value,
                controller: controller.password,
                validator: (value) => Validator.validateEmptyText('Password', value),
                decoration: InputDecoration(
                  labelText: Texts.password,
                  prefixIcon: const Icon(Iconsax.password_check),
                  suffixIcon: IconButton(
                    onPressed: () => controller.hidePassword.value = !controller.hidePassword.value,
                    icon: const Icon(Iconsax.eye_slash),
                  ),
                ),
              ),
            ),
            const SizedBox(height: Sizes.spaceBtwInputFields / 2),

            /// Remember Me & Forget Password
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                /// Remember Me
                Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Obx(() => Checkbox(value: controller.rememberMe.value, onChanged: (value) => controller.rememberMe.value = value!)),
                    const Text(Texts.rememberMe),
                  ],
                ),

                /// Forget Password
                TextButton(onPressed: () => Get.to(() => const ForgetPasswordScreen()), child: const Text(Texts.forgetPassword, style: TextStyle(color: MyColors.darkerGrey))),
              ],
            ),
            const SizedBox(height: Sizes.spaceBtwSections),

            /// Sign In Button
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(onPressed: () => controller.emailAndPasswordSignIn(), child: const Text(Texts.signIn)),
            ),
            const SizedBox(height: Sizes.spaceBtwItems),

            /// Create Account Button
            SizedBox(
              width: double.infinity,
              child: OutlinedButton(onPressed: () => Get.to(() => const SignupScreen()), child: const Text(Texts.createAccount)),
            ),
          ],
        ),
      ),
    );
  }
}

