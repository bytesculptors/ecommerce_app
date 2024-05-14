
import 'package:btl/utils/http/http_client.dart';
import 'package:get/get.dart';
import 'package:flutter/material.dart';
import 'package:iconsax/iconsax.dart';
import '../../../../../utils/constants/sizes.dart';
import '../../../../common/widgets/appbar/appbar.dart';
import '../../../../utils/validators/validation.dart';
import '../../controllers/address_controller.dart';

class AddNewAddressScreen extends StatefulWidget {
  AddNewAddressScreen({Key? key}) : super(key: key);

  @override
  _AddNewAddressScreenState createState() => _AddNewAddressScreenState();
}

class _AddNewAddressScreenState extends State<AddNewAddressScreen> {
  @override
  void initState() {
    super.initState();
    fetchProvinces(); // Fetch data when the widget is first initialized
  }

  @override
  void dispose() {
    super.dispose();
  }

  String? selectedProvince;
  String? selectedDistrict;
  String? selectedCommune;
  List<Map<String, dynamic>> listProvinces = [];
  List<Map<String, dynamic>> listDistricts = [];
  List<Map<String, dynamic>> listCommunes = [];

  void fetchProvinces() async {
    try {
      final List<dynamic> response = await THttpHelper.getProvincesVN();
      if (!mounted) return;
      setState(() {
        listProvinces = response.map((element) {
          final e = element as Map<String, dynamic>;
          return {
            'ProvinceID': e['ProvinceID'],
            'Province': e['ProvinceName'],
          };
        }).toList();
        listProvinces.sort((a, b) => a['Province'].compareTo(b['Province']));
      });
      print(listProvinces);
    } catch (error) {
      // Handle any errors that occur during fetching
      throw Exception('Error fetching: $error');
    }
  }

  void fetchDistricts() async {
    try {
      final List<dynamic> response =
          await THttpHelper.getDistricts(selectedProvince?.split(':')[0].trim());
      if (!mounted) return;

      setState(() {
        listDistricts = response.map((element) {
          final e = element as Map<String, dynamic>;
          return {
            'DistrictID': e['DistrictID'],
            'District': e['DistrictName'],
          };
        }).toList();
        listDistricts.sort((a, b) => a['District'].compareTo(b['District']));
      });
      print(listDistricts);
    } catch (error) {
      // Handle any errors that occur during fetching
      throw Exception('Error fetching: $error');
    }
  }

  void fetchCommunes() async {
    try {
      final List<dynamic> response =
          await THttpHelper.getCommunes(selectedDistrict?.split(':')[0].trim());
      if (!mounted) return;

      setState(() {
        listCommunes = response.map((element) {
          final e = element as Map<String, dynamic>;
          return {
            'CommuneID': e['WardCode'],
            'Commune': e['WardName'],
          };
        }).toList();
      });
      listCommunes.sort((a, b) => a['Commune'].compareTo(b['Commune']));
      print(listCommunes);
    } catch (error) {
      // Handle any errors that occur during fetching
      throw Exception('Error fetching: $error');
    }
  }

  @override
  Widget build(BuildContext context) {
    final controller = Get.put(AddressController());
    return Scaffold(
      appBar:
          const MyAppBar(showBackArrow: true, title: Text('Add new Address')),
      body: SingleChildScrollView(
        child: Container(
          padding: const EdgeInsets.all(Sizes.defaultSpace),
          child: Form(
            key: controller.addressFormKey,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                TextFormField(
                  controller: controller.name,
                  validator: (value) =>
                      Validator.validateEmptyText('Name', value),
                  decoration: const InputDecoration(
                      prefixIcon: Icon(Iconsax.user), labelText: 'Name'),
                ),
                const SizedBox(height: Sizes.spaceBtwInputFields),
                TextFormField(
                  controller: controller.phoneNumber,
                  validator: Validator.validatePhoneNumber,
                  decoration: const InputDecoration(
                      prefixIcon: Icon(Iconsax.mobile),
                      labelText: 'Phone Number'),
                ),
                const SizedBox(height: Sizes.spaceBtwInputFields),
                DropdownButtonFormField<String>(
                  value: selectedProvince,
                  items: listProvinces.map((Map<String, dynamic> items) {
                    return DropdownMenuItem(
                      value: '${items['ProvinceID']}: ${items['Province']}',
                      child: Text(items['Province']),
                    );
                  }).toList(),
                  onChanged: (String? newValue) {
                    selectedProvince = newValue!;
                    controller.provinceID =
                        selectedProvince!.split(':')[0].trim();
                    controller.province =
                        selectedProvince!.split(':')[1].trim();
                    selectedDistrict = null;
                    fetchDistricts();
                  },
                  decoration: const InputDecoration(
                      prefixIcon: Icon(Iconsax.location),
                      labelText: 'Province'),
                  validator: (value) =>
                      value == null ? 'Please select an option.' : null,
                ),
                const SizedBox(height: Sizes.spaceBtwInputFields),
                DropdownButtonFormField<String>(
                    value: selectedDistrict,
                    items: listDistricts.map((Map<String, dynamic> items) {
                      return DropdownMenuItem(
                        value: '${items['DistrictID']}: ${items['District']}',
                        child: Text(items['District']),
                      );
                    }).toList(),
                    onChanged: (String? newValue) {
                      selectedDistrict = newValue!;
                      controller.districtID =
                          selectedDistrict!.split(':')[0].trim();
                      controller.district =
                          selectedDistrict!.split(':')[1].trim();
                      selectedCommune = null;
                      fetchCommunes();
                    },
                    decoration: const InputDecoration(
                        prefixIcon: Icon(Iconsax.location),
                        labelText: 'District'),
                    validator: (value) =>
                        value == null ? 'Please select an option.' : null),
                const SizedBox(height: Sizes.spaceBtwInputFields),
                DropdownButtonFormField<String>(
                    key: UniqueKey(),
                    value: selectedCommune,
                    items: listCommunes.map((Map<String, dynamic> items) {
                      return DropdownMenuItem(
                        value: '${items['CommuneID']}: ${items['Commune']}',
                        child: Text(items['Commune']),
                      );
                    }).toList(),
                    onChanged: (String? newValue) {
                      selectedCommune = newValue!;
                      controller.communeID =
                          selectedCommune!.split(':')[0].trim();
                      controller.commune =
                          selectedCommune!.split(':')[1].trim();
                    },
                    decoration: const InputDecoration(
                        prefixIcon: Icon(Iconsax.location),
                        labelText: 'Commune'),
                    validator: (value) =>
                        value == null ? 'Please select an option.' : null),
                const SizedBox(height: Sizes.spaceBtwInputFields),
                TextFormField(
                  controller: controller.detailedAddress,
                  validator: (value) =>
                      Validator.validateEmptyText('Detailed Address', value),
                  decoration: const InputDecoration(
                      prefixIcon: Icon(Iconsax.building),
                      labelText: 'House Number, Building, Street'),
                ),
                const SizedBox(height: Sizes.spaceBtwInputFields),
                const SizedBox(height: Sizes.defaultSpace),
                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton(
                      onPressed: () => controller.addNewAddresses(),
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
