import 'package:flutter/material.dart';
import 'package:marzy/shared/images/images.dart';
import 'package:marzy/shared/presentation/colors.dart';

class CustomBack extends StatelessWidget {
  final double? width;
  final double? height;
  final VoidCallback? onTap;
  const CustomBack({
    Key? key,
    this.width,
    this.height,
    this.onTap,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return IconButton(
      onPressed: onTap,
      icon: Container(
        padding: EdgeInsets.all(8),
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          color: AppColors.fonGrey,
        ),
        child: CustomImage(
          image: AppImages.backButton,
          width: width! - 8,
          height: height! - 8,
        ),
      ),
    );
  }
}
