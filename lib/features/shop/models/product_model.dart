import 'package:btl/features/personalization/models/store_model.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

import 'brand_model.dart';
import 'product_attribute_model.dart';
import 'product_variation_model.dart';

class ProductModel {
  String id;
  int stock;
  String? sku;
  double price;
  String title;
  DateTime? date;
  double salePrice;
  String thumbnail;
  bool? isFeatured;
  BrandModel? brand;
  String? categoryId;
  String productType;
  String? description;
  List<String>? images;
  List<ProductAttributeModel>? productAttributes;
  List<ProductVariationModel>? productVariations;
  String storeId;
  StoreModel? store;
  int weight;
  int? height;
  int? length;
  int? width;

  ProductModel({
    required this.id,
    required this.title,
    required this.stock,
    required this.price,
    required this.thumbnail,
    required this.productType,
    required this.storeId,
    required this.weight,
    this.width,
    this.length,
    this.height,
    this.sku,
    this.brand,
    this.date,
    this.images,
    this.salePrice = 0.0,
    this.isFeatured,
    this.categoryId,
    this.description,
    this.productAttributes,
    this.productVariations,
    this.store
  });

  /// Create Empty func for clean code
  static ProductModel empty() => ProductModel(id: '', title: '', stock: 0, price: 0, thumbnail: '', productType: '', storeId: '', weight: 0);

  /// Json Format
  toJson() {
    return {
      'SKU': sku,
      'Title': title,
      'Stock': stock,
      'Price': price,
      'Images': images ?? [],
      'Thumbnail': thumbnail,
      'SalePrice': salePrice,
      'IsFeatured': isFeatured,
      'CategoryId': categoryId,
      'Brand': brand!.toJson(),
      'Description': description,
      'ProductType': productType,
      'ProductAttributes': productAttributes != null ? productAttributes!.map((e) => e.toJson()).toList() : [],
      'ProductVariations': productVariations != null ? productVariations!.map((e) => e.toJson()).toList() : [],
      'StoreId': storeId,
      'Weight': weight,
      'Height': height,
      'Width': width,
      "Length": length,
      "Store": store!.toJson()
    };
  }

  /// Map Json oriented document snapshot from Firebase to Model
  factory ProductModel.fromSnapshot(DocumentSnapshot<Map<String, dynamic>> document) {
    final data = document.data()!;
    return ProductModel(
      id: document.id,
      title: data['Title'],
      price: double.parse((data['Price'] ?? 0.0).toString()),
      sku: data['SKU'],
      stock: data['Stock'] ?? 0,
      isFeatured: data['IsFeatured'] ?? false,
      salePrice: double.parse((data['SalePrice'] ?? 0.0).toString()),
      thumbnail: data['Thumbnail'] ?? '',
      categoryId: data['CategoryId'] ?? '',
      description: data['Description'] ?? '',
      productType: data['ProductType'] ?? '',
      brand: BrandModel.fromJson(data['Brand']),
      images: data['Images'] != null ? List<String>.from(data['Images']) : [],
      productAttributes: (data['ProductAttributes'] as List<dynamic>).map((e) => ProductAttributeModel.fromJson(e)).toList(),
      productVariations: (data['ProductVariations'] as List<dynamic>).map((e) => ProductVariationModel.fromJson(e)).toList(),
      storeId: data['StoreId'] ?? '',
      weight: data['Weight'] ?? 0,
      height: data['Height'] ?? 0,
      length: data['Length'] ?? 0,
      width: data['Width'] ?? 0,
      store: data['Store'] != null ? StoreModel.fromJson(data['Store']) : null
    );
  }

  // Map Json-oriented document snapshot from Firebase to Model
  factory ProductModel.fromQuerySnapshot(QueryDocumentSnapshot<Object?> document) {
    final data = document.data() as Map<String, dynamic>;
    return ProductModel(
      id: document.id,
      title: data['Title'] ?? '',
      price: double.parse((data['Price'] ?? 0.0).toString()),
      sku: data['SKU'] ?? '',
      stock: data['Stock'] ?? 0,
      isFeatured: data['IsFeatured'] ?? false,
      salePrice: double.parse((data['SalePrice'] ?? 0.0).toString()),
      thumbnail: data['Thumbnail'] ?? '',
      categoryId: data['CategoryId'] ?? '',
      description: data['Description'] ?? '',
      productType: data['ProductType'] ?? '',
      brand: BrandModel.fromJson(data['Brand']),
      images: data['Images'] != null ? List<String>.from(data['Images']) : [],
      productAttributes: (data['ProductAttributes'] as List<dynamic>).map((e) => ProductAttributeModel.fromJson(e)).toList(),
      productVariations: (data['ProductVariations'] as List<dynamic>).map((e) => ProductVariationModel.fromJson(e)).toList(),
      storeId: data['StoreId'] ?? '',
      weight: data['Weight'] ?? 0,
      height: data['Height'] ?? 0,
      length: data['Length'] ?? 0,
      width: data['Width'] ?? 0,
      store: data['Store'] != null ? StoreModel.fromJson(data['Store']) : null
    );
  }
}
