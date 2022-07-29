import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:marzy/logic/config/location_data.dart';
import 'package:marzy/shared/images/images.dart';
import 'package:marzy/shared/presentation/colors.dart';
import 'package:marzy/shared/presentation/text_styles.dart';
import 'package:marzy/shared/widgets/custom_buttons.dart';

import './components/custom_navigation_button.dart';
import './components/divide_item.dart';
import './components/basket_item.dart';

class TemplateDetailScreen extends StatelessWidget {
  static const String route = '/template_detail';
  const TemplateDetailScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Ежедневный'),
        automaticallyImplyLeading: false,
        leading: Padding(
          padding: const EdgeInsets.only(left: 8.0),
          child: CustomBackButton(),
        ),
        actions: [
          Padding(
            padding: const EdgeInsets.only(right: 8.0),
            child: CustomNavigationButton(
              image: AppImages.threeDots,
              width: 42.w,
              height: 42.w,
            ),
          )
        ],
      ),
      body: LayoutBuilder(builder: (context, constraints) {
        return Padding(
          padding: const EdgeInsets.symmetric(
            horizontal: 8,
            vertical: 10,
          ),
          child: SingleChildScrollView(
            child: ConstrainedBox(
              constraints: BoxConstraints(
                  minWidth: constraints.maxWidth,
                  minHeight: constraints.maxHeight),
              child: IntrinsicHeight(
                child: Column(
                  mainAxisSize: MainAxisSize.max,
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 5),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            'Продукты',
                            style: AppTextStyles.interMed14
                                .copyWith(color: AppColors.black),
                          ),
                          GestureDetector(
                            child: CustomImage(
                              image: AppImages.expandDown,
                            ),
                          )
                        ],
                      ),
                    ),
                    DivideItem(),
                    BasketItem(
                      quantity: 2,
                      text:
                          'Lorem ipsum dolor sit amet,\nconsectetur adipiscing elit',
                      totalPrice: 233,
                    ),
                    DivideItem(),
                    BasketItem(
                      quantity: 2,
                      text:
                          'Lorem ipsum dolor sit amet,\nconsectetur adipiscing elit',
                      totalPrice: 233,
                    ),
                    DivideItem(),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          'Стоимость корзины',
                          style: AppTextStyles.interSemiBold20.copyWith(
                            fontSize: 16,
                            fontWeight: FontWeight.w700,
                          ),
                        ),
                        Text(
                          '5 000 ₽',
                          style: AppTextStyles.interSemiBold20.copyWith(
                            fontSize: 16,
                            fontWeight: FontWeight.w700,
                            color: AppColors.accent,
                          ),
                        ),
                      ],
                    ),
                    DivideItem(secondheight: 14),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          'Комиссия 2%',
                          style: AppTextStyles.interMed14
                              .copyWith(color: AppColors.black),
                        ),
                        Text(
                          '233 ₽',
                          style: AppTextStyles.interMed14
                              .copyWith(color: AppColors.accent),
                        ),
                      ],
                    ),
                    DivideItem(secondheight: 14),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          'Место доставки',
                          style: AppTextStyles.interMed14
                              .copyWith(color: AppColors.black),
                        ),
                        Text(
                          "null",
                          style: AppTextStyles.interMed14
                              .copyWith(color: AppColors.accent),
                        ),
                      ],
                    ),
                    DivideItem(secondheight: 4),
                    // SetDeliveryPriceButton(),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          'Цена доставки',
                          style: AppTextStyles.interMed14
                              .copyWith(color: AppColors.black),
                        ),
                        Container(
                          padding: const EdgeInsets.all(8),
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(4),
                            // color: Color.fromRGBO(51, 189, 138, 0.1),
                            color: AppColors.accent.withAlpha(10),
                          ),
                          child: Text(
                            '233 ₽',
                            style: AppTextStyles.interMed14
                                .copyWith(color: AppColors.accent),
                          ),
                        ),
                      ],
                    ),
                    // SizedBox(height: 10.h),
                    // AddPaymentTypeButton(),
                    DivideItem(firstHeight: 4),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          'Способ оплаты заказа',
                          style: AppTextStyles.interMed14
                              .copyWith(color: AppColors.black),
                        ),
                        Row(
                          children: [
                            CustomImage(image: AppImages.payment),
                            SizedBox(width: 5),
                            Text(
                              '**** 1223',
                              style: AppTextStyles.interMed14
                                  .copyWith(color: AppColors.grey2),
                            )
                          ],
                        )
                      ],
                    ),
                    // SizedBox(height: 10.h),
                    // BasketButtonItem(
                    //   buttonLabel: 'Добавить комментарий к заказу',
                    //   onPressed: () {},
                    // ),
                    DivideItem(),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          'Комментарий',
                          style: AppTextStyles.interMed14
                              .copyWith(color: AppColors.black),
                        ),
                        Text(
                          'Lorem ipsum d...',
                          style: AppTextStyles.interMed14
                              .copyWith(color: AppColors.black),
                        )
                      ],
                    ),
                    DivideItem(secondheight: 4),
                    // SizedBox(height: 200),
                    Expanded(
                      child: Container(),
                    ),
                    ElevatedButton(
                      onPressed: () {},
                      style: ButtonStyle(
                        minimumSize: MaterialStateProperty.all(
                          Size(double.infinity, 40.h),
                        ),
                        shape: MaterialStateProperty.all(
                          RoundedRectangleBorder(
                            borderRadius: BorderRadius.all(
                              Radius.circular(8.0),
                            ),
                          ),
                        ),
                      ),
                      child: Text(
                        'Создать заказ',
                        style: AppTextStyles.interMed14
                            .copyWith(color: AppColors.white),
                      ),
                    ),
                    SizedBox(height: 30),
                  ],
                ),
              ),
            ),
          ),
        );
      }),
    );
  }
}
