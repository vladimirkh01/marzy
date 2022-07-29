import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:marzy/shared/presentation/colors.dart';
import 'package:marzy/shared/presentation/text_styles.dart';

class BasketItem extends StatelessWidget {
  final int quantity;
  final String text;
  final double totalPrice;

  const BasketItem({
    Key? key,
    required this.quantity,
    required this.text,
    required this.totalPrice,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 70.h,
      width: double.infinity,
      child: Row(
        children: [
          Container(
            height: 70.w,
            width: 70.w,
            decoration: BoxDecoration(
              color: AppColors.fonGrey,
              borderRadius: BorderRadius.circular(4),
            ),
          ),
          Spacer(),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                text,
                style: AppTextStyles.interMed12.copyWith(fontSize: 12),
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Container(
                    padding: const EdgeInsets.all(10),
                    decoration: BoxDecoration(
                      color: AppColors.fonGrey,
                      borderRadius: BorderRadius.circular(43),
                    ),
                    child: Icon(
                      Icons.remove,
                      size: 20,
                      color: AppColors.blackGrey,
                    ),
                  ),
                  SizedBox(width: 26),
                  Text(
                    quantity.toString(),
                    style: AppTextStyles.interMed14
                        .copyWith(color: AppColors.black),
                  ),
                  SizedBox(width: 26),
                  Container(
                    padding: const EdgeInsets.all(10),
                    decoration: BoxDecoration(
                      color: AppColors.fonGrey,
                      borderRadius: BorderRadius.circular(43),
                    ),
                    child: Icon(
                      Icons.add,
                      size: 20,
                      color: AppColors.blackGrey,
                    ),
                  ),
                ],
              ),
            ],
          ),
          Spacer(flex: 3),
          Column(
            children: [
              Spacer(),
              Container(
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(4),
                  // color: Color.fromRGBO(51, 189, 138, 0.1),
                  color: AppColors.accent.withAlpha(10),
                ),
                child: Text(
                  '$totalPrice ₽',
                  style: AppTextStyles.interMed14
                      .copyWith(color: AppColors.accent),
                ),
              ),
            ],
          )
        ],
      ),
    );
  }
}
