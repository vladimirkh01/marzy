import 'package:flutter/material.dart';
import 'package:marzy/shared/presentation/colors.dart';

class DivideItem extends StatelessWidget {
  final double firstHeight;
  final double secondheight;
  const DivideItem({
    Key? key,
    this.firstHeight = 10,
    this.secondheight = 10,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        SizedBox(height: firstHeight - 4),
        Divider(
          color: AppColors.fonGrey,
          thickness: 0.6,
        ),
        SizedBox(height: secondheight - 4),
      ],
    );
  }
}
