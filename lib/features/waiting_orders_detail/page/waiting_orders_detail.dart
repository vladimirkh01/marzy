import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:marzy/features/static/basket/components/basket_button_item.dart';
import 'package:marzy/shared/images/images.dart';
import 'package:marzy/shared/models/scrolling_text.dart';
import 'package:marzy/shared/presentation/button_styles.dart';
import 'package:marzy/shared/presentation/colors.dart';
import 'package:marzy/shared/presentation/text_styles.dart';
import 'package:marzy/shared/localization/strings_ru.dart';
import 'package:marzy/shared/widgets/custom_buttons.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:yandex_mapkit/yandex_mapkit.dart';

import 'package:http/http.dart' as http;

// ignore: must_be_immutable
class WaitingOrdersDetailPage extends StatelessWidget {
  static const route = '/waiting_orders_detail';

  var id;
  var products;
  var priceCart;
  late YandexMapController controller;

  WaitingOrdersDetailPage({
    Key? key,
    required this.id,
    required this.products,
    required this.priceCart
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    Future.delayed(Duration(seconds: 2), () async {
      await controller.moveCamera(
          CameraUpdate.newCameraPosition(CameraPosition(target: Point(
              latitude: double.parse(products.address.geoLat),
              longitude: double.parse(products.address.geoLon)
          )))
      );

      await controller.moveCamera(CameraUpdate.zoomOut());
    });

    return Scaffold(
      appBar: AppBar(
        title: Text(AppStrings.singleOrder),
        automaticallyImplyLeading: false,
        leading: CustomBackButton(),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: 20.w, vertical: 20.h),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Продуктовый заказ: $id',
                style: AppTextStyles.interSemiBold20.copyWith(fontSize: 18),
              ),
              SizedBox(height: 10),
              RichText(
                textAlign: TextAlign.start,
                text: TextSpan(
                  text: 'Рейтинг заказа: ',
                  style: AppTextStyles.interMed12,
                  children: [
                    WidgetSpan(child: SizedBox(width: 10)),
                    TextSpan(
                      text: 'отрицательный',
                      style: AppTextStyles.interMed12.copyWith(
                        color: AppColors.error,
                      ),
                    ),
                  ],
                ),
              ),
              SizedBox(height: 10),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    'Продукты',
                    style: AppTextStyles.interMed14
                        .copyWith(color: AppColors.black),
                  ),
                  GestureDetector(
                    child: CustomImage(image: AppImages.expandDown),
                    onTap: () {},
                  )
                ],
              ),
              SizedBox(height: 10),
              Divider(
                color: AppColors.fonGrey,
                thickness: 0.5,
              ),
              SizedBox(height: 6),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    'Стоимость корзины',
                    style: AppTextStyles.interSemiBold20
                        .copyWith(fontSize: 16, fontWeight: FontWeight.bold),
                  ),
                  Text(
                    '${products.productsCost}₽',
                    style: AppTextStyles.interSemiBold20.copyWith(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                      color: AppColors.accent,
                    ),
                  ),
                ],
              ),
              Container(
                height: 10
              ),
              ListView.builder(
                itemCount: (products.products).length,
                shrinkWrap: true,
                physics: NeverScrollableScrollPhysics(),
                itemBuilder: (BuildContext context, int index) {
                  var costProduct = products.products[index].product.cost * products.products[index].count;
                  return Column(
                    children: [
                      Row(
                        children: [
                          Container(
                            width: 44.w,
                            height: 44.w,
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(4),
                            ),
                            child: products.products[index].product.photos.isNotEmpty ? Image.network(
                              "https://marzy.ru/api/files/get?uuid=${products.products[index].product.photos[0]}",
                              fit: BoxFit.contain,
                              loadingBuilder: (BuildContext context, Widget child,
                                  ImageChunkEvent? loadingProgress) {
                                if (loadingProgress == null) return child;
                                return Center(
                                  child: CircularProgressIndicator(
                                    strokeWidth: 2,
                                    color: AppColors.accent,
                                    value: loadingProgress.expectedTotalBytes != null
                                        ? loadingProgress.cumulativeBytesLoaded /
                                        loadingProgress.expectedTotalBytes!
                                        : null,
                                  ),
                                );
                              },
                            ) : Container(
                              color: AppColors.grey2,
                            )
                          ),
                          SizedBox(width: 10),
                          Text(
                            '${products.products[index].product.name}',
                            style: AppTextStyles.interMed12,
                          ),
                          SizedBox(width: 8),
                          Text(
                              '${products.products[index].count} шт.',
                              style: AppTextStyles.interMed12.copyWith(
                                  fontWeight: FontWeight.w900
                              )
                          ),
                          Spacer(),
                          Text(
                            '$costProduct₽',
                            style: AppTextStyles.interMed14.copyWith(color: AppColors.accent),
                          ),
                          SizedBox(width: 5),
                        ],
                      ),
                      Divider(
                        color: AppColors.fonGrey,
                        thickness: 0.5,
                      ),
                    ],
                  );
                },
              ),
              Container(
                height: 148.h,
                width: double.infinity,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(8),
                  border: Border.all(
                    color: AppColors.fonGrey,
                    width: 0.6,
                  ),
                  color: AppColors.fonGrey,
                ),
                child: YandexMap(
                  onMapCreated: (YandexMapController yandexMapController) async {
                    controller = yandexMapController;

                    final cameraPosition = await controller.getCameraPosition();
                    final minZoom = await controller.getMinZoom();
                    final maxZoom = await controller.getMaxZoom();

                    print('Camera position: $cameraPosition');
                    print('Min zoom: $minZoom, Max zoom: $maxZoom');
                  },
                ),
              ),
              SizedBox(height: 10),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    'Место доставки',
                    style: AppTextStyles.interMed14
                        .copyWith(color: AppColors.black),
                  ),
                  Container(
                    width: MediaQuery.of(context).size.width / 2 + 15,
                    height: 30,
                    child: ScrollingText(
                      text: "${products.address.result}",
                      textStyle: AppTextStyles.interMed14
                          .copyWith(color: AppColors.accent),
                    ),
                  )
                ],
              ),
              SizedBox(height: 4),
              Divider(
                color: AppColors.fonGrey,
                thickness: 0.6,
              ),
              SizedBox(height: 4),
              // CourierItem(
              //   isResponded: true,
              // ),
              SizedBox(height: 14),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    'Комиссия 5%',
                    style: AppTextStyles.interMed14
                        .copyWith(color: AppColors.black),
                  ),
                  Text(
                    '250 ₽',
                    style: AppTextStyles.interMed14
                        .copyWith(color: AppColors.accent),
                  )
                ],
              ),
              SizedBox(height: 7),
              Divider(
                color: AppColors.fonGrey,
                thickness: 0.6,
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    'Способ оплаты комиссии',
                    style: AppTextStyles.interMed14
                        .copyWith(color: AppColors.black),
                  ),
                  Row(
                    children: [
                      SvgPicture.asset('assets/icons/payment_icon.svg'),
                      SizedBox(width: 8),
                      Text(
                        '**** 1223',
                        style: AppTextStyles.interMed14
                            .copyWith(color: AppColors.accent),
                      ),
                    ],
                  )
                ],
              ),
              SizedBox(height: 7),
              Divider(
                color: AppColors.fonGrey,
                thickness: 0.6,
              ),
              SizedBox(height: 89),
              ElevatedButton(
                onPressed: () async {
                  SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
                  final String? action = sharedPreferences.getString('tokenSystem1');

                  var response = await http.post(
                    Uri.parse("https://marzy.ru/api/order/respond?order_id=$id"),
                    headers: {"Auth": action!},
                  );

                  var result = utf8.decode(response.bodyBytes);
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
                child: Text('Откликнуться'),
                style: ButtonStyles.button1.copyWith(
                  minimumSize: MaterialStateProperty.all(
                    Size(double.infinity, 40),
                  ),
                ),
              ),
              SizedBox(height: 10),
            ],
          ),
        ),
      ),
    );
  }
}
