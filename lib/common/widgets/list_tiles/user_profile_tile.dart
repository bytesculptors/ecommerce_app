import 'package:btl/utils/constants/image_paths.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:iconsax/iconsax.dart';

import '../../../../utils/constants/colors.dart';
import '../../../features/personalization/controllers/user_controller.dart';
import '../images/t_circular_image.dart';

class TUserProfileTile extends StatelessWidget {
  TUserProfileTile({
    super.key,
    required this.onPressed,
  });

  final VoidCallback onPressed;
  final controller = UserController.instance;

  @override
  Widget build(BuildContext context) {
    return Obx(() {
      final isNetworkImage = controller.user.value.profilePicture.isNotEmpty;
      final image = isNetworkImage ? controller.user.value.profilePicture : Images.user;
      return ListTile(
        leading: TCircularImage(padding: 0, image: image, width: 50, height: 50, isNetworkImage: isNetworkImage),
        title: Text(controller.user.value.fullName, style: Theme.of(context).textTheme.headlineSmall!.apply(color: MyColors.white)),
        subtitle: Text(controller.user.value.email, style: Theme.of(context).textTheme.bodyMedium!.apply(color: MyColors.white)),
        trailing: IconButton(onPressed: onPressed, icon: const Icon(Iconsax.edit, color: MyColors.white)),
      );
    });
  }
}
