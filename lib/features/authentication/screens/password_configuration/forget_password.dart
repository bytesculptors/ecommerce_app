import 'package:btl/common/widgets/appbar/appbar.dart';
import 'package:btl/features/authentication/controllers/forget_password_controller.dart';
import 'package:btl/utils/constants/sizes.dart';
import 'package:btl/utils/constants/text_strings.dart';
import 'package:btl/validators/validation.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:iconsax/iconsax.dart';


class ForgetPasswordScreen extends StatelessWidget {
  const ForgetPasswordScreen({super.key});

  @override
  Widget build(BuildContext context) {

    final controller = Get.put(ForgetPasswordController());
    return Scaffold(
      /// Custom Appbar
      appBar: MyAppBar(actions: [IconButton(onPressed: () => Get.back(), icon: const Icon(CupertinoIcons.clear))]),
      body: Padding(
        padding: const EdgeInsets.all(Sizes.defaultSpace),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            /// Headings
            Text(Texts.forgetPasswordTitle, style: Theme.of(context).textTheme.headlineMedium),
            const SizedBox(height: Sizes.spaceBtwItems),
            Text(Texts.forgetPasswordSubTitle, style: Theme.of(context).textTheme.labelMedium),
            const SizedBox(height: Sizes.spaceBtwSections * 2),

            /// Text field
            Form(
              key: controller.forgetPasswordFormKey,
              child: TextFormField(
                controller: controller.email,
                validator: Validator.validateEmail,
                decoration: const InputDecoration(labelText: Texts.email, prefixIcon: Icon(Iconsax.direct_right)),
              ),
            ),
            const SizedBox(height: Sizes.spaceBtwSections),

            /// Submit Button
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(onPressed: () => controller.sendPasswordResetEmail(), child: const Text(Texts.submit)),
            ),
          ],
        ),
      ),
    );
  }
}
