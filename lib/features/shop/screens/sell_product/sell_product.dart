import 'dart:io';
import 'package:ecommerce_app_mobile/Service/repository/authentication_repository.dart';
import 'package:ecommerce_app_mobile/common/widgets/appbar/appbar.dart';
import 'package:ecommerce_app_mobile/features/shop/controllers/product_controller/brand_controller.dart';
import 'package:ecommerce_app_mobile/features/shop/controllers/product_controller/product_category_controller.dart';
import 'package:ecommerce_app_mobile/features/shop/controllers/product_controller/product_controller.dart';
import 'package:ecommerce_app_mobile/features/shop/controllers/product_controller/product_variant_controller.dart';
import 'package:ecommerce_app_mobile/features/shop/models/product_model/brand_model.dart';
import 'package:ecommerce_app_mobile/features/shop/models/product_model/product_variant_model.dart';
import 'package:ecommerce_app_mobile/utils/constants/colors.dart';
import 'package:ecommerce_app_mobile/utils/constants/sizes.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:flutter_colorpicker/flutter_colorpicker.dart';
import 'package:get/get.dart';
import 'package:iconsax/iconsax.dart';

import 'package:image_picker/image_picker.dart';

class SellProductScreen extends StatefulWidget {
  const SellProductScreen({super.key});

  @override
  State<SellProductScreen> createState() => _SellProductScreenState();
}

class _SellProductScreenState extends State<SellProductScreen> {
  // ignore: unused_field
  final _authRepo = Get.put(AuthenticationRepository());
  final brandController = Get.put(BrandController());

  String selectedCategory = '';
  String brandName = '';

  // ignore: non_constant_identifier_names
  String image_url = '';

  // ignore: non_constant_identifier_names
  List<String> imageList_url = [];
  String description = '';
  int discount = 0;
  int quantity = 0;
  String name = '';
  List<ProductVariantModel> variants = [];
  List<String> variants_path = [];
  Color selectedColor = const Color(0xff443a49);
  late Future<List<String>> _brandNameData;
  bool _brandDataLoaded = false;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    if (!_brandDataLoaded) {
      _brandNameData = _getBrandData();
      _brandDataLoaded = true;
    }
  }

  Future<List<String>> _getBrandData() async {
    List<BrandModel> brands = await brandController.getAllBrandsData();

    return brands.map((brand) => brand.name).toList();
  }

  //double price = 0.0;
  static const List<String> categoryList = <String>[
    'Sport',
    'Clothes',
    'Shoe',
    'Cosmetics',
    'Toy',
    'Furniture',
    'Jewelery',
    'Electronics'
  ];

  String dropdownValue = categoryList.first;

  final List<XFile?> _imageList = [];

  XFile? _image;

  Future<void> _pickImage(int index) async {
    var pickedFile = await ImagePicker().pickImage(source: ImageSource.gallery);

    if (pickedFile != null) {
      _image = pickedFile;
      setState(() {
        _imageList[index] = _image;
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
          imageList_url[index]= image_url;
        });
        //print(imageList_url.length);
      } catch (error) {
        print(error);
      }
    }
  }

  void deleteVariant(int index) async {
    if (index < variants.length) {
      setState(() {
        variants.removeAt(index);
        imageList_url.removeAt(index);
        _imageList.removeAt(index);
      });
    }
  }

  void deleteVariantImage(int index) async {
    if (index < variants.length) {
      setState(() {
        imageList_url[index] = '';
        _imageList[index] = null;
      });
    }
  }

  bool _isValidHexColor(String hexColor) {
    final hexRegex = RegExp(r'^#?([0-9a-fA-F]{6}|[0-9a-fA-F]{3})$');
    return hexRegex.hasMatch(hexColor);
  }

  void _openColorPicker(BuildContext context, int variantIndex) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Pick color'),
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
                  variants[variantIndex].color = selectedColor.value
                      .toRadixString(16)
                      .substring(2)
                      .toUpperCase(); // Lưu mã màu dưới dạng HEX
                  //print(variantIndex);
                  print(variants[variantIndex].color);
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

  @override
  Widget build(BuildContext context) {
    Get.put(ProductController());
    Get.put(ProductVariantController());
    Get.put(ProductCategoryController());
    Get.put(BrandController());
    final authRepo = Get.put(AuthenticationRepository());

    return GestureDetector(
      onTap: () {
        FocusScope.of(context).unfocus();
      },
      child: Scaffold(
        appBar: const TAppBar(
          title: Text('Add new Product'),
          showBackArrow: true,
        ),
        body: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.all(TSizes.defaultSpace),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                DropdownMenu<String>(
                  hintText: 'Category',
                  leadingIcon: const Icon(Iconsax.category),
                  textStyle: const TextStyle(
                    fontSize: 15,
                  ),
                  width: 200,
                  initialSelection: null,
                  onSelected: (String? value) {
                    // This is called when the user selects an item.
                    setState(() {
                      dropdownValue = value!;
                      selectedCategory = dropdownValue;
                    });
                  },
                  dropdownMenuEntries: categoryList
                      .map<DropdownMenuEntry<String>>((String value) {
                    return DropdownMenuEntry<String>(
                        value: value, label: value);
                  }).toList(),
                ),
                const SizedBox(height: TSizes.spaceBtwInputFields),
                FutureBuilder<List<String>>(
                  future: _brandNameData,
                  builder: (context, snapshot) {
                    if (snapshot.connectionState == ConnectionState.done) {
                      List<String> brandList = snapshot.data!;

                      return Autocomplete<String>(
                        optionsBuilder: (TextEditingValue textEditingValue) {
                          if (textEditingValue.text == '') {
                            return const Iterable<String>.empty();
                          }
                          String query = textEditingValue.text
                              .toLowerCase()
                              .trim()
                              .replaceAll(RegExp(r'\s+'), ' ');
                          return brandList.where((String item) {
                            return item.toLowerCase().contains(query);
                          });
                        },
                        onSelected: (String selectedBrand) {
                          setState(() {
                            brandName = selectedBrand;
                          });
                        },
                        fieldViewBuilder: (BuildContext context,
                            TextEditingController textEditingController,
                            FocusNode focusNode,
                            VoidCallback onFieldSubmitted) {
                          return TextField(
                            controller: textEditingController,
                            focusNode: focusNode,
                            onChanged: (value) {
                              // Handle text changes here
                              setState(() {
                                brandName = value;
                              });
                            },
                            decoration: const InputDecoration(
                                labelText: 'Brand',
                                border: OutlineInputBorder(),
                                prefixIcon: Icon(Iconsax.star_1)),
                          );
                        },
                      );
                    } else if (snapshot.hasError) {
                      return Text('Error: ${snapshot.error}');
                    }
                    return const CircularProgressIndicator();
                  },
                ),
                const SizedBox(height: TSizes.spaceBtwInputFields),
                TextField(
                  decoration: const InputDecoration(
                      labelText: 'Name',
                      border: OutlineInputBorder(),
                      prefixIcon: Icon(Iconsax.note_text)),
                  onChanged: (value) {
                    setState(() {
                      name = value;
                    });
                  },
                ),
                const SizedBox(height: TSizes.spaceBtwInputFields),
                TextFormField(
                  decoration: const InputDecoration(
                      labelText: 'Description',
                      border: OutlineInputBorder(),
                      prefixIcon: Icon(Iconsax.clipboard_text)),
                  onChanged: (value) {
                    setState(() {
                      description = value;
                    });
                  },
                  keyboardType: TextInputType.multiline,
                  minLines: 3,
                  maxLines: null,
                ),
                const SizedBox(height: TSizes.spaceBtwInputFields),
                TextField(
                  decoration: const InputDecoration(
                      labelText: 'Discount (%)',
                      border: OutlineInputBorder(),
                      prefixIcon: Icon(Iconsax.flash_circle)),
                  onChanged: (value) {
                    setState(() {
                      discount = int.parse(value);
                    });
                  },
                ),
                const SizedBox(height: TSizes.spaceBtwSections),
                ListView.builder(
                  physics: const NeverScrollableScrollPhysics(),
                  shrinkWrap: true,
                  itemCount: variants.length,
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
                        const SizedBox(height: TSizes.spaceBtwInputFields),
                        TextField(
                          decoration: const InputDecoration(
                              labelText: 'Size',
                              border: OutlineInputBorder(),
                              prefixIcon: Icon(Iconsax.size)),
                          onChanged: (value) {
                            setState(() {
                              variants[index].size = value;
                            });
                          },
                        ),
                        const SizedBox(height: TSizes.spaceBtwInputFields),
                        InkWell(
                          onTap: () {
                            _openColorPicker(context, index);
                          },
                          child: Container(
                            padding: const EdgeInsets.all(5),
                            // decoration: BoxDecoration(
                            //   border: Border.all(color: Colors.grey),
                            //   borderRadius: BorderRadius.circular(5.0),
                            // ),
                            child: Row(
                              children: [
                                const Text('Pick Color',
                                    style: TextStyle(
                                        color: Colors.black,
                                        fontSize: 16,
                                        fontWeight: FontWeight.w500)),
                                const SizedBox(width: 16),
                                Container(
                                  width: 30,
                                  height: 30,
                                  decoration: BoxDecoration(
                                    color:
                                        _isValidHexColor(variants[index].color)
                                            ? Color(int.parse(
                                                '0xff${variants[index].color}'))
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
                        const SizedBox(height: TSizes.spaceBtwInputFields),
                        TextField(
                          decoration: const InputDecoration(
                              labelText: 'Price (\$)',
                              border: OutlineInputBorder(),
                              prefixIcon: Icon(Iconsax.wallet_1)),
                          onChanged: (value) {
                            setState(() {
                              variants[index].price = double.parse(value);
                            });
                          },
                          keyboardType: TextInputType.number,
                        ),
                        const SizedBox(height: TSizes.spaceBtwInputFields),
                        TextField(
                          decoration: const InputDecoration(
                              labelText: 'Stock',
                              border: OutlineInputBorder(),
                              prefixIcon: Icon(Iconsax.more_square)),
                          onChanged: (value) {
                            setState(() {
                              variants[index].quantity = int.parse(value);
                            });
                          },
                          keyboardType: TextInputType.number,
                        ),
                        const SizedBox(height: TSizes.spaceBtwInputFields),
                        TextField(
                          decoration: const InputDecoration(
                              labelText: 'Height (cm)',
                              border: OutlineInputBorder(),
                              prefixIcon: Icon(Iconsax.arrow_swap)),
                          onChanged: (value) {
                            setState(() {
                              variants[index].height = int.parse(value);
                            });
                          },
                          keyboardType: TextInputType.number,
                        ),
                        const SizedBox(height: TSizes.spaceBtwInputFields),
                        TextField(
                          decoration: const InputDecoration(
                              labelText: 'Length (cm)',
                              border: OutlineInputBorder(),
                              prefixIcon: Icon(Iconsax.arrow_swap_horizontal)),
                          onChanged: (value) {
                            setState(() {
                              variants[index].length = int.parse(value);
                            });
                          },
                          keyboardType: TextInputType.number,
                        ),
                        const SizedBox(height: TSizes.spaceBtwInputFields),
                        TextField(
                          decoration: const InputDecoration(
                              labelText: 'Width (cm)',
                              border: OutlineInputBorder(),
                              prefixIcon: Icon(Iconsax.arrow_swap)),
                          onChanged: (value) {
                            setState(() {
                              variants[index].width = int.parse(value);
                            });
                          },
                          keyboardType: TextInputType.number,
                        ),
                        const SizedBox(height: TSizes.spaceBtwInputFields),
                        TextField(
                          decoration: const InputDecoration(
                              labelText: 'Weight (g)',
                              border: OutlineInputBorder(),
                              prefixIcon: Icon(Iconsax.d_square)),
                          onChanged: (value) {
                            setState(() {
                              variants[index].weight = int.parse(value);
                            });
                          },
                          keyboardType: TextInputType.number,
                        ),
                        const SizedBox(height: TSizes.spaceBtwInputFields),
                        TextFormField(
                          decoration: const InputDecoration(
                              labelText: 'Variant Description',
                              border: OutlineInputBorder(),
                              prefixIcon: Icon(Iconsax.clipboard_text)),
                          onChanged: (value) {
                            setState(() {
                              variants[index].descriptionVariant = value;
                            });
                          },
                          keyboardType: TextInputType.multiline,
                          minLines: 3,
                          maxLines: null,
                        ),
                        const SizedBox(height: TSizes.spaceBtwInputFields),
                        const Text(
                          'Variant Image',
                          style: TextStyle(
                              fontSize: 17, fontWeight: FontWeight.w500),
                        ),
                        GestureDetector(
                            onTap: () => _pickImage(index),
                            child: Container(
                                height: 200,
                                decoration: BoxDecoration(
                                  color: Colors.grey[200],
                                  borderRadius: BorderRadius.circular(10),
                                ),
                                child: _imageList.length > index &&
                                        _imageList[index] == null
                                    ? const Center(
                                        child: Column(
                                          mainAxisAlignment:
                                              MainAxisAlignment.center,
                                          children: [
                                            Icon(
                                              Icons.camera_alt,
                                              size: 40,
                                              color: Colors.grey,
                                            ),
                                            SizedBox(
                                                height:
                                                    8), // Add space between icon and text
                                            Text(
                                              'Tap to add image',
                                              style: TextStyle(
                                                color: Colors.grey,
                                                fontSize: 16,
                                              ),
                                            ),
                                          ],
                                        ),
                                      )
                                    : Stack(
                                        children: [
                                          Positioned.fill(
                                              child: (_imageList[index]!
                                                      .path
                                                      .contains('http')
                                                  ? Image.network(
                                                      _imageList[index]!.path,
                                                      fit: BoxFit.contain)
                                                  : Image.file(
                                                      File(_imageList[index]!
                                                          .path),
                                                      fit: BoxFit.contain,
                                                    ))),
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
                                      ))),
                        const SizedBox(height: TSizes.defaultSpace),
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
                      variants.add(ProductVariantModel(
                        size: '',
                        color: '',
                        price: 0.0,
                        imageURL: '',
                        id: '',
                        quantity: 0,
                        descriptionVariant: '',
                        height: 0,
                        width: 0,
                        length: 0,
                        weight: 0,
                      ));
                      _imageList.add(null);
                      imageList_url.add('');
                    });
                  },
                  child: const Text(
                    'Add Variant',
                    style: TextStyle(color: TColors.primary),
                  ),
                ),
                const SizedBox(height: 16),
                ElevatedButton(
                  style: const ButtonStyle(
                    minimumSize: MaterialStatePropertyAll<Size>(
                        Size(double.infinity, 50)),
                  ),
                  onPressed: () async {
                    // Handle product submission logic here
                    // print('Category: $selectedCategory');
                    // print('Brand: $brandName');
                    // print('Name: $name');
                    // //print('Image: $image_url');
                    // print('Description: $description');
                    // print('Discount: $discount');
                    // print('Variants: $variants');

                    /// Liên kết với category
                    final categoryResult = await ProductCategoryController
                        .instance
                        .getCategoryByName(selectedCategory);

                    /// Tao bien the va cap nhat anh
                    for (int i = 0; i < variants.length; i++) {
                      variants[i].imageURL = imageList_url[i];
                      variants_path.add(await ProductVariantController.instance
                          .createProductVariant(variants[i]));
                    }

                    /// Check brand trung lap hoac tao brand moi
                    String brandId;
                    brandId = await BrandController.instance
                        .checkDuplicatedBrand(brandName);

                    if (brandId == 'false') {
                      BrandModel brandModel = BrandModel(
                        name: brandName.trim().replaceAll(RegExp(r'\s+'), ' '),
                        imageUrl: categoryResult.imageUrl,
                        userId: authRepo.firebaseUser.value!.uid,
                      );
                      brandId = await BrandController.instance
                          .createBrand(brandModel);
                    }

                    /// Tao san pham
                    ProductController.instance.createProduct(
                      brand_id: brandId,
                      description: description,
                      discount: discount,
                      name: name,
                      product_category_id: categoryResult.id!,
                      variants_path: variants_path,
                      shopEmail: authRepo.firebaseUser.value!.email,
                    );
                    
                  },
                  child: const Text('Add product'),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
