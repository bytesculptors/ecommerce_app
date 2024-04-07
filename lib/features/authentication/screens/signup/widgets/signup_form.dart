import 'package:btl/utils/consts/sizes.dart';
import 'package:btl/utils/consts/text_strings.dart';
import 'package:btl/validators/validation.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:iconsax/iconsax.dart';


class SignupForm extends StatelessWidget {
  const SignupForm({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Form(
      child: Column(
        children: [
          const SizedBox(height: Sizes.spaceBtwSections),
          /// First & Last Name
          Row(
            children: [
              Expanded(
                child: TextFormField(
                  validator: (value) => Validator.validateEmptyText('First name', value),
                  expands: false,
                  decoration: const InputDecoration(labelText: Texts.firstName, prefixIcon: Icon(Iconsax.user)),
                ),
              ),
              const SizedBox(width: Sizes.spaceBtwInputFields),
              Expanded(
                child: TextFormField(
                  validator: (value) => Validator.validateEmptyText('Last name', value),
                  expands: false,
                  decoration: const InputDecoration(labelText: Texts.lastName, prefixIcon: Icon(Iconsax.user)),
                ),
              ),
            ],
          ),
          const SizedBox(height: Sizes.spaceBtwInputFields),

          /// Username
          TextFormField(
            validator: Validator.validateUsername,
            expands: false,
            decoration: const InputDecoration(labelText: Texts.username, prefixIcon: Icon(Iconsax.user_edit)),
          ),
          const SizedBox(height: Sizes.spaceBtwInputFields),

          /// Email
          TextFormField(
            validator: Validator.validateEmail,
            decoration: const InputDecoration(labelText: Texts.email, prefixIcon: Icon(Iconsax.direct)),
          ),
          const SizedBox(height: Sizes.spaceBtwInputFields),

          /// Phone Number
          TextFormField(
            validator: Validator.validatePhoneNumber,
            decoration: const InputDecoration(labelText: Texts.phoneNo, prefixIcon: Icon(Iconsax.call)),
          ),
          const SizedBox(height: Sizes.spaceBtwInputFields),

          /// Password
          TextFormField(
            validator: Validator.validatePassword,
            decoration: InputDecoration(
              labelText: Texts.password,
              prefixIcon: const Icon(Iconsax.password_check),
              suffixIcon: IconButton(
                onPressed: () {},
                icon: const Icon(Iconsax.eye_slash),
              ),
            ),
          ),
          const SizedBox(height: Sizes.spaceBtwSections),

          /// Sign Up Button
          SizedBox(
            width: double.infinity,
            child: ElevatedButton(onPressed: () {}, child: const Text(Texts.createAccount)),
          ),
        ],
      ),
    );
  }
}
