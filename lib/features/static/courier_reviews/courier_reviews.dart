import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:marzy/shared/presentation/colors.dart';
import 'package:marzy/shared/presentation/text_styles.dart';
import 'package:marzy/shared/widgets/custom_buttons.dart';

import './components/review_item.dart';

class CourierReviewsScreen extends StatelessWidget {
  static const String route = '/courier_reviews';
  const CourierReviewsScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: CustomBackButton(),
        title: Text('Курьер'),
      ),
      body: Padding(
        padding: EdgeInsets.symmetric(
          horizontal: 20.w,
          vertical: 15.h,
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Container(
                  height: 63.w,
                  width: 63.w,
                  decoration: BoxDecoration(
                    color: AppColors.fonGrey,
                    borderRadius: BorderRadius.circular(70),
                  ),
                ),
                SizedBox(width: 12.w),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Артем Проскурин',
                      style: AppTextStyles.interMed14.copyWith(
                        fontSize: 16,
                        color: AppColors.black,
                      ),
                    ),
                    SizedBox(height: 6.h),
                    Text(
                      'Рейтинг 4.73',
                      style: AppTextStyles.interReg14.copyWith(
                        fontSize: 12,
                        color: AppColors.blackGrey,
                      ),
                    ),
                  ],
                )
              ],
            ),
            SizedBox(height: 20.h),
            Text(
              'Отзывы',
              style: AppTextStyles.interSemiBold10.copyWith(
                fontSize: 16,
                color: AppColors.black,
              ),
            ),
            SizedBox(height: 20.h),
            ReviewItem(),
            SizedBox(height: 10),
            ReviewItem(),
            SizedBox(height: 10),
            ReviewItem(),
          ],
        ),
      ),
    );
  }
}
