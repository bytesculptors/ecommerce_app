import 'package:btl/data/repositories/store/store_repository.dart';
import 'package:btl/features/personalization/models/store_model.dart';
import 'package:btl/utils/popups/loaders.dart';
import 'package:get/get.dart';

class StoreController extends GetxController {
  static StoreController get instance => Get.find();
  Rx<StoreModel> userStore = StoreModel.empty().obs;
  final storeRepository = Get.put(StoreRepository());

  /// Fetch store record
  Future<StoreModel?> fetchStoreRecord(String? storeId) async {
    try {
      final store = await storeRepository.fetchStoreRecord(storeId);
      userStore(store);
      return store;
    } catch (e) {
      TLoaders.errorSnackBar(title: 'Fetch store failed!', message: e.toString());
      return null;
    } 
  }
}