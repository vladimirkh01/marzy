import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:marzy/shared/presentation/button_styles.dart';
import 'package:marzy/shared/presentation/colors.dart';
import 'package:marzy/shared/presentation/text_styles.dart';

class TemplateItem extends StatelessWidget {
  const TemplateItem({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        border: Border.all(color: AppColors.fonGrey),
        borderRadius: BorderRadius.circular(8),
      ),
      padding: EdgeInsets.only(
        top: 16.h,
        left: 16.w,
        right: 16.w,
        bottom: 14.h,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Ежедневный',
            style: AppTextStyles.interSemiBold10.copyWith(fontSize: 18),
          ),
          SizedBox(height: 8.h),
          Text(
            'Lorem ipsum dolor sit amet',
            style: AppTextStyles.interMed12
                .copyWith(fontWeight: FontWeight.normal),
          ),
          SizedBox(height: 8.h),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              TextButton(
                onPressed: () {},
                child: Text(
                  'Создать заказ',
                  style:
                      AppTextStyles.interMed14.copyWith(color: AppColors.black),
                ),
                style: ButtonStyles.button1.copyWith(
                  minimumSize: MaterialStateProperty.all(Size(160.w, 40.h)),
                  foregroundColor: MaterialStateProperty.all(AppColors.black),
                  backgroundColor: MaterialStateProperty.all(AppColors.fonGrey),
                ),
              ),
              Text(
                '5 000 ₽',
                style: AppTextStyles.interSemiBold20.copyWith(
                  fontSize: 16,
                  color: AppColors.accent,
                ),
              )
            ],
          ),
        ],
      ),
    );
  }
}
