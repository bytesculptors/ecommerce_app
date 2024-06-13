import 'dart:io';

import 'package:btl/features/personalization/screens/my_store/my_store.dart';
import 'package:btl/features/personalization/screens/my_store/tabs/product_tab.dart';
import 'package:btl/features/shop/models/brand_model.dart';
import 'package:btl/features/shop/models/product_attribute_model.dart';
import 'package:btl/features/shop/models/product_variation_model.dart';
import 'package:btl/utils/constants/enums.dart';
import 'package:btl/utils/constants/image_paths.dart';
import 'package:btl/utils/helpers/network_manager.dart';
import 'package:btl/utils/popups/full_screen_loader.dart';
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
  List<ProductVariationModel>? productVariations;
  String storeId = '';
  List<ProductAttributeModel>? productAttributes;
  String productType = 'single';
  GlobalKey<FormState> addProductFormKey = GlobalKey<FormState>();

  RxBool refreshData = true.obs;

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
          '${image.name}_${DateTime.now().millisecondsSinceEpoch}';

      Reference ref =
          FirebaseStorage.instance.ref('Products/').child(uniqueFileName);

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

  /// Add new Product
  Future<void> addNewProduct() async {
    try {
      // Start Loading
      TFullScreenLoader.openLoadingDialog(
          'Storing Product...', Images.docerAnimation);

      // Check Internet Connectivity
      final isConnected = await NetworkManager.instance.isConnected();
      if (!isConnected) {
        TFullScreenLoader.stopLoading();
        return;
      }

      // Form Validation
      if (!addProductFormKey.currentState!.validate()) {
        TFullScreenLoader.stopLoading();
        return;
      }

      if (productVariations != null) {
        if (productVariations!.isNotEmpty) {
          productAttributes = [];
          productType = 'variable';

          Set<String> colors = {};
          for (final variation in productVariations!) {
            if (variation.attributeValues['Color'] != '') {
              colors.add(variation.attributeValues['Color']!);
            }
          }
          if (colors.isNotEmpty) {
            productAttributes!.add(
                ProductAttributeModel(name: 'Color', values: colors.toList()));
          }

          Set<String> sizes = {};
          for (final variation in productVariations!) {
            if (variation.attributeValues['Size'] != '') {
              colors.add(variation.attributeValues['Size']!);
            }
          }

          if (sizes.isNotEmpty) {
            productAttributes!.add(
                ProductAttributeModel(name: 'Size', values: sizes.toList()));
          }

          Set<String> otherAttributes = {};
          for (final variation in productVariations!) {
            if (variation.attributeValues['Other Attribute'] != '') {
              colors.add(variation.attributeValues['Other Attribute']!);
            }
          }

          if (otherAttributes.isNotEmpty) {
            productAttributes!.add(ProductAttributeModel(
                name: 'Other Attribute', values: otherAttributes.toList()));
          }
          print('Has variants');
        }
      }

      // Save Product Data
      final product = ProductModel(
        id: '',
        title: title.text.trim(),
        stock: int.parse(stock.text),
        price: double.parse(price.text),
        thumbnail: thumbnail,
        productType: productType,
        storeId: storeId,
        weight: int.parse(weight.text),
        width: width.text != '' ? int.parse(width.text) : null,
        length: length.text != '' ? int.parse(length.text) : null,
        height: height.text != '' ? int.parse(height.text) : null,
        sku: sku.text.trim(),
        brand: brand,
        images: images,
        salePrice: salePrice.text != '' ? double.parse(salePrice.text) : 0.0,
        isFeatured: false,
        categoryId: categoryId,
        description: description.text.trim(),
        productAttributes: productAttributes,
        productVariations: productVariations,
      );
      print('still ok');
      await productRepository.addNewProduct(product);

      // Remove Loader
      TFullScreenLoader.stopLoading();

      // Show Success Message
      TLoaders.successSnackBar(
          title: 'Congratulations',
          message: 'Your product has been added successfully.');

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
      TLoaders.errorSnackBar(
          title: 'Something went wrong when uploading product!',
          message: e.toString());
    }
  }

  // Show confirm dialog before deleting product
  void showConfirmDialog(BuildContext context, ProductModel product) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Confirm Delete'),
          content: const Text('Are you sure you want to delete this product?'),
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
                  
                  if (product.thumbnail != '') {
                    await deleteImage(product.thumbnail);
                  }

                  if (product.images != null) {
                    if (product.images!.isNotEmpty) {
                      for (String image in product.images!) {
                        await deleteImage(image);
                      }
                    }
                  }

                  if (product.productVariations != null) {
                    if (product.productVariations!.isNotEmpty) {
                      for (ProductVariationModel variant in product.productVariations!) {
                        if (variant.image != '') {
                          await deleteImage(variant.image);
                        }
                      }
                    }
                  }

                  await productRepository.deleteProduct(product.id);
                  refreshData.toggle();
                  
                  // ignore: use_build_context_synchronously
                  TLoaders.successSnackBar(
                      title: 'Deleted',
                      message: 'Your product has been deleted successfully.');
                  Get.to(() => const MyStoreScreen());
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


  void resetFormFields() {
    title.clear();
    categoryId = null;
    brand = null;
    description.clear();
    stock.clear();
    price.clear();
    salePrice.clear();
    weight.clear();
    width.clear();
    length.clear();
    height.clear();
    sku.clear();
    thumbnail = '';
    images = null;
    productVariations = null;
  }
}
