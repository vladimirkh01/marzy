import 'package:flutter/material.dart';
import 'package:marzy/shared/presentation/colors.dart';
import 'package:marzy/shared/presentation/text_styles.dart';

class CounterWidget extends StatelessWidget {
  final String title;
  final double width;
  final double height;
  const CounterWidget({
    Key? key,
    required this.title,
    this.width = 28,
    this.height = 28,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      alignment: Alignment.center,
      padding: EdgeInsets.only(right: 16),
      child: Container(
        height: height,
        width: width,
        alignment: Alignment.center,
        decoration: BoxDecoration(
          color: AppColors.fonGrey,
          shape: BoxShape.circle,
        ),
        child: FittedBox(
          child: Text(
            title,
            style: AppTextStyles.interSemiBold10,
          ),
        ),
      ),
    );
  }
}
