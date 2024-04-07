import 'package:btl/utils/constants/image_paths.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../common/widgets/texts/section_heading.dart';
import '../../../utils/constants/enums.dart';
import '../../../utils/constants/sizes.dart';
import '../models/payment_method_model.dart';
import '../screens/checkout/widgets/payment_tile.dart';

class CheckoutController extends GetxController {
  static CheckoutController get instance => Get.find();

  final Rx<PaymentMethodModel> selectedPaymentMethod = PaymentMethodModel.empty().obs;


  @override
  void onInit() {
    selectedPaymentMethod.value = PaymentMethodModel(name: PaymentMethods.paypal.name, image: Images.paypal);
    super.onInit();
  }

  Future<dynamic> selectPaymentMethod(BuildContext context) {
    return showModalBottomSheet(
      context: context,
      builder: (_) => SingleChildScrollView(
        child: Container(
          padding: const EdgeInsets.all(Sizes.lg),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const TSectionHeading(title: 'Select Payment Method', showActionButton: false),
              const SizedBox(height: Sizes.spaceBtwSections),
              TPaymentTile(paymentMethod: PaymentMethodModel(name: PaymentMethods.paypal.name, image: Images.paypal)),
              const SizedBox(height: Sizes.spaceBtwItems/2),
              TPaymentTile(paymentMethod: PaymentMethodModel(name: 'Google Pay', image: Images.googlePay)),
              const SizedBox(height: Sizes.spaceBtwItems/2),
              TPaymentTile(paymentMethod: PaymentMethodModel(name: 'Apple Pay', image: Images.applePay)),
              const SizedBox(height: Sizes.spaceBtwItems/2),
              TPaymentTile(paymentMethod: PaymentMethodModel(name: 'VISA', image: Images.visa)),
              const SizedBox(height: Sizes.spaceBtwItems/2),
              TPaymentTile(paymentMethod: PaymentMethodModel(name: 'Master Card', image: Images.masterCard)),
              const SizedBox(height: Sizes.spaceBtwItems/2),
              TPaymentTile(paymentMethod: PaymentMethodModel(name: 'Paytm', image: Images.paytm)),
              const SizedBox(height: Sizes.spaceBtwItems/2),
              TPaymentTile(paymentMethod: PaymentMethodModel(name: 'Paystack', image: Images.paystack)),
              const SizedBox(height: Sizes.spaceBtwItems/2),
              TPaymentTile(paymentMethod: PaymentMethodModel(name: 'Credit Card', image: Images.creditCard)),
              const SizedBox(height: Sizes.spaceBtwItems/2),
              const SizedBox(height: Sizes.spaceBtwSections),
            ],
          ),
        ),
      ),
    );
  }



}
