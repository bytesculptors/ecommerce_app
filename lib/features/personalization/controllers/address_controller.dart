import 'package:btl/utils/constants/image_paths.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../common/widgets/texts/section_heading.dart';
import '../../../data/repositories/address/address_repository.dart';
import '../../../data/repositories/authentication/authentication_repository.dart';
import '../../../utils/constants/sizes.dart';
import '../../../utils/helpers/cloud_helper_functions.dart';
import '../../../utils/helpers/network_manager.dart';
import '../../../utils/popups/full_screen_loader.dart';
import '../../../utils/popups/loaders.dart';
import '../models/address_model.dart';
import '../screens/address/add_new_address.dart';
import '../screens/address/widgets/single_address_widget.dart';

class AddressController extends GetxController {
  static AddressController get instance => Get.find();

  final name = TextEditingController();
  final phoneNumber = TextEditingController();
  final detailedAddress = TextEditingController();
  String province = '';
  String provinceID = '';
  String district = '';
  String districtID = '';
  String commune = '';
  String communeID = '';
  GlobalKey<FormState> addressFormKey = GlobalKey<FormState>();

  RxBool refreshData = true.obs;
  final addressRepository = Get.put(AddressRepository());
  final Rx<AddressModel> selectedAddress = AddressModel.empty().obs;

  /// Fetch all user specific addresses
  Future<List<AddressModel>> allUserAddresses() async {
    try {
      final addresses = await addressRepository.fetchUserAddresses();
      selectedAddress.value = addresses.firstWhere(
          (element) => element.selectedAddress,
          orElse: () => AddressModel.empty());
      return addresses;
    } catch (e) {
      TLoaders.errorSnackBar(title: 'Address not found', message: e.toString());
      return [];
    }
  }

  Future selectAddress(AddressModel newSelectedAddress) async {
    try {
      // Clear the "selected" field
      if (selectedAddress.value.id.isNotEmpty) {
        await addressRepository.updateSelectedField(
            AuthenticationRepository.instance.getUserID,
            selectedAddress.value.id,
            false);
      }

      // Assign selected address
      newSelectedAddress.selectedAddress = true;
      selectedAddress.value = newSelectedAddress;

      // Set the "selected" field to true for the newly selected address
      await addressRepository.updateSelectedField(
          AuthenticationRepository.instance.getUserID,
          selectedAddress.value.id,
          true);
    } catch (e) {
      TLoaders.errorSnackBar(
          title: 'Error in Selection', message: e.toString());
    }
  }

  /// Add new Address
  addNewAddresses() async {
    try {
      // Start Loading
      TFullScreenLoader.openLoadingDialog(
          'Storing Address...', Images.docerAnimation);

      // Check Internet Connectivity
      final isConnected = await NetworkManager.instance.isConnected();
      if (!isConnected) {
        TFullScreenLoader.stopLoading();
        return;
      }

      // Form Validation
      if (!addressFormKey.currentState!.validate()) {
        TFullScreenLoader.stopLoading();
        return;
      }

      // Save Address Data
      final address = AddressModel(
        id: '',
        name: name.text.trim(),
        phoneNumber: phoneNumber.text.trim(),
        provinceID: provinceID.trim(),
        province: province.trim(),
        districtID: districtID.trim(),
        district: district.trim(),
        communeID: communeID.trim(),
        commune: commune.trim(),
        detailedAddress: detailedAddress.text.trim(),
        selectedAddress: true,
      );
      final id = await addressRepository.addAddress(
          address, AuthenticationRepository.instance.getUserID);

      // Update Selected Address status
      address.id = id;
      await selectAddress(address);

      // Remove Loader
      TFullScreenLoader.stopLoading();

      // Show Success Message
      TLoaders.successSnackBar(
          title: 'Congratulations',
          message: 'Your address has been saved successfully.');

      // Refresh Addresses Data
      refreshData.toggle();

      // Reset fields
      resetFormFields();

      // Redirect
      Navigator.of(Get.context!).pop();
    } catch (e) {
      // Remove Loader
      TFullScreenLoader.stopLoading();
      TLoaders.errorSnackBar(title: 'Address not found', message: e.toString());
    }
  }

  /// Show Addresses ModalBottomSheet at Checkout
  Future<dynamic> selectNewAddressPopup(BuildContext context) {
    return showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      builder: (_) => Container(
        padding: const EdgeInsets.all(Sizes.lg),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const TSectionHeading(title: 'Select Address'),
            Obx(
              () => FutureBuilder(
                key: Key(refreshData.value.toString()),
                future: allUserAddresses(),
                builder: (_, snapshot) {
                  /// Helper Function: Handle Loader, No Record, OR ERROR Message
                  final response = TCloudHelperFunctions.checkMultiRecordState(
                      snapshot: snapshot);
                  if (response != null) return response;

                  return Flexible(
                    child: ListView.builder(
                      shrinkWrap: true,
                      itemCount: snapshot.data!.length,
                      itemBuilder: (_, index) => TSingleAddress(
                        address: snapshot.data![index],
                        onTap: () async {
                          await selectAddress(snapshot.data![index]);
                          Get.back();
                        },
                      ),
                    ),
                  );
                },
              ),
            ),
            const SizedBox(height: Sizes.defaultSpace * 2),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                  onPressed: () => Get.to(() => AddNewAddressScreen()),
                  child: const Text('Add new address')),
            ),
          ],
        ),
      ),
    );
  }

  // Show confirm dialog before deleting address
  void showConfirmDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Confirm Delete'),
          content: const Text('Are you sure you want to delete this address?'),
          actions: <Widget>[
            TextButton(
              child: const Text('Cancel'),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
            TextButton(
              style: TextButton.styleFrom(foregroundColor: Colors.red),
              onPressed: () async {
                try {
                  Navigator.of(context).pop();
                  await addressRepository.deleteAddress(
                      AuthenticationRepository.instance.getUserID,
                      selectedAddress.value.id);
                  selectedAddress.value = AddressModel.empty();
                  refreshData.toggle();
                  // ignore: use_build_context_synchronously
                  TLoaders.successSnackBar(
                      title: 'Deleted',
                      message: 'Your address has been deleted successfully.');
                } catch (e) {
                  TLoaders.warningSnackBar(
                      title: 'Oh Snap!', message: e.toString());
                }
              },
              child: const Text('Delete'),
            ),
          ],
        );
      },
    );
  }

  /// Function to reset form fields
  void resetFormFields() {
    name.clear();
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
