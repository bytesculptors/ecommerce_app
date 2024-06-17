import 'package:btl/features/personalization/models/store_model.dart';

class CartItemModel {
  String productId;
  String title;
  double price;
  String? image;
  int quantity;
  String variationId;
  String? brandName;
  Map<String, String>? selectedVariation;
  bool isSelected;
  String storeId; 
  StoreModel? store; 

  /// Constructor
  CartItemModel({
    required this.productId,
    required this.quantity,
    this.variationId = '',
    this.image,
    this.price = 0.0,
    this.title = '',
    this.brandName,
    this.selectedVariation,
    this.isSelected = false,
    required this.storeId,
    this.store,
  });

  /// Empty Cart
  static CartItemModel empty() => CartItemModel(productId: '', quantity: 0, storeId: '');

  /// Convert a CartItem to a JSON Map
  Map<String, dynamic> toJson() {
    return {
      'productId': productId,
      'title': title,
      'price': price,
      'image': image,
      'quantity': quantity,
      'variationId': variationId,
      'brandName': brandName,
      'selectedVariation': selectedVariation,
      'isSelected': isSelected,
      'storeId': storeId,
      'store': store?.toJson(),
    };
  }

  /// Create a CartItem from a JSON Map
  factory CartItemModel.fromJson(Map<String, dynamic> json) {
    return CartItemModel(
      productId: json['productId'],
      title: json['title'],
      price: json['price']?.toDouble(),
      image: json['image'],
      quantity: json['quantity'],
      variationId: json['variationId'],
      brandName: json['brandName'],
      selectedVariation: json['selectedVariation'] != null ? Map<String, String>.from(json['selectedVariation']) : null,
      isSelected: json['isSelected'] ?? false,
      storeId: json['storeId'],
      store: StoreModel.fromJson(json['store']),
    );
  }
}
