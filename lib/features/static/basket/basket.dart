import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:marzy/features/home/page/home.dart';
import 'package:marzy/features/static/basket/components/add_paymet_type_button.dart';
import 'package:marzy/features/static/catalogs/catalogs.dart';
import 'package:marzy/logic/config/location_data.dart';
import 'package:marzy/shared/images/images.dart';
import 'package:marzy/shared/models/scrolling_text.dart';
import 'package:marzy/shared/presentation/colors.dart';
import 'package:marzy/shared/presentation/text_styles.dart';
import 'package:marzy/shared/widgets/custom_buttons.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

import 'components/custom_navigation_button.dart';
import 'components/basket_item.dart';
import 'components/divide_item.dart';
import 'components/basket_button_item.dart';

class BasketScreen extends StatelessWidget {
  static const String route = '/basket';
  num? numBasket;
  List<BasketUser>? itemsList;
  BasketScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Корзина'),
        automaticallyImplyLeading: false,
        leading: Padding(
          padding: const EdgeInsets.only(left: 8.0),
          child: CustomBackButton(),
        ),
        actions: [
          Padding(
            padding: const EdgeInsets.only(right: 8.0),
            child: CustomNavigationButton(
              image: AppImages.threeDots,
              width: 42.w,
              height: 42.w,
            ),
          )
        ],
      ),
      body: BasketScreenAdditional(
        itemsList: itemsList,
        numBasket: numBasket
      )
    );
  }
}

class BasketScreenAdditional extends StatefulWidget {
  var itemsList;
  var numBasket;
  BasketScreenAdditional({Key? key, required this.itemsList, required this.numBasket}) : super(key: key);

  @override
  State<BasketScreenAdditional> createState() => _BasketScreenAdditionalState();
}

class _BasketScreenAdditionalState extends State<BasketScreenAdditional> {
  bool stateUpdateData = false;
  double sumOfAllProjectMain = 0.0;
  double basketSum = 0.0;
  double panelSum = 0.0;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(
        horizontal: 8,
        vertical: 10,
      ),
      child: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 5),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    'Продукты',
                    style: AppTextStyles.interMed14
                        .copyWith(color: AppColors.black),
                  ),
                  GestureDetector(
                    child: CustomImage(
                      image: AppImages.expandDown,
                    ),
                  )
                ],
              ),
            ),
            DivideItem(),
            FutureBuilder(
              future: postRequest(),
              builder: (BuildContext context, AsyncSnapshot<dynamic> snapshot) {
                if(snapshot.data == null) {
                  return Center(
                    child: Container(
                      margin: EdgeInsets.all(40),
                      height: 25,
                      width: 25,
                      child: CircularProgressIndicator(
                        color: AppColors.accent,
                        strokeWidth: 2,
                      ),
                    ),
                  );
                } else if(snapshot.data.length == 0) {
                  return Center(
                      child: Text(
                        "Корзина пуста",
                        style: TextStyle(
                            color: AppColors.accent
                        ),
                      )
                  );
                }
                else {
                  return Container(
                    child: ListView.builder(
                        physics: BouncingScrollPhysics(),
                        itemCount: snapshot.data.length,
                        shrinkWrap: true,
                        itemBuilder: (context, ind) {
                          return Column(
                            mainAxisSize: MainAxisSize.max,
                            children: [
                              Container(
                                height: 75.w,
                                width: MediaQuery.of(context).size.width,
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
                                          snapshot.data[ind].product.name,
                                          style: AppTextStyles.interMed12.copyWith(fontSize: 12),
                                        ),
                                        Row(
                                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                          children: [
                                            GestureDetector(
                                              onTap: () => changeBasketRemove(ind, snapshot.data[ind].product.id, snapshot.data[ind].count),
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
                                              snapshot.data[ind].count.toString(),
                                              style: AppTextStyles.interMed14
                                                  .copyWith(color: AppColors.black),
                                            ),
                                            SizedBox(width: 26),
                                            GestureDetector(
                                              onTap: () => changeBasketAdd(ind, snapshot.data[ind].product.id, snapshot.data[ind].count),
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
                                              (snapshot.data[ind].product.cost * snapshot.data[ind].count).toStringAsFixed(2) + ' ₽',
                                              style: AppTextStyles.interMed14
                                                  .copyWith(color: AppColors.accent),
                                            ),
                                          ),
                                        ]
                                    ),
                                  ],
                                ),
                              ),
                              Container(
                                height: 15
                              )
                            ],
                          );
                        }),
                  );
                }
              },
            ),
            DivideItem(secondheight: 14),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  'Стоимость корзины',
                  style: AppTextStyles.interMed14
                      .copyWith(
                      fontSize: 15,
                      color: AppColors.black,
                      fontWeight: FontWeight.w900
                  ),
                ),
                Text(
                  '${basketSum == 0.0 ? "0 ₽" : basketSum.toStringAsFixed(2) + ' ₽'}',
                  style: AppTextStyles.interMed14
                      .copyWith(
                      fontSize: 15,
                      color: AppColors.accent,
                      fontWeight: FontWeight.w900
                  ),
                ),
              ],
            ),
            DivideItem(secondheight: 14),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  'Комиссия 2%',
                  style: AppTextStyles.interMed14
                      .copyWith(color: AppColors.black),
                ),
                Text(
                  '${panelSum == 0.0 ? "0 ₽" : panelSum.toStringAsFixed(2) + ' ₽'}',
                  style: AppTextStyles.interMed14
                      .copyWith(color: AppColors.accent),
                ),
              ],
            ),
            DivideItem(secondheight: 14),
            FutureBuilder(
              future: LocationData().getLocationUser(),
              builder: (BuildContext context, AsyncSnapshot<dynamic> snapshot) {
                if(snapshot.hasData) {
                  return Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        'Место доставки',
                        style: AppTextStyles.interMed14
                            .copyWith(color: AppColors.black),
                      ),
                      Container(
                        width: 200,
                        height: 20,
                        child: ScrollingText(
                          textStyle: AppTextStyles.interMed14
                              .copyWith(color: AppColors.accent),
                          text: snapshot.data,
                        ),
                      ),
                    ],
                  );
                } else {
                  return CircularProgressIndicator();
                }
              },
            ),
            DivideItem(secondheight: 4),
            // SetDeliveryPriceButton(),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  'Цена доставки',
                  style: AppTextStyles.interMed14
                      .copyWith(color: AppColors.black),
                ),
                Container(
                  padding: const EdgeInsets.all(8),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(4),
                    // color: Color.fromRGBO(51, 189, 138, 0.1),
                    color: AppColors.accent.withAlpha(10),
                  ),
                  child: Text(
                    '233 ₽',
                    style: AppTextStyles.interMed14
                        .copyWith(color: AppColors.accent),
                  ),
                ),
              ],
            ),
            // SizedBox(height: 10.h),
            // AddPaymentTypeButton(),
            DivideItem(firstHeight: 4),
            FutureBuilder(
              future: getPaymentData(),
              builder: (BuildContext context, AsyncSnapshot<dynamic> snapshot) {
                if(snapshot.data == null) {
                  return Container();
                } else if(snapshot.data == "empty") {
                  return Container(
                    width: MediaQuery.of(context).size.width,
                    height: 40,
                    child: AddPaymentTypeButton(),
                  );
                } else {
                  return Column(
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            'Способ оплаты заказа',
                            style: AppTextStyles.interMed14
                                .copyWith(color: AppColors.black),
                          ),
                          Row(
                            children: [
                              CustomImage(image: AppImages.payment),
                              SizedBox(width: 5),
                              Text(
                                '**** 1223',
                                style: AppTextStyles.interMed14
                                    .copyWith(color: AppColors.grey2),
                              )
                            ],
                          )
                        ],
                      ),
                      DivideItem(secondheight: 4),
                    ],
                  );
                }
              },
            ),
            // SizedBox(height: 10.h),
            // BasketButtonItem(
            //   buttonLabel: 'Добавить комментарий к заказу',
            //   onPressed: () {},
            // ),
            SizedBox(height: 100),
            SizedBox(height: 14.h),
            Row(
              children: [
                RichText(
                  textAlign: TextAlign.center,
                  text: TextSpan(
                    text: 'К оплате за заказ: ',
                    style: AppTextStyles.interReg16
                        .copyWith(fontWeight: FontWeight.w500),
                    children: [
                      TextSpan(
                        text: sumOfAllProjectMain == 0.0 ? "0 ₽" : sumOfAllProjectMain.toStringAsFixed(2) + ' ₽',
                        style: AppTextStyles.interReg16.copyWith(
                          fontWeight: FontWeight.w500,
                          color: AppColors.accent,
                        ),
                      ),
                    ],
                  ),
                ),
                SizedBox(width: 10),
                CustomImage(image: 'assets/images/question_mark.svg')
              ],
            ),
            SizedBox(height: 14),
            BasketButtonItem(
              buttonLabel: 'Создать заказ',
              onPressed: () async {

                final prefs = await SharedPreferences.getInstance();
                final String? action = prefs.getString('tokenSystem');
                final String? address = prefs.getString('locationUser');

                print(address);

                Map data = {
                  'address': address,
                };

                var response = await http.post(
                  Uri.parse("https://marzy.ru/api/order/create"),
                  body: json.encode(data),
                  headers: {
                    "Content-Type": "application/json",
                    "Auth": action!,
                  },
                );

                var result = utf8.decode(response.bodyBytes);
                final dataRes = await json.decode(result);
                print(result);

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
                              "${dataRes["message"]}",
                              style: AppTextStyles.interMed12.copyWith(fontSize: 15, color: AppColors.black)
                            ),
                            Container(
                              height: 10,
                            ),
                            BasketButtonItem(
                              buttonLabel: 'Завершить',
                              backgroundColor: AppColors.accent,
                              textColor: AppColors.white,
                              onPressed: () {
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
                                  },
                                );
                                Navigator.pushReplacement(
                                    context,
                                    MaterialPageRoute(
                                        builder: (context) => HomePage()));
                              }
                            )
                          ],
                        ),
                      );
                    });
              },
              textColor: AppColors.white,
              backgroundColor: AppColors.accent,
            ),
            SizedBox(height: 20),
          ],
        ),
      ),
    );
  }

  double getValueSum() {
    var sumOfAllBasket = 0.0;
    for(var i = 0; i < widget.itemsList![0].basket!.products!.length; i++) {
      sumOfAllBasket += (widget.itemsList![0].basket!.products![i].count * widget.itemsList![0].basket!.products![i].product.cost);
    }
    return sumOfAllBasket + (sumOfAllBasket / 100 * 2) + 233;
  }

  double getValueBasket() {
    var sumOfAllBasket = 0.0;
    for(var i = 0; i < widget.itemsList![0].basket!.products!.length; i++) {
      sumOfAllBasket += (widget.itemsList![0].basket!.products![i].count * widget.itemsList![0].basket!.products![i].product.cost);
    }
    return sumOfAllBasket;
  }

  double getValuePanel() {
    var sumOfAllBasket = 0.0;
    for(var i = 0; i < widget.itemsList![0].basket!.products!.length; i++) {
      sumOfAllBasket += (widget.itemsList![0].basket!.products![i].count * widget.itemsList![0].basket!.products![i].product.cost);
    }
    return sumOfAllBasket / 100 * 2;
  }

  Future<String?> getPaymentData() async {
    SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
    final String? action = sharedPreferences.getString('paymentSystem');

    if(action == null) return "empty";
    return action;
  }

  Future<void> changeBasketAdd(int idProduct, int idProd, int countProduct) async {
    SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
    final String? action = sharedPreferences.getString('tokenSystem');

    setState(() {
      countProduct++;
      var i = widget.itemsList![0].basket!.products![idProduct].count!;
      i++;
      widget.itemsList![0].basket!.products![idProduct].count = i;
      sumOfAllProjectMain = getValueSum();
      panelSum = getValuePanel();
      basketSum = getValueBasket();
      print(panelSum);
    });

    print("basketValue: " + countProduct.toString());
    print("https://marzy.ru/api/basket/append?product_id=$idProd&count=$countProduct");

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
      setState(() {
        countProduct--;
        int i = widget.itemsList![0].basket!.products![idProduct].count!;
        if(i != 0) {
          i--;
          widget.itemsList![0].basket!.products![idProduct].count = i;
          sumOfAllProjectMain = getValueSum();
          panelSum = getValuePanel();
          basketSum = getValueBasket();
        }
      });


      await http.get(
        Uri.parse("https://marzy.ru/api/basket/remove?product_id=$idProd&count=$countProduct"),
        headers: {
          "Auth": action!,
        },
      );
    }
    else {
      print("Удаление элемента: " + idProduct.toString());
      setState(() => widget.itemsList![0].basket!.products.removeAt(idProduct));
    }
  }

  Future<List<ProductsAdditional>?> postRequest() async {
    if(!stateUpdateData) {
      SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
      final String? action = sharedPreferences.getString('tokenSystem');
      var response = await http.get(
        Uri.parse("https://marzy.ru/api/basket/get"),
        headers: {
          "Auth": action!,
        },
      );

      var result = utf8.decode(response.bodyBytes);
      result = "[" + result.substring(0, result.length) + "]";
      final data = await json.decode(result);
      print(data);
      stateUpdateData = true;

      try {
        widget.itemsList = List<BasketUser>.from(data.map((i) => BasketUser.fromJson(i)));
        setState(() => sumOfAllProjectMain = getValueSum());
        setState(() => panelSum = getValuePanel());
        setState(() => basketSum = getValueBasket());
        widget.numBasket = widget.itemsList![0].basket!.id!;
        return widget.itemsList![0].basket!.products;
      } catch (e) {
        print("Ошибка при получении товаров в корзине: $e");
        return [];
      }
    }
    else {
      try {
        print(widget.itemsList![0].basket.products);
      } catch (e) {
        print(e);
      }
      return widget.itemsList![0].basket.products;
    }
  }
}

