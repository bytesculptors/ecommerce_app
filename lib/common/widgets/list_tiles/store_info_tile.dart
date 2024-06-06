import 'package:btl/features/personalization/controllers/store_controller.dart';
import 'package:btl/utils/constants/image_paths.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:iconsax/iconsax.dart';

import '../../../../utils/constants/colors.dart';
import '../../../features/personalization/controllers/user_controller.dart';
import '../images/t_circular_image.dart';

class StoreInfoTile extends StatelessWidget {
  StoreInfoTile({
    super.key,
    required this.onPressed,
  });

  final VoidCallback onPressed;
  final userController = UserController.instance;
  final storeController = StoreController.instance;

  @override
  Widget build(BuildContext context) {
    storeController.fetchStoreRecord(userController.user.value.storeId);
    return Obx(() {
      final isNetworkImage = storeController.userStore.value.image != null && storeController.userStore.value.image != '';
      final image = isNetworkImage ? storeController.userStore.value.image : Images.user;
          return ListTile(
        leading: TCircularImage(padding: 0, image: Images.user, width: 50, height: 50, isNetworkImage: isNetworkImage),
        title: Text(storeController.userStore.value.storeName, style: Theme.of(context).textTheme.headlineSmall!.apply(color: MyColors.white)),
        subtitle: Text(storeController.userStore.toString(), style: Theme.of(context).textTheme.bodyMedium!.apply(color: MyColors.white)),
        trailing: IconButton(onPressed: onPressed, icon: const Icon(Iconsax.edit, color: MyColors.white)),
      );
    });
  }
}
