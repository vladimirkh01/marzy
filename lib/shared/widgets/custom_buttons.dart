import 'package:flutter/material.dart';
import 'package:marzy/shared/images/images.dart';
import 'package:marzy/shared/localization/strings_ru.dart';
import 'package:marzy/shared/presentation/colors.dart';
import 'package:marzy/shared/presentation/text_styles.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class CustomButton extends StatelessWidget {
  final Function onTap;
  const CustomButton({
    Key? key,
    required this.onTap,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        onTap();
      },
      child: Container(
        height: 40,
        alignment: Alignment.center,
        child: Text(
          AppStrings.singUp,
          style: AppTextStyles.interMed14.copyWith(
            color: AppColors.accent,
          ),
        ),
        decoration: BoxDecoration(
          border: Border.all(
            width: 1,
            color: AppColors.accent,
          ),
          borderRadius: BorderRadius.all(
            Radius.circular(8.0),
          ),
        ),
      ),
    );
  }
}

class CustomBackButton extends StatelessWidget {
  final double? width;
  final double? height;
  const CustomBackButton({
    Key? key,
    this.width,
    this.height,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return IconButton(
      onPressed: () {
        Navigator.pop(context);
      },
      icon: Container(
        padding: EdgeInsets.all(7.w),
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          color: AppColors.fonGrey,
        ),
        child: CustomImage(
          image: AppImages.backButton,
          width: width,
          height: height,
        ),
      ),
    );
  }
}

class CustomBackButtonAuth extends StatelessWidget {
  final double? width;
  final double? height;
  final Function onTap;
  const CustomBackButtonAuth({
    Key? key,
    this.width,
    this.height,
    required this.onTap,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return IconButton(
      onPressed: () {
        onTap();
      },
      icon: Container(
        padding: EdgeInsets.all(7.w),
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          color: AppColors.fonGrey,
        ),
        child: CustomImage(
          image: AppImages.backButton,
          width: width,
          height: height,
        ),
      ),
    );
  }
}

class CustomTextButton extends StatelessWidget {
  final String text;
  final VoidCallback onPressed;
  const CustomTextButton({
    Key? key,
    this.text = AppStrings.forgotPassword,
    required this.onPressed,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onPressed,
      child: Container(
        padding: EdgeInsets.only(bottom: 4.h, top: 12),
        child: Text(
          text,
          style: AppTextStyles.interMed12.copyWith(
            color: AppColors.accent,
          ),
        ),
      ),
    );
  }
}
