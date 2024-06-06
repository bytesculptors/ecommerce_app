import 'package:btl/features/shop/models/store_model.dart';
import 'package:get/get.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class StoreRepository extends GetxController {
  static StoreRepository get instance => Get.find();

  /// Variables
  final _db = FirebaseFirestore.instance;

  /* ---------------------------- FUNCTIONS ---------------------------------*/

  /// Store new user order
  Future<String> openStore(StoreModel store, String userId) async {
    try {
      final newStore = await _db.collection('Stores').add(store.toJson());
      final storeId = {'isSelling': true, 'storeId': newStore.id};
      await _db.collection("Users").doc(userId).update(storeId);
      return newStore.id;
    } catch (e) {
      throw 'Something went wrong while saving Store Information. Try again later';
    }
  }
}
