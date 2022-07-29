import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:marzy/shared/widgets/custom_navigation_button.dart';
import 'package:marzy/features/waiting_orders/controller/waiting_orders_controller.dart';
import 'package:marzy/features/waiting_orders/page/waiting_order_item.dart';
import 'package:marzy/shared/images/images.dart';
import 'package:marzy/shared/presentation/colors.dart';
import 'package:marzy/shared/presentation/text_styles.dart';
import 'package:marzy/shared/localization/strings_ru.dart';
import 'package:marzy/shared/widgets/custom_buttons.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class WaitingOrdersPage extends GetView<WaitingOrdersController> {
  static const route = '/waiting_orders';
  WaitingOrdersPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(AppStrings.orders),
        automaticallyImplyLeading: false,
        leading: CustomBackButton(),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: 20.w, vertical: 20.h),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              WaitingOrderItem(
                id: 'U223321',
                customer: 'Артем П.',
                customerPhoneNumber: '+7 920 444 44 44',
                price: 343,
              ),
              SizedBox(height: 20.h),
              WaitingOrderItem(
                id: 'U223321',
                customer: 'Артем П.',
                customerPhoneNumber: '+7 920 444 44 44',
                price: 343,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
