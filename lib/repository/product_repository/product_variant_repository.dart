import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:ecommerce_app_mobile/features/shop/models/product_model/product_variant_model.dart';
import 'package:flutter/material.dart';
import 'package:flutter_smart_dialog/flutter_smart_dialog.dart';
import 'package:get/get.dart';

class ProductVariantRepository extends GetxController {
  static ProductVariantRepository get instance => Get.find();

  final _db = FirebaseFirestore.instance;

  Future<String?> getVariantId(ProductVariantModel productVariantModel) async {
    try {
      final querySnapshot = await _db
          .collection("ProductVariant")
          .where('color', isEqualTo: productVariantModel.color)
          .where('size', isEqualTo: productVariantModel.size)
          .get();
      // Kiểm tra xem có document nào khớp hay không
      if (querySnapshot.docs.isNotEmpty) {
        // Lấy documentId của document đầu tiên (nếu có nhiều document khớp)
        final documentId = querySnapshot.docs.first.id;
        return documentId;
      } else {
        return null;
      }
    } catch (error) {
      print('Lỗi khi lấy documentId cho ProductModel: $error');
      return null;
    }
  }

  Future<String> createProductVariant(
      ProductVariantModel productVariantModel) async {
    var id = await _db
        .collection('ProductVariant')
        .add(productVariantModel.toJson())
        .catchError((error, stacktrace) {
      SmartDialog.showNotify(
        msg: 'Something went wrong, try again?',
        notifyType: NotifyType.failure,
        displayTime: const Duration(seconds: 1),
      );
      print(error.toString());
    });
    return id.id;
  }

  Future<List<ProductVariantModel>> queryAllProductVariants(
      String productId) async {
    final snapshot = await _db
        .collection('ProductVariant')
        .where('product_id', isEqualTo: productId)
        .get();
    final productData =
        snapshot.docs.map((e) => ProductVariantModel.fromSnapShot(e)).toList();
    return productData;
  }

  // Future<ProductVariantModel> queryVariantByID(String variantsID) async {
  //   final snapshot = await _db
  //       .collection('ProductVariant')
  //       .where(document.getElementById(fK3ddutEpD2qQqRMXNW5)

  //       .get();
  //   final productData = ProductVariantModel.fromSnapShot(snapshot);
  //   return productData;
  // }

  Future<ProductVariantModel> getVariantById(String variantId) async {
    final snapshot =
        await _db.collection('ProductVariant').doc(variantId).get();
    if (snapshot.exists) {
      // Nếu document tồn tại, lấy dữ liệu từ snapshot và trả về đối tượng ProductVariantModel
      return ProductVariantModel.fromSnapShot(snapshot);
    } else {
      // Nếu document không tồn tại, có thể xử lý theo ý bạn, ví dụ, ném một ngoại lệ
      throw Exception('Product variant with id $variantId not found');
    }
  }

  Future<List<ProductVariantModel>> queryVariants(
      List<dynamic> variantsIDs) async {
    final query = _db
        .collection('ProductVariant')
        .where(FieldPath.documentId, whereIn: variantsIDs);
    final snapshot = await query.get();
    return snapshot.docs
        .map((e) => ProductVariantModel.fromSnapShot(e))
        .toList();
  }

  // Future<void> addAllData () async {
  //   const newData = {
  //     'height': 20,
  //     'weight': 750,
  //     'length': 20,
  //     'width': 20,
  //   };
  //   await _db.collection('ProductVariant').get().then((value) => value.docs.forEach((element) {
  //     var docRef = _db.collection('ProductVariant').doc(element.id);
  //     docRef.update(newData);
  //   }));
  // }
}
