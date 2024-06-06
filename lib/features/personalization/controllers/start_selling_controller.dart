import 'package:btl/data/repositories/store/store_repository.dart';
import 'package:btl/features/personalization/controllers/user_controller.dart';
import 'package:btl/features/personalization/screens/my_store/my_store.dart';
import 'package:btl/features/personalization/models/store_model.dart';
import 'package:btl/utils/constants/image_paths.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../data/repositories/authentication/authentication_repository.dart';
import '../../../utils/helpers/network_manager.dart';
import '../../../utils/popups/full_screen_loader.dart';
import '../../../utils/popups/loaders.dart';

class StartSellingController extends GetxController {
  static StartSellingController get instance => Get.find();

  final storeName = TextEditingController();
  final ownerName = TextEditingController();
  final ownerCitizenID = TextEditingController();
  final phoneNumber = TextEditingController();
  final detailedAddress = TextEditingController();
  String province = '';
  String provinceID = '';
  String district = '';
  String districtID = '';
  String commune = '';
  String communeID = '';
  GlobalKey<FormState> startSellingFormKey = GlobalKey<FormState>();

  RxBool refreshData = true.obs;
  final storeRepository = Get.put(StoreRepository());
  final userController = UserController.instance;


  /// Add new Address
  startSelling() async {
    try {
      // Start Loading
      TFullScreenLoader.openLoadingDialog(
          'Storing Information...', Images.docerAnimation);

      // Check Internet Connectivity
      final isConnected = await NetworkManager.instance.isConnected();
      if (!isConnected) {
        TFullScreenLoader.stopLoading();
        return;
      }

      // Form Validation
      if (!startSellingFormKey.currentState!.validate()) {
        TFullScreenLoader.stopLoading();
        return;
      }

      // Save Address Data
      final store = StoreModel(
        id: '',
        storeName: storeName.text.trim(),
        ownerName: ownerName.text.trim(),
        ownerCitizenID: ownerCitizenID.text.trim(),
        phoneNumber: phoneNumber.text.trim(),
        provinceID: provinceID.trim(),
        province: province.trim(),
        districtID: districtID.trim(),
        district: district.trim(),
        communeID: communeID.trim(),
        commune: commune.trim(),
        detailedAddress: detailedAddress.text.trim(),

      );
      final storeId = await storeRepository.openStore(
          store, AuthenticationRepository.instance.getUserID);

      // Update the Rx User value
      userController.user.value.isSelling = true;
      userController.user.value.storeId = storeId;


      // Remove Loader
      TFullScreenLoader.stopLoading();

      // Show Success Message
      TLoaders.successSnackBar(
          title: 'Congratulations',
          message: 'Your shop has been opened successfully. Upload products to sell now!');

      // Refresh Addresses Data
      refreshData.toggle();

      // Reset fields
      resetFormFields();

      // Redirect
      Navigator.of(Get.context!).pop();
      Get.to(() => const MyStoreScreen());
    } catch (e) {
      // Remove Loader
      TFullScreenLoader.stopLoading();
      TLoaders.errorSnackBar(title: 'Somthing went wrong!', message: e.toString());
    }
  }

  /// Function to reset form fields
  void resetFormFields() {
    storeName.clear();
    phoneNumber.clear();
    provinceID = '';
    province = '';
    districtID = '';
    district = '';
    communeID = '';
    commune = '';
    detailedAddress.clear();
    // addressFormKey.currentState?.reset();
  }
}
