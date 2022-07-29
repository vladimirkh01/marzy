import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:marzy/features/static/basket/components/basket_button_item.dart';
import 'package:marzy/shared/images/images.dart';
import 'package:marzy/shared/presentation/button_styles.dart';
import 'package:marzy/shared/presentation/colors.dart';
import 'package:marzy/shared/presentation/text_styles.dart';
import 'package:marzy/shared/widgets/custom_buttons.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import '../../waiting_orders_detail/page/waiting_orders_detail.dart';


class NearestOrderItem extends StatefulWidget {
  var id;
  var rating;
  var price;
  var listProducts;

  NearestOrderItem({
    Key? key,
    required this.id,
    required this.rating,
    required this.price,
    required this.listProducts,
  }) : super(key: key);


  @override
  State<NearestOrderItem> createState() => _NearestOrderItemState(
    this.id,
    this.rating,
    this.price,
    this.listProducts
  );
}

class _NearestOrderItemState extends State<NearestOrderItem> {
  final String id;
  final String rating;
  final double price;
  final listProducts;
  var statusLoader = false;

  _NearestOrderItemState(this.id, this.rating, this.price, this.listProducts);

  @override
  Widget build(BuildContext context) {
    final Color color = rating == 'средний'
        ? AppColors.orange
        : rating == 'отрицательный'
        ? AppColors.error
        : AppColors.accent;
    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(8),
        border: Border.all(
          width: 0.7,
          color: AppColors.fonGrey,
        ),
      ),
      padding: const EdgeInsets.all(16),
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'Действующий заказ: $id',
                style:
                AppTextStyles.interMed14.copyWith(color: AppColors.black),
              ),
              CustomTextButton(
                  text: 'перейти',
                  onPressed: () {
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => WaitingOrdersDetailPage(
                              id: id,
                              priceCart: price,
                              products: listProducts,
                            )
                        )
                    );
                  }
              )
            ],
          ),
          SizedBox(height: 10.h),
          RichText(
            textAlign: TextAlign.start,
            text: TextSpan(
              text: 'Цена за доставку: ',
              style: AppTextStyles.interMed12,
              children: [
                WidgetSpan(child: SizedBox(width: 10)),
                TextSpan(
                  text: '${price.toString()} ₽',
                  style: AppTextStyles.interMed12.copyWith(
                    color: AppColors.accent,
                  ),
                ),
              ],
            ),
          ),
          SizedBox(height: 6.h),
          RichText(
            textAlign: TextAlign.start,
            text: TextSpan(
              text: 'Рейтинг заказа: ',
              style: AppTextStyles.interMed12,
              children: [
                WidgetSpan(child: SizedBox(width: 10)),
                TextSpan(
                  text: '$rating',
                  style: AppTextStyles.interMed12.copyWith(
                    color: color,
                  ),
                ),
              ],
            ),
          ),
          SizedBox(height: 10.h),
          ElevatedButton(
              onPressed: () async {
                setState(() => statusLoader = true);
                SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
                final String? action = sharedPreferences.getString('tokenSystem1');

                var response = await http.post(
                  Uri.parse("https://marzy.ru/api/order/respond?order_id=$id"),
                  headers: {"Auth": action!},
                );

                setState(() => statusLoader = false);
                var result = utf8.decode(response.bodyBytes);
                print(result);
                final data = await json.decode(result);
                showModalBottomSheet(
                    context: context,
                    builder: (BuildContext context) {
                      return Container(
                        margin: EdgeInsets.only(left: 20, right: 20),
                        height: 300,
                        color: Colors.white,
                        child: Column(
                          children: [
                            Container(
                              width: MediaQuery.of(context).size.width,
                              margin: EdgeInsets.only(top: 30),
                              child: Image.asset(AppImages.paid),
                            ),
                            Container(
                              height: 10,
                            ),
                            Text(
                                "${data["message"]}",
                                style: AppTextStyles.interMed12.copyWith(fontSize: 15, color: AppColors.black)
                            ),
                            Container(
                              height: 10,
                            ),
                            BasketButtonItem(
                                buttonLabel: 'Закрыть',
                                backgroundColor: AppColors.accent,
                                textColor: AppColors.white,
                                onPressed: () {
                                  Navigator.pop(context);
                                }
                            )
                          ],
                        ),
                      );
                    });
              },
              child: statusLoader == false ? Text('Откликнуться') : Container(
                width: 17,
                height: 17,
                child: CircularProgressIndicator(
                  strokeWidth: 2,
                  color: AppColors.white,
                ),
              ),
              style: ButtonStyles.button1.copyWith(
                minimumSize: MaterialStateProperty.all(
                  Size(double.infinity, 40),
                ),
              )
          ),
        ],
        crossAxisAlignment: CrossAxisAlignment.start,
      ),
    );
  }
}
