import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:marzy/features/static/catalogs/catalogs.dart';
import 'package:marzy/shared/presentation/colors.dart';
import 'package:marzy/shared/presentation/text_styles.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;

class BasketItem extends StatelessWidget {
  final int quantity;
  final String text;
  final double totalPrice;
  final int index;
  final int numBasket;
  final int count;
  final List<BasketUser> itemsList;

  const BasketItem({
    Key? key,
    required this.quantity,
    required this.text,
    required this.totalPrice,
    required this.index,
    required this.numBasket,
    required this.count,
    required this.itemsList
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 78.h,
      width: double.infinity,
      child: BasketItemAdditional(
        totalPrice: totalPrice,
        index: index,
        numBasket: numBasket,
        text: text,
        count: count,
        quantity: quantity,
        itemsList: itemsList,
      ),
    );
  }
}

class BasketItemAdditional extends StatefulWidget {
  final int quantity;
  final String text;
  final double totalPrice;
  final int index;
  final int numBasket;
  final int count;
  final List<BasketUser> itemsList;

  const BasketItemAdditional({
    Key? key,
    required this.quantity,
    required this.text,
    required this.totalPrice,
    required this.index,
    required this.numBasket,
    required this.count,
    required this.itemsList
  }) : super(key: key);

  @override
  State<BasketItemAdditional> createState() => _BasketItemAdditionalState();
}

class _BasketItemAdditionalState extends State<BasketItemAdditional> {
  @override
  Widget build(BuildContext context) {
    return Row(
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
              widget.text,
              style: AppTextStyles.interMed12.copyWith(fontSize: 12),
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                GestureDetector(
                  onTap: () => changeBasketRemove(widget.index, widget.numBasket, widget.count),
                  child: Container(
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
                ),
                SizedBox(width: 26),
                Text(
                  widget.quantity.toString(),
                  style: AppTextStyles.interMed14
                      .copyWith(color: AppColors.black),
                ),
                SizedBox(width: 26),
                GestureDetector(
                  onTap: () => changeBasketAdd(widget.index, widget.numBasket, widget.count),
                  child: Container(
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
                widget.totalPrice.toString() + ' ₽',
                style: AppTextStyles.interMed14
                    .copyWith(color: AppColors.accent),
              ),
            ),
          ],
        )
      ],
    );
  }

  Future<void> changeBasketAdd(int idProduct, int idProd, int countProduct) async {
    SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
    final String? action = sharedPreferences.getString('tokenSystem');

    setState(() {
      print(idProduct);
      print(idProd);
      countProduct++;
      widget.itemsList[0].basket!.products![1].product!.name = "111";
      var i = widget.itemsList[0].basket!.products![0].count!;
      i++;
      widget.itemsList[0].basket!.products![0].count = i;
    });

    await http.get(
      Uri.parse("https://marzy.ru/api/basket/append?product_id=$idProd&count=$countProduct"),
      headers: {
        "Auth": action!,
      },
    );
  }

  Future<void> changeBasketRemove(int idProduct, int idProd, int countProduct) async {
    SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
    final String? action = sharedPreferences.getString('tokenSystem');
    if(countProduct != 0) {
      countProduct++;

      await http.get(
        Uri.parse("https://marzy.ru/api/basket/remove?product_id=$idProd&count=$countProduct"),
        headers: {
          "Auth": action!,
        },
      );
    }
  }
}

