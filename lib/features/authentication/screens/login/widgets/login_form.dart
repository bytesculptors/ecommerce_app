import 'package:btl/utils/consts/sizes.dart';
import 'package:btl/utils/consts/text_strings.dart';
import 'package:flutter/material.dart';
import 'package:iconsax/iconsax.dart';

class LoginForm extends StatelessWidget {
  const LoginForm({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Form(
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: Sizes.spaceBetweenSections),
        child: Column(
          children: [
            TextFormField(
              decoration: const InputDecoration(
                prefixIcon: Icon(Iconsax.direct_right),
                labelText: Texts.email,
              ),
            ),
            const SizedBox(height: Sizes.spaceBetweenInputFields),
            TextFormField(
              decoration: const InputDecoration(
                  prefixIcon: Icon(Iconsax.password_check),
                  labelText: Texts.password,
                  suffixIcon: Icon(Iconsax.eye_slash)),
            ),
            const SizedBox(
                height: Sizes.spaceBetweenInputFields / 2),
    
            // forget password
            Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                TextButton(
                    onPressed: () {},
                    child: const Text(Texts.forgetPassword))
              ],
            ),
            const SizedBox(height: Sizes.spaceBetweenSections),
    
            // sign in button
            SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                    onPressed: () {},
                    child: const Text(Texts.signIn))),
            const SizedBox(height: Sizes.spaceBetweenItems),
    
            // create account button
            SizedBox(
                width: double.infinity,
                child: OutlinedButton(
                    onPressed: () {},
                    child: const Text(Texts.createAccount))),
          ],
        ),
      ));
  }
}

