import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:marzy/shared/images/images.dart';
import 'package:marzy/shared/presentation/colors.dart';

class ReviewItem extends StatelessWidget {
  const ReviewItem({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: AppColors.fonGrey),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              CustomImage(
                image: 'assets/images/star.svg',
                width: 16.w,
                height: 16.w,
                color: AppColors.accent,
              ),
              SizedBox(
                width: 6.w,
              ),
              CustomImage(
                image: 'assets/images/star.svg',
                width: 16.w,
                height: 16.w,
                color: AppColors.accent,
              ),
              SizedBox(
                width: 6.w,
              ),
              CustomImage(
                image: 'assets/images/star.svg',
                width: 16.w,
                height: 16.w,
                color: AppColors.accent,
              ),
              SizedBox(
                width: 6.w,
              ),
              CustomImage(
                image: 'assets/images/star.svg',
                width: 16.w,
                height: 16.w,
                color: AppColors.accent,
              ),
              SizedBox(
                width: 6.w,
              ),
              CustomImage(
                image: 'assets/images/star.svg',
                width: 16.w,
                height: 16.w,
              ),
            ],
          ),
          SizedBox(height: 10.h),
          Text(
              'Lorem ipsum dolor sit amet, consectetur adipiscing elit. Lorem ipsum dolor sit amet, consectetur adipiscing elit. Lorem ipsum dolor sit amet, consectetur adipiscing elit'),
        ],
      ),
    );
  }
}
