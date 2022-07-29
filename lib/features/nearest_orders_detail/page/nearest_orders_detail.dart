import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:marzy/logic/config/location_data.dart';
import 'package:marzy/shared/widgets/custom_navigation_button.dart';
import 'package:marzy/features/nearest_orders_detail/controller/nearest_orders_detail_controller.dart';
import 'package:marzy/features/nearest_orders_detail/page/product_item.dart';
import 'package:marzy/shared/images/images.dart';
import 'package:marzy/shared/presentation/colors.dart';
import 'package:marzy/shared/presentation/text_styles.dart';
import 'package:marzy/shared/localization/strings_ru.dart';
import 'package:marzy/shared/widgets/custom_buttons.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'courier_item.dart';

class NearestOrdersDetailPage extends GetView<NearestOrdersDetailController> {
  static const route = '/nearest_orders_detail';
  NearestOrdersDetailPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(AppStrings.singleOrder),
        automaticallyImplyLeading: false,
        leading: CustomBackButton(),
        actions: [
          CustomNavigationButton(
            image: AppImages.threeDots,
            width: 42.w,
            height: 42.w,
          ),
          SizedBox(width: 10),
        ],
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: 20.w, vertical: 14.h),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Продуктовый заказ: U223321',
                style: AppTextStyles.interSemiBold20.copyWith(fontSize: 18),
              ),
              SizedBox(height: 10),
              RichText(
                textAlign: TextAlign.start,
                text: TextSpan(
                  text: 'Рейтинг заказа: ',
                  style: AppTextStyles.interMed12,
                  children: [
                    WidgetSpan(child: SizedBox(width: 10)),
                    TextSpan(
                      text: 'средний',
                      style: AppTextStyles.interMed12.copyWith(
                        color: AppColors.orange,
                      ),
                    ),
                  ],
                ),
              ),
              SizedBox(height: 10),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    'Продукты',
                    style: AppTextStyles.interMed14
                        .copyWith(color: AppColors.black),
                  ),
                  GestureDetector(
                    child: CustomImage(image: AppImages.expandDown),
                    onTap: () {},
                  )
                ],
              ),
              SizedBox(height: 10),
              Divider(
                color: AppColors.fonGrey,
                thickness: 0.5,
              ),
              ProductItem(),
              Divider(
                color: AppColors.fonGrey,
                thickness: 0.5,
              ),
              ProductItem(),
              Divider(
                color: AppColors.fonGrey,
                thickness: 0.5,
              ),
              SizedBox(height: 6),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    'Стоимость корзины',
                    style: AppTextStyles.interSemiBold20
                        .copyWith(fontSize: 16, fontWeight: FontWeight.bold),
                  ),
                  Text(
                    '5 000 ₽',
                    style: AppTextStyles.interSemiBold20.copyWith(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                      color: AppColors.accent,
                    ),
                  ),
                ],
              ),
              SizedBox(height: 10),
              Container(
                height: 68.h,
                width: double.infinity,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(8),
                  border: Border.all(
                    color: AppColors.fonGrey,
                    width: 0.6,
                  ),
                ),
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Комментарий',
                        style: AppTextStyles.interMed12
                            .copyWith(color: AppColors.accent),
                      ),
                      Text(
                        'Lorem ipsum dolor sit amet, consectetur\nadipiscing elit ut aliquam',
                        style: AppTextStyles.interMed14
                            .copyWith(color: AppColors.black),
                      ),
                    ],
                  ),
                ),
              ),
              SizedBox(height: 10),
              Container(
                height: 148.h,
                width: double.infinity,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(8),
                  border: Border.all(
                    color: AppColors.fonGrey,
                    width: 0.6,
                  ),
                  color: AppColors.fonGrey,
                ),
                child: Text('Map goes here'),
                alignment: Alignment.center,
              ),
              SizedBox(height: 10),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    'Место доставки',
                    style: AppTextStyles.interMed14
                        .copyWith(color: AppColors.black),
                  ),
                  FutureBuilder(
                    future: LocationData().getLocationUser(),
                    builder: (BuildContext context, AsyncSnapshot<dynamic> snapshot) {
                      if(snapshot.hasData) {
                        return Text(
                          LocationData().getLocationUser(),
                          style: AppTextStyles.interMed14
                              .copyWith(color: AppColors.accent),
                        );
                      }

                      return CircularProgressIndicator();
                    },
                  )
                ],
              ),
              SizedBox(height: 4),
              Divider(
                color: AppColors.fonGrey,
                thickness: 0.6,
              ),
              SizedBox(height: 4),
              CourierItem(
                isResponded: true,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
