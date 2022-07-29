import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';
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
      // height: 180.h,
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
            SizedBox(height: 16),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                SvgPicture.asset(
                  'assets/images/star.svg',
                  color: AppColors.accent,
                  width: 50.w,
                  height: 50.w,
                ),
                SvgPicture.asset(
                  'assets/images/star.svg',
                  color: AppColors.accent,
                  width: 50.w,
                  height: 50.w,
                ),
                SvgPicture.asset(
                  'assets/images/star.svg',
                  color: AppColors.accent,
                  width: 50.w,
                  height: 50.w,
                ),
                SvgPicture.asset(
                  'assets/images/star.svg',
                  color: AppColors.accent,
                  width: 50.w,
                  height: 50.w,
                ),
                SvgPicture.asset(
                  'assets/images/star.svg',
                  width: 50.w,
                  height: 50.w,
                ),
              ],
            ),
            SizedBox(height: 16),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  'Комментарий',
                  style: AppTextStyles.interMed14.copyWith(
                    fontWeight: FontWeight.w500,
                    color: AppColors.black,
                  ),
                ),
                SizedBox(width: 10),
                Text(
                  'Lorem ipsum d...',
                  style: AppTextStyles.interMed12.copyWith(
                    fontWeight: FontWeight.w500,
                    color: AppColors.grey2,
                  ),
                ),
              ],
            ),
            SizedBox(height: 5),
            Divider(
              color: AppColors.fonGrey,
              thickness: 0.6,
            ),
            SizedBox(height: 14),
            ElevatedButton(
              onPressed: () {},
              child: Text(
                '+7 920 444 44 44',
                style:
                    AppTextStyles.interMed14.copyWith(color: AppColors.accent),
              ),
              style: ButtonStyles.button1.copyWith(
                minimumSize:
                    MaterialStateProperty.all(Size(double.infinity, 40)),
                backgroundColor: MaterialStateProperty.all(AppColors.white),
                shape: MaterialStateProperty.all(
                  RoundedRectangleBorder(
                    borderRadius: BorderRadius.all(
                      Radius.circular(8.0),
                    ),
                    side: BorderSide(
                      color: AppColors.accent,
                    ),
                  ),
                ),
                elevation: MaterialStateProperty.all(0),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
