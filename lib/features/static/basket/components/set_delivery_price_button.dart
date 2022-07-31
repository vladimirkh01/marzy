import 'package:flutter/material.dart';
import 'package:marzy/shared/images/images.dart';
import 'package:marzy/shared/presentation/colors.dart';
import 'package:marzy/shared/presentation/text_styles.dart';

import './basket_button_item.dart';
import './divide_item.dart';

class SetDeliveryPriceButton extends StatelessWidget {
  const SetDeliveryPriceButton({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BasketButtonItem(
      buttonLabel: 'Задать цену доставки',
      onPressed: () {
        showModalBottomSheet(
          isScrollControlled: true,
          context: context,
          backgroundColor: Colors.transparent,
          builder: (BuildContext bc) {
            return Wrap(
              children: <Widget>[
                Container(
                  padding: const EdgeInsets.all(20),
                  decoration: new BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Цена доставки',
                        style: AppTextStyles.interMed14
                            .copyWith(color: AppColors.black),
                      ),
                      DivideItem(),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            'Рекомендуемая цена',
                            style: AppTextStyles.interMed14
                                .copyWith(color: AppColors.black),
                          ),
                          SizedBox(width: 10),
                          CustomImage(image: 'assets/images/question_mark.svg'),
                          Spacer(),
                          Text(
                            '250 ₽',
                            style: AppTextStyles.interMed14
                                .copyWith(color: AppColors.accent),
                          ),
                        ],
                      ),
                      SizedBox(height: 16),
                      BasketButtonItem(
                        buttonLabel: 'Использовать цену',
                        onPressed: () {},
                      ),
                      DivideItem(firstHeight: 9),
                      Row(
                        children: [
                          Text(
                            'Рекомендуемая цена',
                            style: AppTextStyles.interMed14
                                .copyWith(color: AppColors.black),
                          ),
                          SizedBox(width: 10),
                          CustomImage(
                            image: 'assets/images/question_mark.svg',
                          ),
                        ],
                      ),
                      SizedBox(height: 10),
                      TextFormField(),
                      SizedBox(height: 10),
                      BasketButtonItem(
                        buttonLabel: 'Использовать цену',
                        onPressed: () {},
                      ),
                      SizedBox(height: 30),
                      BasketButtonItem(
                        buttonLabel: 'Добавить цену заказа',
                        onPressed: () {},
                        textColor: AppColors.white,
                        backgroundColor: AppColors.accent,
                      ),
                    ],
                  ),
                )
              ],
            );
          },
        );
      },
    );
  }
}
