import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:marzy/features/static/add_card/add_card.dart';
import 'package:marzy/shared/images/images.dart';
import 'package:marzy/shared/presentation/colors.dart';
import 'package:marzy/shared/presentation/text_styles.dart';
import 'package:shared_preferences/shared_preferences.dart';

import './basket_button_item.dart';
import './divide_item.dart';

class AddPaymentTypeButton extends StatelessWidget {
  const AddPaymentTypeButton({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BasketButtonItem(
      buttonLabel: 'Добавить способ оплаты',
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
                    borderRadius: BorderRadius.only(topLeft: Radius.circular(20), topRight: Radius.circular(20)),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Выбрать способ оплаты',
                        style: AppTextStyles.interMed14
                            .copyWith(color: AppColors.black),
                      ),
                      DivideItem(secondheight: 13),
                      FutureBuilder(
                        future: getFirstCard(),
                        builder: (BuildContext context, AsyncSnapshot<dynamic> snapshot) {
                          print("getFirstCard / ${snapshot.data}");
                          if(snapshot.data == null) {
                            return Container();
                          } else {
                            return Column(
                              children: [
                                SizedBox(height: 10),
                                Row(
                                  children: [
                                    CustomImage(
                                        width: 20,
                                        height: 20,
                                        image: '${snapshot.data[1]}'
                                    ),
                                    SizedBox(width: 10.w),
                                    Text(
                                      '**** ${snapshot.data[0]}',
                                      style: AppTextStyles.interMed14
                                          .copyWith(color: AppColors.grey2),
                                    ),
                                    Spacer(),
                                    Container(
                                      width: 20.w,
                                      height: 20.w,
                                      padding: EdgeInsets.all(3.w),
                                      decoration: BoxDecoration(
                                        border: Border.all(
                                          color: AppColors.grey2,
                                          width: 1,
                                        ),
                                        borderRadius: BorderRadius.circular(48),
                                      ),
                                      child: Container(
                                        decoration: BoxDecoration(
                                          borderRadius: BorderRadius.circular(48),
                                          color: AppColors.accent,
                                        ),
                                      ),
                                    ),
                                    DivideItem(secondheight: 13),
                                  ],
                                ),
                              ],
                            );
                          }
                        },
                      ),
                      FutureBuilder(
                        future: getSecondCard(),
                        builder: (BuildContext context, AsyncSnapshot<dynamic> snapshot) {
                          print("getSecondCard / ${snapshot.data}");
                          if(snapshot.data == null) {
                            return Container();
                          } else {
                            return Column(
                              children: [
                                SizedBox(height: 10),
                                Row(
                                  children: [
                                    CustomImage(
                                        width: 20,
                                        height: 20,
                                        image: '${snapshot.data[1]}'
                                    ),
                                    SizedBox(width: 10.w),
                                    Text(
                                      '**** ${snapshot.data[0]}',
                                      style: AppTextStyles.interMed14
                                          .copyWith(color: AppColors.grey2),
                                    ),
                                    Spacer(),
                                    Container(
                                      width: 20.w,
                                      height: 20.w,
                                      padding: EdgeInsets.all(3.w),
                                      decoration: BoxDecoration(
                                        border: Border.all(
                                          color: AppColors.grey2,
                                          width: 1,
                                        ),
                                        borderRadius: BorderRadius.circular(48),
                                      ),
                                      child: Container(
                                        decoration: BoxDecoration(
                                          borderRadius: BorderRadius.circular(48),
                                          color: AppColors.accent,
                                        ),
                                      ),
                                    ),
                                    DivideItem(secondheight: 13),
                                  ],
                                ),
                              ],
                            );
                          }
                        },
                      ),
                      FutureBuilder(
                        future: getThirdCard(),
                        builder: (BuildContext context, AsyncSnapshot<dynamic> snapshot) {
                          print("getThirdCard / ${snapshot.data}");
                          if(snapshot.data == null) {
                            return Container();
                          } else {
                            return Column(
                              children: [
                                SizedBox(height: 10),
                                Row(
                                  children: [
                                    CustomImage(
                                        image: '${snapshot.data[1]}',
                                        width: 20,
                                        height: 20,
                                    ),
                                    SizedBox(width: 10.w),
                                    Text(
                                      '**** ${snapshot.data[0]}',
                                      style: AppTextStyles.interMed14
                                          .copyWith(color: AppColors.grey2),
                                    ),
                                    Spacer(),
                                    Container(
                                      width: 20.w,
                                      height: 20.w,
                                      padding: EdgeInsets.all(3.w),
                                      decoration: BoxDecoration(
                                        border: Border.all(
                                          color: AppColors.grey2,
                                          width: 1,
                                        ),
                                        borderRadius: BorderRadius.circular(48),
                                      ),
                                      child: Container(
                                        decoration: BoxDecoration(
                                          borderRadius: BorderRadius.circular(48),
                                          color: AppColors.accent,
                                        ),
                                      ),
                                    ),
                                    DivideItem(secondheight: 13),
                                  ],
                                ),
                              ],
                            );
                          }
                        },
                      ),
                      // SizedBox(height: 12),
                      // Row(
                      //   children: [
                      //     CustomImage(image: 'assets/icons/apple_pay.svg'),
                      //     SizedBox(width: 10.w),
                      //     Text(
                      //       'Apple pay',
                      //       style: AppTextStyles.interMed14
                      //           .copyWith(color: AppColors.grey2),
                      //     ),
                      //     Spacer(),
                      //     Container(
                      //       width: 20.w,
                      //       height: 20.w,
                      //       decoration: BoxDecoration(
                      //         border: Border.all(
                      //           color: AppColors.grey2,
                      //           width: 1,
                      //         ),
                      //         borderRadius: BorderRadius.circular(48),
                      //       ),
                      //     )
                      //   ],
                      // ),
                      SizedBox(height: 18),
                      BasketButtonItem(
                        buttonLabel: 'Добавить карту',
                        onPressed: () {
                          Navigator.pop(context);
                          Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => AddCardScreen()));
                        },
                      ),
                      // SizedBox(height: 30),
                      // BasketButtonItem(
                      //   buttonLabel: 'Подтвердить',
                      //   onPressed: () {},
                      //   textColor: AppColors.white,
                      //   backgroundColor: AppColors.accent,
                      // ),
                      // SizedBox(height: 30),
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

  Future<List<String>> getFirstCard() async {
    SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
    var _imagePayment;
    if(sharedPreferences.getString("cardNumber1").toString()[0] == "") {
      _imagePayment = AppImages.paymentVisa;
    } else if(sharedPreferences.getString("cardNumber1").toString()[0]  == "4") {
      _imagePayment = AppImages.paymentVisa;
    } else if(sharedPreferences.getString("cardNumber1").toString()[0]  == "2") {
      _imagePayment = AppImages.paymentMIR;
    } else if(sharedPreferences.getString("cardNumber1").toString()[0]  == "5") {
      _imagePayment = AppImages.payment;
    }
    return [
      sharedPreferences.getString("cardNumber1")!.substring(
        sharedPreferences.getString("cardNumber1")!.length - 4
      ),
      _imagePayment
    ];
  }

  Future<List<String>> getSecondCard() async {
    SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
    var _imagePayment;
    if(sharedPreferences.getString("cardNumber2").toString()[0] == "") {
      _imagePayment = AppImages.paymentVisa;
    } else if(sharedPreferences.getString("cardNumber2").toString()[0]  == "4") {
      _imagePayment = AppImages.paymentVisa;
    } else if(sharedPreferences.getString("cardNumber2").toString()[0]  == "2") {
      _imagePayment = AppImages.paymentMIR;
    } else if(sharedPreferences.getString("cardNumber2").toString()[0]  == "5") {
      _imagePayment = AppImages.payment;
    }
    return [
      sharedPreferences.getString("cardNumber2")!.substring(
          sharedPreferences.getString("cardNumber2")!.length - 4
      ),
      _imagePayment
    ];
  }

  Future<List<String>> getThirdCard() async {
    SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
    var _imagePayment;
    if(sharedPreferences.getString("cardNumber3").toString()[0] == "") {
      _imagePayment = AppImages.paymentVisa;
    } else if(sharedPreferences.getString("cardNumber3").toString()[0]  == "4") {
      _imagePayment = AppImages.paymentVisa;
    } else if(sharedPreferences.getString("cardNumber3").toString()[0]  == "2") {
      _imagePayment = AppImages.paymentMIR;
    } else if(sharedPreferences.getString("cardNumber3").toString()[0]  == "5") {
      _imagePayment = AppImages.payment;
    }
    return [
      sharedPreferences.getString("cardNumber3")!.substring(
          sharedPreferences.getString("cardNumber3")!.length - 4
      ),
      _imagePayment
    ];
  }
}
