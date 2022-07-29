import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:marzy/shared/presentation/colors.dart';
import 'package:marzy/shared/presentation/text_styles.dart';

class BasketButtonItem extends StatelessWidget {
  final String buttonLabel;
  final VoidCallback onPressed;
  final Color textColor;
  final Color backgroundColor;
  const BasketButtonItem({
    Key? key,
    required this.buttonLabel,
    required this.onPressed,
    this.textColor = AppColors.black,
    this.backgroundColor = AppColors.fonGrey,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      onPressed: onPressed,
      style: ButtonStyle(
        elevation: MaterialStateProperty.all(0),
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
        backgroundColor: MaterialStateProperty.all(backgroundColor),
      ),
      child: Text(
        buttonLabel,
        style: AppTextStyles.interMed14.copyWith(color: textColor),
      ),
    );
  }
}
