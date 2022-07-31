import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:marzy/shared/presentation/colors.dart';
import 'package:marzy/shared/presentation/text_styles.dart';

class ProductItem extends StatelessWidget {
  const ProductItem({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Container(
          width: 44.w,
          height: 44.w,
          decoration: BoxDecoration(
            color: AppColors.fon,
            borderRadius: BorderRadius.circular(4),
          ),
        ),
        SizedBox(width: 10),
        Text(
          'Lorem ipsum dolor sit amet,\nconsectetur adipiscing elit',
          style: AppTextStyles.interMed12,
        ),
        Spacer(),
        Text(
          '250 ₽',
          style: AppTextStyles.interMed14.copyWith(color: AppColors.accent),
        ),
        SizedBox(width: 5),
      ],
    );
  }
}
