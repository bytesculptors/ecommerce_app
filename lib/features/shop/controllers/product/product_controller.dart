import 'dart:io';

import 'package:btl/features/shop/models/brand_model.dart';
import 'package:btl/utils/constants/enums.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import '../../../../data/repositories/product/product_repository.dart';
import '../../../../utils/popups/loaders.dart';
import '../../models/product_model.dart';

class ProductController extends GetxController {
  static ProductController get instance => Get.find();

  final isLoading = false.obs;
  final productRepository = Get.put(ProductRepository());
  RxList<ProductModel> featuredProducts = <ProductModel>[].obs;
  RxList<ProductModel> storeProducts = <ProductModel>[].obs;

  final title = TextEditingController();
  String? categoryId;
  BrandModel? brand;
  final description = TextEditingController();
  final stock = TextEditingController();
  final price = TextEditingController();
  final salePrice = TextEditingController();
  final weight = TextEditingController();
  final width = TextEditingController();
  final length = TextEditingController();
  final height = TextEditingController();
  final sku = TextEditingController();
  String thumbnail = '';
  List<String>? images;

  /// -- Initialize Products from your backend
  @override
  void onInit() {
    fetchFeaturedProducts();
    super.onInit();
  }

  /// Fetch Products using Stream so, any change can immediately take effect.
  void fetchFeaturedProducts() async {
    try {
      // Show loader while loading Products
      isLoading.value = true;

      // Fetch Products
      final products = await productRepository.getFeaturedProducts();

      // Assign Products
      featuredProducts.assignAll(products);
    } catch (e) {
      TLoaders.errorSnackBar(title: 'Oh Snap!', message: e.toString());
    } finally {
      isLoading.value = false;
    }
  }

  void fetchStoreProducts(String storeId) async {
    try {
      // Show loader while loading Products
      isLoading.value = true;

      // Fetch Products
      final products = await productRepository.getAllStoreProducts(storeId);

      // Assign Products
      storeProducts.assignAll(products);
    } catch (e) {
      TLoaders.errorSnackBar(title: 'Oh Snap!', message: e.toString());
    } finally {
      isLoading.value = false;
    }
  }

  /// Get the product price or price range for variations.
  String getProductPrice(ProductModel product) {
    double smallestPrice = double.infinity;
    double largestPrice = 0.0;

    // If no variations exist, return the simple price or sale price
    if (product.productType == ProductType.single.toString() ||
        product.productVariations!.isEmpty) {
      return (product.salePrice > 0.0 ? product.salePrice : product.price)
          .toString();
    } else {
      // Calculate the smallest and largest prices among variations
      for (var variation in product.productVariations!) {
        // Determine the price to consider (sale price if available, otherwise regular price)
        double priceToConsider =
            variation.salePrice > 0.0 ? variation.salePrice : variation.price;

        // Update smallest and largest prices
        if (priceToConsider < smallestPrice) {
          smallestPrice = priceToConsider;
        }

        if (priceToConsider > largestPrice) {
          largestPrice = priceToConsider;
        }
      }

      // If smallest and largest prices are the same, return a single price
      if (smallestPrice.isEqual(largestPrice)) {
        return largestPrice.toString();
      } else {
        // Otherwise, return a price range
        return '$smallestPrice - \$$largestPrice';
      }
    }
  }

  /// -- Calculate Discount Percentage
  String? calculateSalePercentage(double originalPrice, double? salePrice) {
    if (salePrice == null || salePrice <= 0.0) return null;
    if (originalPrice <= 0) return null;

    double percentage = ((originalPrice - salePrice) / originalPrice) * 100;
    return percentage.toStringAsFixed(0);
  }

  /// -- Check Product Stock Status
  String getProductStockStatus(ProductModel product) {
    if (product.productType == ProductType.single.toString()) {
      return product.stock > 0 ? 'In Stock' : 'Out of Stock';
    } else {
      final stock = product.productVariations
          ?.fold(0, (previousValue, element) => previousValue + element.stock);
      return stock != null && stock > 0 ? 'In Stock' : 'Out of Stock';
    }
  }

  Future<String> uploadImage(XFile image) async {
    try {
      String uniqueFileName =
          '${image.name}_${DateTime.now().millisecondsSinceEpoch}.jpg';

      Reference ref =
          FirebaseStorage.instance.ref('images/').child(uniqueFileName);

      await ref.putFile(File(image.path));
      final imageUrl = await ref.getDownloadURL();
      return imageUrl;
    } catch (error) {
      throw 'Something went wrong. Please try again';
    }
  }


  Future<void> deleteImage(String imageUrl) async {
    try {
      Reference storageReference =
          FirebaseStorage.instance.refFromURL(imageUrl);

      await storageReference.delete();

      print('Image deleted successfully');
    } catch (error) {
      print('Error occurred while deleting image: $error');
    }
  }
}
