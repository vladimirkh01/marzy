import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:marzy/shared/localization/strings_ru.dart';
import 'package:marzy/shared/presentation/button_styles.dart';
import 'package:marzy/shared/presentation/colors.dart';
import 'package:marzy/shared/presentation/text_styles.dart';

class CourierItem extends StatelessWidget {
  final bool isResponded;
  const CourierItem({
    Key? key,
    required this.isResponded,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(8),
        border: Border.all(
          width: 0.4,
          color: AppColors.fonGrey,
        ),
      ),
      child: Padding(
        padding: EdgeInsets.all(10.w),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                  height: 63.h,
                  width: 63.w,
                  decoration: BoxDecoration(
                    color: AppColors.fonGrey,
                    borderRadius: BorderRadius.circular(70),
                  ),
                ),
                Spacer(),
                Padding(
                  padding: EdgeInsets.only(top: 20.w),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      Text(
                        'Артем Проскурин',
                        style: AppTextStyles.interReg16,
                      ),
                      SizedBox(height: 6.h),
                      Text(
                        'Рейтинг 4.73',
                        style: AppTextStyles.interMed12
                            .copyWith(color: AppColors.blackGrey),
                      ),
                    ],
                  ),
                ),
                Spacer(flex: 4),
                IconButton(
                  onPressed: () {},
                  icon: Icon(Icons.more_horiz),
                  color: AppColors.blackGrey,
                )
              ],
            ),
            SizedBox(height: 5),
            Divider(
              color: AppColors.fonGrey,
              thickness: 0.6,
            ),
            SizedBox(height: 5),
            Row(
              children: [
                Text(
                  'Цена доставки',
                  style: AppTextStyles.interReg16
                      .copyWith(fontWeight: FontWeight.w500),
                ),
                SizedBox(width: 10),
                Text(
                  '233 ₽',
                  style: AppTextStyles.interReg16.copyWith(
                    fontWeight: FontWeight.w500,
                    color: AppColors.accent,
                  ),
                ),
              ],
            ),
            SizedBox(height: 14),
            if (isResponded)
              Container(
                margin: const EdgeInsets.only(top: 20),
                child: SizedBox(
                  child: Text(
                    AppStrings.alreadyResponded,
                    style: AppTextStyles.interReg16.copyWith(
                      fontSize: 14,
                      color: AppColors.accent,
                    ),
                    textAlign: TextAlign.center,
                  ),
                  width: double.infinity,
                ),
              )
            else
              ElevatedButton(
                onPressed: () {},
                child: Text(AppStrings.respondToOrder),
                style: ButtonStyles.button1.copyWith(
                  minimumSize:
                      MaterialStateProperty.all(Size(double.infinity, 50)),
                ),
              ),
          ],
        ),
      ),
    );
  }
}
