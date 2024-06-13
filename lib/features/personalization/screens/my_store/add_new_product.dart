import 'dart:io';

import 'package:btl/features/personalization/controllers/user_controller.dart';
import 'package:btl/features/shop/controllers/brand_controller.dart';
import 'package:btl/features/shop/controllers/categories_controller.dart';
import 'package:btl/features/shop/controllers/product/product_controller.dart';
import 'package:btl/features/shop/models/brand_model.dart';
import 'package:btl/features/shop/models/category_model.dart';
import 'package:btl/features/shop/models/product_variation_model.dart';
import 'package:btl/utils/constants/colors.dart';
import 'package:get/get.dart';
import 'package:flutter/material.dart';
import 'package:iconsax/iconsax.dart';
import 'package:image_picker/image_picker.dart';
import '../../../../../utils/constants/sizes.dart';
import '../../../../common/widgets/appbar/appbar.dart';
import '../../../../utils/validators/validation.dart';
import 'package:flutter_colorpicker/flutter_colorpicker.dart';

class AddNewProductScreen extends StatefulWidget {
  AddNewProductScreen({Key? key}) : super(key: key);

  @override
  _AddNewProductScreenState createState() => _AddNewProductScreenState();
}

class _AddNewProductScreenState extends State<AddNewProductScreen> {
  @override
  void initState() {
    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
  }

  String? selectedCategory;
  BrandModel? selectedBrand;
  Color selectedColor = const Color.fromARGB(255, 234, 183, 183);
  List<ProductVariationModel> listProductVariations = [];
  String thumbnailUrl = '';
  XFile? thumbnail;
  final List<XFile?> imageList = [];
  List<String> imageUrlList = [];
  final List<XFile?> variantImageList = [];

  void openColorPicker(BuildContext context, int variantIndex) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Pick product\'s color'),
          content: SingleChildScrollView(
            child: ColorPicker(
              pickerColor: selectedColor,
              onColorChanged: (Color color) {
                setState(() {
                  selectedColor = color;
                });
              },
              pickerAreaHeightPercent: 0.8,
            ),
          ),
          actions: <Widget>[
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: const Text('Cancel'),
            ),
            TextButton(
              onPressed: () {
                setState(() {
                  String colorString = selectedColor.value
                      .toRadixString(16)
                      .substring(2)
                      .toUpperCase();
                  listProductVariations[variantIndex]
                      .attributeValues['Color'] = colorString;
                });
                Navigator.of(context).pop();
              },
              child: const Text('Confirm'),
            ),
          ],
        );
      },
    );
  }

  bool isValidHexColor(String hexColor) {
    final hexRegex = RegExp(r'^#?([0-9a-fA-F]{6}|[0-9a-fA-F]{3})$');
    return hexRegex.hasMatch(hexColor);
  }

  Future<void> pickThumbnail() async {
    final pickedFile =
        await ImagePicker().pickImage(source: ImageSource.gallery);

    if (pickedFile != null) {
      setState(() {
        thumbnail = pickedFile;
      });

      thumbnailUrl = await ProductController.instance.uploadImage(pickedFile);
    }
  }

  Future<void> pickMultiImages() async {
    final pickedFiles = await ImagePicker().pickMultiImage();

    setState(() {
      imageList.addAll(pickedFiles);
    });

    for (final pickedFile in pickedFiles) {
      final url = await ProductController.instance.uploadImage(pickedFile);
      setState(() {
        imageUrlList.add(url);
      });
    }
  }

  Future<void> pickVariantImage(int variantIndex) async {
    final pickedFile =
        await ImagePicker().pickImage(source: ImageSource.gallery);

    if (pickedFile != null) {
      setState(() {
        variantImageList[variantIndex] = pickedFile;
      });
      final imageUrl = await ProductController.instance.uploadImage(pickedFile);
      setState(() {
        listProductVariations[variantIndex].image = imageUrl;
      });
    }
  }

  void deleteVariant(int index) async {
    if (listProductVariations[index].image != '') {
      await ProductController.instance
          .deleteImage(listProductVariations[index].image);
    }
    setState(() {
      listProductVariations.removeAt(index);
      if (index < variantImageList.length) {
        variantImageList.removeAt(index);
      }
    });
  }

  void deleteThumbnail() async {
    await ProductController.instance.deleteImage(thumbnailUrl);
    setState(() {
      thumbnail = null;
      thumbnailUrl = '';
    });
  }

  void deleteImage(int index) async {
    await ProductController.instance.deleteImage(imageUrlList[index]);
    setState(() {
      imageList.removeAt(index);
      imageUrlList.removeAt(index);
    });
  }

  void deleteVariantImage(int index) async {
    await ProductController.instance
        .deleteImage(listProductVariations[index].image);

    setState(() {
      listProductVariations[index].image = '';
      if (index < variantImageList.length) {
        variantImageList[index] = null;
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    final productController = ProductController.instance;
    final categoryController = CategoryController.instance;
    final userController = UserController.instance;
    productController.storeId = userController.user.value.storeId!;
    final brandController = Get.put(BrandController());
    return Scaffold(
      appBar:
          const MyAppBar(showBackArrow: true, title: Text('Add new Product')),
      body: SingleChildScrollView(
        child: Container(
          padding: const EdgeInsets.all(Sizes.defaultSpace),
          child: Form(
            key: productController.addProductFormKey,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                TextFormField(
                  controller: productController.title,
                  validator: (value) =>
                      Validator.validateEmptyText('Title', value),
                  decoration: const InputDecoration(
                      prefixIcon: Icon(Iconsax.note_text), labelText: 'Title'),
                ),
                const SizedBox(height: Sizes.spaceBtwInputFields),
                DropdownButtonFormField(
                  value: selectedCategory,
                  items: categoryController.allCategories
                      .map((CategoryModel items) {
                    return DropdownMenuItem(
                      value: items.id,
                      child: Text(items.name),
                    );
                  }).toList(),
                  onChanged: (String? newValue) {
                    selectedCategory = newValue!;
                    productController.categoryId = selectedCategory;
                  },
                  decoration: const InputDecoration(
                      prefixIcon: Icon(Iconsax.category),
                      labelText: 'Category'),
                  validator: (value) =>
                      value == null ? 'Please select an option.' : null,
                ),
                const SizedBox(height: Sizes.spaceBtwInputFields),
                DropdownButtonFormField(
                  value: selectedBrand,
                  items: brandController.allBrands.map((BrandModel items) {
                    return DropdownMenuItem(
                      value: items,
                      child: Text(items.name),
                    );
                  }).toList(),
                  onChanged: (BrandModel? newValue) {
                    selectedBrand = newValue!;
                    productController.brand = selectedBrand;
                  },
                  decoration: const InputDecoration(
                      prefixIcon: Icon(Iconsax.ranking), labelText: 'Brand'),
                  validator: (value) =>
                      value == null ? 'Please select an option.' : null,
                ),
                const SizedBox(height: Sizes.spaceBtwInputFields),
                TextFormField(
                  controller: productController.description,
                  keyboardType: TextInputType.multiline,
                  minLines: 3,
                  maxLines: null,
                  decoration: const InputDecoration(
                      prefixIcon: Icon(Iconsax.clipboard_text),
                      labelText: 'Description'),
                ),
                const SizedBox(height: Sizes.spaceBtwInputFields),
                TextFormField(
                  controller: productController.stock,
                  keyboardType: TextInputType.number,
                  validator: Validator.validateStock,
                  decoration: const InputDecoration(
                      prefixIcon: Icon(Iconsax.square), labelText: 'Stock'),
                ),
                const SizedBox(height: Sizes.spaceBtwInputFields),
                TextFormField(
                  controller: productController.price,
                  keyboardType: TextInputType.number,
                  validator: (value) => Validator.validatePrice(value, false),
                  decoration: const InputDecoration(
                      prefixIcon: Icon(Iconsax.wallet_1), labelText: 'Price'),
                ),
                const SizedBox(height: Sizes.spaceBtwInputFields),
                TextFormField(
                  controller: productController.salePrice,
                  keyboardType: TextInputType.number,
                  validator: (value) => Validator.validateSalePrice(value, ''),
                  decoration: const InputDecoration(
                      prefixIcon: Icon(Iconsax.flash_circle),
                      labelText: 'Sale Price'),
                ),
                const SizedBox(height: Sizes.spaceBtwInputFields),
                TextFormField(
                  controller: productController.weight,
                  keyboardType: TextInputType.number,
                  validator: Validator.validateWeight,
                  decoration: const InputDecoration(
                      prefixIcon: Icon(Iconsax.weight), labelText: 'Weight'),
                ),
                const SizedBox(height: Sizes.spaceBtwInputFields),
                TextFormField(
                  controller: productController.width,
                  keyboardType: TextInputType.number,
                  validator: Validator.validateWidth,
                  decoration: const InputDecoration(
                      prefixIcon: Icon(Iconsax.arrow_swap), labelText: 'Width'),
                ),
                const SizedBox(height: Sizes.spaceBtwInputFields),
                TextFormField(
                  controller: productController.length,
                  keyboardType: TextInputType.number,
                  validator: Validator.validateLength,
                  decoration: const InputDecoration(
                      prefixIcon: Icon(Iconsax.arrow_swap_horizontal),
                      labelText: 'Length'),
                ),
                const SizedBox(height: Sizes.spaceBtwInputFields),
                TextFormField(
                  controller: productController.height,
                  keyboardType: TextInputType.number,
                  validator: Validator.validateHeight,
                  decoration: const InputDecoration(
                      prefixIcon: Icon(Iconsax.arrow_swap),
                      labelText: 'Height'),
                ),
                const SizedBox(height: Sizes.spaceBtwInputFields),
                TextFormField(
                  controller: productController.sku,
                  decoration: const InputDecoration(
                      prefixIcon: Icon(Iconsax.barcode), labelText: 'SKU'),
                ),
                const SizedBox(height: Sizes.spaceBtwInputFields),
                const Text(
                  'Thumbnail',
                  style: TextStyle(fontSize: 17, fontWeight: FontWeight.w500),
                ),
                GestureDetector(
                  onTap: pickThumbnail,
                  child: Container(
                    height: 200,
                    decoration: BoxDecoration(
                      color: Colors.grey[200],
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: thumbnail != null
                        ? Stack(
                            children: [
                              Positioned.fill(
                                child: (thumbnail!.path.contains('http'))
                                    ? Image.network(
                                        thumbnail!.path,
                                        fit: BoxFit.contain,
                                      )
                                    : Image.file(
                                        File(thumbnail!.path),
                                        fit: BoxFit.contain,
                                      ),
                              ),
                              Positioned(
                                top: 3,
                                right: 103,
                                child: GestureDetector(
                                  onTap: () => deleteThumbnail(),
                                  child: const CircleAvatar(
                                    radius: 15,
                                    backgroundColor: Colors.black54,
                                    child: Icon(
                                      Icons.close,
                                      size: 15,
                                      color: Colors.white,
                                    ),
                                  ),
                                ),
                              ),
                            ],
                          )
                        : const Center(
                            child: Icon(
                              Icons.camera_alt,
                              size: 40,
                              color: Colors.grey,
                            ),
                          ),
                  ),
                ),
                const SizedBox(height: Sizes.spaceBtwInputFields),
                const Text(
                  'Images',
                  style: TextStyle(fontSize: 17, fontWeight: FontWeight.w500),
                ),
                GestureDetector(
                  onTap: pickMultiImages,
                  child: Container(
                    height: 200,
                    decoration: BoxDecoration(
                      color: Colors.grey[200],
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: imageList.isNotEmpty
                        ? GridView.builder(
                            itemCount: imageList.length,
                            gridDelegate:
                                const SliverGridDelegateWithFixedCrossAxisCount(
                              crossAxisCount: 3,
                            ),
                            itemBuilder: (context, imgIndex) {
                              return imageList[imgIndex] != null
                                  ? Stack(
                                      children: [
                                        Positioned.fill(
                                          child: imageList[imgIndex]!
                                                  .path
                                                  .contains('http')
                                              ? Image.network(
                                                  imageList[imgIndex]!.path,
                                                  fit: BoxFit.contain,
                                                )
                                              : Image.file(
                                                  File(imageList[imgIndex]!
                                                      .path),
                                                  fit: BoxFit.contain,
                                                ),
                                        ),
                                        Positioned(
                                          top: 3,
                                          right: 3,
                                          child: CircleAvatar(
                                              radius: 15,
                                              backgroundColor: Colors.black54,
                                              child: IconButton(
                                                icon: const Icon(
                                                  Icons.close,
                                                  size: 15,
                                                  color: Colors.white,
                                                ),
                                                onPressed: () =>
                                                    deleteImage(imgIndex),
                                              )),
                                        ),
                                      ],
                                    )
                                  : const Center(
                                      child: Icon(
                                        Icons.camera_alt,
                                        size: 40,
                                        color: Colors.grey,
                                      ),
                                    );
                            },
                          )
                        : const Center(
                            child: Icon(
                              Icons.camera_alt,
                              size: 40,
                              color: Colors.grey,
                            ),
                          ),
                  ),
                ),
                const SizedBox(height: Sizes.defaultSpace),
                ListView.builder(
                  physics: const NeverScrollableScrollPhysics(),
                  shrinkWrap: true,
                  itemCount: listProductVariations.length,
                  itemBuilder: (context, index) {
                    return Column(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              'Variant ${index + 1}',
                              style: const TextStyle(
                                  fontSize: 16, fontWeight: FontWeight.bold),
                            ),
                            IconButton(
                              icon:
                                  const Icon(Iconsax.trash, color: Colors.red),
                              onPressed: () => deleteVariant(index),
                            ),
                          ],
                        ),
                        const SizedBox(height: Sizes.spaceBtwInputFields),
                        InkWell(
                          onTap: () {
                            openColorPicker(context, index);
                          },
                          child: Container(
                            padding: const EdgeInsets.all(5),
                            child: Row(
                              children: [
                                const Text('Pick Product\'s Color',
                                    style: TextStyle(
                                        color: Colors.black,
                                        fontSize: 16,
                                        fontWeight: FontWeight.w500)),
                                const SizedBox(width: 16),
                                Container(
                                  width: 30,
                                  height: 30,
                                  decoration: BoxDecoration(
                                    color: isValidHexColor(
                                            listProductVariations[index]
                                                .attributeValues['Color']!)
                                        ? Color(int.parse(
                                            '0xff${listProductVariations[index].attributeValues['Color']}'))
                                        : Colors.transparent,
                                    borderRadius: BorderRadius.circular(30),
                                    border: Border.all(
                                        color: Colors
                                            .black), // Add this line for border
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                        const SizedBox(height: Sizes.spaceBtwInputFields),
                        TextFormField(
                          decoration: const InputDecoration(
                            labelText: 'Size',
                            prefixIcon: Icon(Iconsax.size),
                          ),
                          onChanged: (value) {
                            setState(() {
                              listProductVariations[index]
                                  .attributeValues['Size'] = value;
                            });
                          },
                        ),
                        const SizedBox(height: Sizes.spaceBtwInputFields),
                        TextFormField(
                          decoration: const InputDecoration(
                            labelText: 'Other Attribute',
                            prefixIcon: Icon(Iconsax.add_circle),
                          ),
                          onChanged: (value) {
                            setState(() {
                              listProductVariations[index]
                                  .attributeValues['Other Attribute'] = value;
                            });
                          },
                        ),
                        const SizedBox(height: Sizes.spaceBtwInputFields),
                        TextFormField(
                          keyboardType: TextInputType.multiline,
                          minLines: 3,
                          maxLines: null,
                          decoration: const InputDecoration(
                            prefixIcon: Icon(Iconsax.clipboard_text),
                            labelText: 'Variant Description',
                          ),
                          onChanged: (value) {
                            setState(() {
                              listProductVariations[index].description = value;
                            });
                          },
                        ),
                        const SizedBox(height: Sizes.spaceBtwInputFields),
                        TextFormField(
                          validator: Validator.validateStock,
                          decoration: const InputDecoration(
                              labelText: 'Stock',
                              prefixIcon: Icon(Iconsax.square)),
                          onChanged: (value) {
                            setState(() {
                              listProductVariations[index].stock =
                                  int.parse(value);
                            });
                          },
                          keyboardType: TextInputType.number,
                        ),
                        const SizedBox(height: Sizes.spaceBtwInputFields),
                        TextFormField(
                          validator: (value) =>
                              Validator.validatePrice(value, true),
                          decoration: const InputDecoration(
                              labelText: 'Price',
                              prefixIcon: Icon(Iconsax.wallet_1)),
                          onChanged: (value) {
                            setState(() {
                              listProductVariations[index].price =
                                  double.parse(value);
                            });
                          },
                          keyboardType: TextInputType.number,
                        ),
                        const SizedBox(height: Sizes.spaceBtwInputFields),
                        TextFormField(
                          validator: (value) =>
                              Validator.validateSalePrice(value, listProductVariations[index].price.toString()),
                          decoration: const InputDecoration(
                              labelText: 'Sale Price',
                              prefixIcon: Icon(Iconsax.flash_circle)),
                          onChanged: (value) {
                            setState(() {
                              listProductVariations[index].salePrice =
                                  double.parse(value);
                            });
                          },
                          keyboardType: TextInputType.number,
                        ),
                        const SizedBox(height: Sizes.spaceBtwInputFields),
                        const Text(
                          'Image',
                          style: TextStyle(
                              fontSize: 17, fontWeight: FontWeight.w500),
                        ),
                        GestureDetector(
                          onTap: () => pickVariantImage(index),
                          child: Container(
                            height: 200,
                            decoration: BoxDecoration(
                              color: Colors.grey[200],
                              borderRadius: BorderRadius.circular(10),
                            ),
                            child: variantImageList.length > index &&
                                    variantImageList[index] != null
                                ? Stack(
                                    children: [
                                      Positioned.fill(
                                        child: (variantImageList[index]!
                                                .path
                                                .contains('http'))
                                            ? Image.network(
                                                variantImageList[index]!.path,
                                                fit: BoxFit.contain,
                                              )
                                            : Image.file(
                                                File(variantImageList[index]!
                                                    .path),
                                                fit: BoxFit.contain,
                                              ),
                                      ),
                                      Positioned(
                                        top: 3,
                                        right: 103,
                                        child: GestureDetector(
                                          onTap: () =>
                                              deleteVariantImage(index),
                                          child: const CircleAvatar(
                                            radius: 15,
                                            backgroundColor: Colors.black54,
                                            child: Icon(
                                              Icons.close,
                                              size: 15,
                                              color: Colors.white,
                                            ),
                                          ),
                                        ),
                                      ),
                                    ],
                                  )
                                : const Center(
                                    child: Icon(
                                      Icons.camera_alt,
                                      size: 40,
                                      color: Colors.grey,
                                    ),
                                  ),
                          ),
                        ),
                        const SizedBox(height: Sizes.spaceBtwInputFields),
                      ],
                    );
                  },
                ),
                SizedBox(
                    width: double.infinity,
                    child: OutlinedButton(
                        child: const Text('Add Product Variant',
                            style: TextStyle(color: MyColors.primary)),
                        onPressed: () {
                          setState(() {
                            // Add an empty variant when the button is pressed
                            listProductVariations.add(ProductVariationModel(
                                id: listProductVariations.length.toString(),
                                attributeValues: {
                                  'Color': '',
                                  'Size': '',
                                  'Other Attribute': ''
                                }));

                            variantImageList.add(null);
                          });
                        })),
                const SizedBox(height: Sizes.spaceBtwInputFields),
                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton(
                      onPressed: () => {
                            productController.thumbnail = thumbnailUrl,
                            productController.images = imageUrlList,
                            productController.productVariations =
                                listProductVariations,
                            productController.addNewProduct()
                          },
                      child: const Text('Save')),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
