import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:marzy/features/waiting_orders/controller/waiting_orders_controller.dart';
import 'package:marzy/shared/presentation/button_styles.dart';
import 'package:marzy/shared/presentation/colors.dart';
import 'package:marzy/shared/presentation/text_styles.dart';
import 'package:marzy/shared/widgets/custom_buttons.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class WaitingOrderItem extends GetView<WaitingOrdersController> {
  final String id;
  final String customer;
  final String customerPhoneNumber;
  final double price;

  const WaitingOrderItem({
    Key? key,
    required this.id,
    required this.customer,
    required this.customerPhoneNumber,
    required this.price,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(8),
        border: Border.all(
          width: 0.7,
          color: AppColors.fonGrey,
        ),
      ),
      padding: const EdgeInsets.all(16),
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'Продуктовый заказ: $id',
                style:
                    AppTextStyles.interMed14.copyWith(color: AppColors.black),
              ),
              // CustomTextButton(
              //   text: 'перейти',
              //   onPressed: () {} /*controller.goToWaitingOrdersDetail*/
              // )
            ],
          ),
          SizedBox(height: 5.h),
          RichText(
            textAlign: TextAlign.start,
            text: TextSpan(
              text: 'Цена за доставку:',
              style: AppTextStyles.interMed12,
              children: [
                WidgetSpan(child: SizedBox(width: 5.w)),
                TextSpan(
                  text: '${price.toString()} ₽',
                  style: AppTextStyles.interMed12.copyWith(
                    color: AppColors.accent,
                  ),
                ),
              ],
            ),
          ),
          SizedBox(height: 10.h),
          Text(
            'Заказчик: $customer',
            style: AppTextStyles.interMed14.copyWith(color: AppColors.black),
          ),
          SizedBox(height: 10.h),
          ElevatedButton(
            onPressed: () {},
            child: Text(
              'Номер заказчика: $customerPhoneNumber',
              style: AppTextStyles.interMed14.copyWith(color: AppColors.grey2),
            ),
            style: ButtonStyles.button1.copyWith(
              minimumSize: MaterialStateProperty.all(
                Size(double.infinity, 40),
              ),
              backgroundColor: MaterialStateProperty.all(AppColors.fonGrey),
              shape: MaterialStateProperty.all(
                RoundedRectangleBorder(
                  borderRadius: BorderRadius.all(
                    Radius.circular(6.0),
                  ),
                ),
              ),
            ),
          ),
          SizedBox(height: 12.h),
          Container(
            width: 303.w,
            height: 123.h,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(8),
              color: AppColors.accent,
            ),
            alignment: Alignment.center,
            child: Text(
              'Map goes here',
              style: AppTextStyles.interMed14.copyWith(color: AppColors.black),
            ),
          )
        ],
        crossAxisAlignment: CrossAxisAlignment.start,
      ),
    );
  }
}
