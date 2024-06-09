import 'dart:io';

import 'package:btl/features/shop/controllers/brand_controller.dart';
import 'package:btl/features/shop/controllers/categories_controller.dart';
import 'package:btl/features/shop/controllers/product/product_controller.dart';
import 'package:btl/features/shop/models/brand_model.dart';
import 'package:btl/features/shop/models/category_model.dart';
import 'package:btl/features/shop/models/product_variation_model.dart';
import 'package:btl/utils/constants/colors.dart';
import 'package:btl/utils/http/http_client.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:get/get.dart';
import 'package:flutter/material.dart';
import 'package:iconsax/iconsax.dart';
import 'package:image_picker/image_picker.dart';
import '../../../../../utils/constants/sizes.dart';
import '../../../../common/widgets/appbar/appbar.dart';
import '../../../../utils/validators/validation.dart';
import '../../controllers/address_controller.dart';
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
  Color selectedColor = MyColors.light;
  List<ProductVariationModel> listProductVariations = [];

  String image_url = '';

  final List<XFile?> _imageList = [];

  XFile? _image;
  List<String> imageList_url = [];

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
                      .attributeValues
                      .addAll({'Color': colorString});
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

  Future<void> _pickImage() async {
    var pickedFile = await ImagePicker().pickImage(source: ImageSource.gallery);

    if (pickedFile != null) {
      _image = pickedFile;
      setState(() {
        _imageList.last = _image;
      });
      String uniqueFileName = '${DateTime.now().millisecondsSinceEpoch}.jpg';

      Reference referenceRoot = FirebaseStorage.instance.ref();
      Reference referenceDirImages = referenceRoot.child('images');

      Reference referenceImageToUpload =
          referenceDirImages.child(uniqueFileName);

      try {
        await referenceImageToUpload.putFile(File(_image!.path));
        image_url = await referenceImageToUpload.getDownloadURL();
        setState(() {
          imageList_url.add(image_url);
        });
        //print(imageList_url.length);
      } catch (error) {
        print(error);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final productController = Get.put(ProductController());
    final categoryController = Get.put(CategoryController());
    final brandController = Get.put(BrandController());
    return Scaffold(
      appBar:
          const MyAppBar(showBackArrow: true, title: Text('Add new Product')),
      body: SingleChildScrollView(
        child: Container(
          padding: const EdgeInsets.all(Sizes.defaultSpace),
          child: Form(
            // key: controller.productFormKey,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                TextFormField(
                  // controller: controller.title,
                  validator: (value) =>
                      Validator.validateEmptyText('Title', value),
                  decoration: const InputDecoration(
                      prefixIcon: Icon(Iconsax.note_text), labelText: 'Title'),
                ),
                const SizedBox(height: Sizes.spaceBtwInputFields),
                TextFormField(
                  // controller: controller.stock,
                  keyboardType: TextInputType.number,
                  validator: Validator.validatePositiveInteger,
                  decoration: const InputDecoration(
                      prefixIcon: Icon(Iconsax.square), labelText: 'Stock'),
                ),
                const SizedBox(height: Sizes.spaceBtwInputFields),
                TextFormField(
                  // controller: controller.price,
                  keyboardType: TextInputType.number,
                  validator: Validator.validatePositiveNumber,
                  decoration: const InputDecoration(
                      prefixIcon: Icon(Iconsax.wallet_1), labelText: 'Price'),
                ),
                const SizedBox(height: Sizes.spaceBtwInputFields),
                TextFormField(
                  // controller: controller.description,
                  keyboardType: TextInputType.multiline,
                  minLines: 3,
                  maxLines: null,
                  decoration: const InputDecoration(
                      prefixIcon: Icon(Iconsax.clipboard_text),
                      labelText: 'Description'),
                ),
                const SizedBox(height: Sizes.spaceBtwInputFields),
                TextFormField(
                  // controller: controller.salePrice,
                  validator: (value) => Validator.validateSalePrice(value, ''),
                  decoration: const InputDecoration(
                      prefixIcon: Icon(Iconsax.flash_circle),
                      labelText: 'Sale Price'),
                ),
                const SizedBox(height: Sizes.spaceBtwInputFields),
                TextFormField(
                  // controller: controller.sku,
                  decoration: const InputDecoration(
                      prefixIcon: Icon(Iconsax.barcode), labelText: 'SKU'),
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
                    // controller.provinceID =
                    //     selectedProvince!.split(':')[0].trim();
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
                    // controller.provinceID =
                    //     selectedProvince!.split(':')[0].trim();
                  },
                  decoration: const InputDecoration(
                      prefixIcon: Icon(Iconsax.ranking), labelText: 'Brand'),
                  validator: (value) =>
                      value == null ? 'Please select an option.' : null,
                ),
                const SizedBox(height: Sizes.spaceBtwInputFields),
                ListView.builder(
                  physics: const NeverScrollableScrollPhysics(),
                  shrinkWrap: true,
                  itemCount: listProductVariations.length,
                  itemBuilder: (context, index) {
                    return Column(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Text(
                          'Variant ${index + 1}',
                          style: const TextStyle(
                              fontSize: 16, fontWeight: FontWeight.bold),
                        ),
                        const SizedBox(height: Sizes.spaceBtwInputFields),
                        TextField(
                          decoration: const InputDecoration(
                            labelText: 'Size',
                            border: OutlineInputBorder(),
                          ),
                          onChanged: (value) {
                            setState(() {
                              listProductVariations[index]
                                  .attributeValues
                                  .addAll({'Size': value});
                            });
                          },
                        ),
                        const SizedBox(height: 8),
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
                        const SizedBox(height: 8),
                        TextField(
                          decoration: const InputDecoration(
                            labelText: 'Price',
                            border: OutlineInputBorder(),
                          ),
                          onChanged: (value) {
                            setState(() {
                              listProductVariations[index].price =
                                  double.parse(value);
                            });
                          },
                          keyboardType: TextInputType.number,
                        ),
                        const SizedBox(height: 8),
                        TextField(
                          decoration: const InputDecoration(
                            labelText: 'Stock',
                            border: OutlineInputBorder(),
                          ),
                          onChanged: (value) {
                            setState(() {
                              listProductVariations[index].stock =
                                  int.parse(value);
                            });
                          },
                          keyboardType: TextInputType.number,
                        ),
                        const SizedBox(height: 8),
                        TextField(
                          decoration: const InputDecoration(
                            labelText: 'Variant Description',
                            border: OutlineInputBorder(),
                          ),
                          onChanged: (value) {
                            setState(() {
                              listProductVariations[index].description = value;
                            });
                          },
                        ),
                        const SizedBox(height: 16),
                        GestureDetector(
                          onTap: _pickImage,
                          child: Container(
                              height: 200,
                              decoration: BoxDecoration(
                                color: Colors.grey[200],
                                borderRadius: BorderRadius.circular(10),
                              ),
                              child: (_imageList.length > index &&
                                      _imageList[index] != null)
                                  ? (_imageList[index]!.path.contains('http')
                                      ? Image.network(
                                          _imageList[index]!.path,
                                          fit: BoxFit.contain,
                                        )
                                      : Image.file(
                                          File(_imageList[index]!.path),
                                          fit: BoxFit.contain,
                                        ))
                                  : const Center(
                                      child: Icon(
                                        Icons.camera_alt,
                                        size: 40,
                                        color: Colors.grey,
                                      ),
                                    )),
                        ),
                        const SizedBox(height: 16),
                      ],
                    );
                  },
                ),
                OutlinedButton(
                  style: const ButtonStyle(
                    backgroundColor: MaterialStatePropertyAll<Color>(
                        Color.fromARGB(255, 255, 255, 255)),
                    minimumSize: MaterialStatePropertyAll<Size>(
                        Size(double.infinity, 50)),
                  ),
                  onPressed: () {
                    setState(() {
                      // Add an empty variant when the button is pressed
                      listProductVariations.add(ProductVariationModel(
                          id: '', attributeValues: {'Size': '', 'Color': ''}));
                      // _imageList.add(null);
                    });
                  },
                  child: const Text(
                    'Add Variant',
                    style: TextStyle(color: MyColors.primary),
                  ),
                ),
                const SizedBox(height: Sizes.defaultSpace),
                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton(
                      onPressed: () {}, child: const Text('Save')),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
