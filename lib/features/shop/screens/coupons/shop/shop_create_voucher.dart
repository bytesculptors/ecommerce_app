import 'package:ecommerce_app_mobile/common/widgets/appbar/appbar.dart';
import 'package:ecommerce_app_mobile/utils/constants/sizes.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:iconsax/iconsax.dart';
import 'package:intl/intl.dart';

class ShopCreateVoucher extends StatefulWidget {
  const ShopCreateVoucher({super.key});

  @override
  State<ShopCreateVoucher> createState() => _ShopCreateVoucherState();
}

class _ShopCreateVoucherState extends State<ShopCreateVoucher> {
  @override
  void dispose() {
    dateController.dispose();
    super.dispose();
  }

  final TextEditingController dateController = TextEditingController();
  double discount = 0.0;
  DateTime? selectedDate;

  Future<void> selectDate(BuildContext context) async {
    final DateTime? pickedDate = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime(2000),
      lastDate: DateTime(2101),
    );

    if (pickedDate != null && pickedDate != selectedDate) {
      setState(() {
        selectedDate = pickedDate;
        dateController.text = "${pickedDate.toLocal()}".split(' ')[0];
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const TAppBar(
        showBackArrow: true,
        title: Text("Create Voucher"),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(TSizes.defaultSpace),
        child: Column(
          children: [
            TextFormField(
              decoration: const InputDecoration(
                  labelText: 'Voucher name',
                  border: OutlineInputBorder(), // Customize border
                  prefixIcon: Icon(Iconsax.note_text)),
            ),
            const SizedBox(height: TSizes.spaceBtwInputFields),
            TextFormField(
              controller: dateController,
              onTap: () {
                // FocusScope.of(context).requestFocus(FocusNode());
                selectDate(context);
              },
              decoration: const InputDecoration(
                  labelText: 'Due date',
                  border: OutlineInputBorder(), // Customize border
                  prefixIcon: Icon(Iconsax.calendar)),
            ),
            const SizedBox(height: TSizes.spaceBtwInputFields),
            TextFormField(
              keyboardType: TextInputType.multiline,
              minLines: 3,
              maxLines: null,
              decoration: const InputDecoration(
                  labelText: 'Description',
                  border: OutlineInputBorder(),
                  prefixIcon: Icon(Iconsax.clipboard_text)),
            ),
            const SizedBox(
              height: 60,
            ),
            Slider(
              value: discount,
              onChanged: (newRating) {
                setState(() {
                  discount = newRating;
                });
              },
              min: 0,
              max: 100,
              divisions: 100,
              label: "${discount.toInt()}%",
            ),
            const SizedBox(
              height: 60,
            ),
            SizedBox(
              width: double.infinity,
              child:
                  ElevatedButton(onPressed: () => Get.back(), child: const Text('Save')),
            ),
          ],
        ),
      ),
    );
  }
}
