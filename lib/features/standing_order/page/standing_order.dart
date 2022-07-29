import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:marzy/features/home/page/home.dart';
import 'package:marzy/shared/presentation/button_styles.dart';
import 'package:marzy/shared/widgets/custom_navigation_button.dart';
import 'package:marzy/features/standing_order/page/courier_item.dart';
import 'package:marzy/shared/images/images.dart';
import 'package:marzy/shared/presentation/colors.dart';
import 'package:marzy/shared/presentation/text_styles.dart';
import 'package:marzy/shared/localization/strings_ru.dart';
import 'package:marzy/shared/widgets/custom_buttons.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'package:http/http.dart' as http;
import 'package:url_launcher/url_launcher_string.dart';

import '../../static/basket/components/basket_button_item.dart';


class StandingOrderPage extends StatefulWidget {
  static const route = '/standing_order';
  final String idOrder;
  final String costCart;
  final List allCouriers;

  StandingOrderPage({
    Key? key,
    required this.idOrder,
    required this.costCart,
    required this.allCouriers
  }) : super(
      key: key
  );

  @override
  State<StandingOrderPage> createState() => _StandingOrderPageState(
      costCart: this.costCart,
      idOrder: this.idOrder,
      allCouriers: this.allCouriers
  );
}

class _StandingOrderPageState extends State<StandingOrderPage> {
  final String idOrder;
  final String costCart;
  final List allCouriers;
  var star1 = AppColors.grey2;
  var star2 = AppColors.grey2;
  var star3 = AppColors.grey2;
  var star4 = AppColors.grey2;
  var star5 = AppColors.grey2;
  var visibilityReview = false;
  var stringFromInput;
  var deliveryIdNow;
  num starValue = 0;

  _StandingOrderPageState({
    required this.idOrder,
    required this.costCart,
    required this.allCouriers
  }) : super();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(AppStrings.standingOrder),
        automaticallyImplyLeading: false,
        leading: CustomBackButton(),
        actions: [
          CustomNavigationButton(
            image: AppImages.threeDots,
            width: 42.w,
            height: 42.w,
          )
        ],
      ),
      body: Stack(
        children: [
          SingleChildScrollView(
            child: Padding(
              padding: EdgeInsets.symmetric(horizontal: 20.w, vertical: 20.h),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Container(
                    height: 73.h,
                    width: double.infinity,
                    decoration: BoxDecoration(
                      color: AppColors.fon,
                      borderRadius: BorderRadius.circular(8),
                    ),
                    padding: const EdgeInsets.all(16),
                    child: Column(
                      children: [
                        Text(
                          'Номер заказа: $idOrder',
                          style: AppTextStyles.interMed14.copyWith(
                            color: AppColors.black,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                        Spacer(),
                        RichText(
                          textAlign: TextAlign.start,
                          text: TextSpan(
                            text: 'Сумма заказа:',
                            style: AppTextStyles.interMed12,
                            children: [
                              WidgetSpan(child: SizedBox(width: 10)),
                              TextSpan(
                                text: '$costCart₽',
                                style: AppTextStyles.interMed14.copyWith(
                                  color: AppColors.accent,
                                ),
                              ),
                            ],
                          ),
                        ),
                        Spacer(),
                      ],
                      crossAxisAlignment: CrossAxisAlignment.start,
                    ),
                  ),
                  SizedBox(height: 18.h),
                  Text(
                    'Курьер',
                    style: AppTextStyles.interReg16
                        .copyWith(fontWeight: FontWeight.w600),
                  ),
                  SizedBox(height: 18.h),
                  FutureBuilder(
                      future: getDataFromCurrentDelivery(int.parse(idOrder)),
                      builder: (BuildContext context, AsyncSnapshot<dynamic> snapshot) {
                        if(snapshot.data == null) {
                          return Center(
                            child: Container(
                              width: 50,
                              height: 50,
                              margin: EdgeInsets.only(top: 30),
                              child: CircularProgressIndicator(
                                color: AppColors.accent,
                                strokeWidth: 2,
                              ),
                            ),
                          );
                        } if(snapshot.data[0] == "В пути к магазину") {
                          deliveryIdNow = snapshot.data[1].id;
                          return Stack(
                            children: [
                              Column(
                                children: [
                                  Container(
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
                                              'Действующий заказ: ${snapshot.data[1].id}',
                                              style: AppTextStyles.interMed14
                                                  .copyWith(color: AppColors.black),
                                            ),
                                          ],
                                        ),
                                        SizedBox(height: 5.h),
                                        Text(
                                          snapshot.data[1].member.name != '' ?
                                          'Доставляет заказ: ${snapshot.data[1].member.name} ${snapshot.data[1].member.surname}' :
                                          'Доставляет заказ: имя неизвестно',
                                          style: AppTextStyles.interMed12,
                                        ),
                                        SizedBox(height: 10.h),
                                        ElevatedButton(
                                          onPressed: () {
                                            launchUrlString("tel:+7${snapshot.data[1].member.phone}");
                                          },
                                          child: Text('+7${snapshot.data[1].member.phone}'),
                                          style: ButtonStyles.button1.copyWith(
                                            minimumSize:
                                            MaterialStateProperty.all(Size(double.infinity, 40)),
                                          ),
                                        ),
                                        Container(
                                          margin: EdgeInsets.only(top: 10),
                                          child: Row(
                                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                            mainAxisSize: MainAxisSize.max,
                                            children: [
                                              GestureDetector(
                                                onTap: () => changeStar("star1"),
                                                child: CustomImage(
                                                  width: MediaQuery.of(context).size.width / 5 - 23,
                                                  height: MediaQuery.of(context).size.width / 5 - 23,
                                                  image: 'assets/icons/disactive_star.svg',
                                                  color: star1,
                                                ),
                                              ),
                                              GestureDetector(
                                                onTap: () => changeStar("star2"),
                                                child: CustomImage(
                                                  width: MediaQuery.of(context).size.width / 5 - 23,
                                                  height: MediaQuery.of(context).size.width / 5 - 23,
                                                  image: 'assets/icons/disactive_star.svg',
                                                  color: star2,
                                                ),
                                              ),
                                              GestureDetector(
                                                onTap: () => changeStar("star3"),
                                                child: CustomImage(
                                                  width: MediaQuery.of(context).size.width / 5 - 23,
                                                  height: MediaQuery.of(context).size.width / 5 - 23,
                                                  image: 'assets/icons/disactive_star.svg',
                                                  color: star3,
                                                ),
                                              ),
                                              GestureDetector(
                                                onTap: () => changeStar("star4"),
                                                child: CustomImage(
                                                  width: MediaQuery.of(context).size.width / 5 - 23,
                                                  height: MediaQuery.of(context).size.width / 5 - 23,
                                                  image: 'assets/icons/disactive_star.svg',
                                                  color: star4,
                                                ),
                                              ),
                                              GestureDetector(
                                                onTap: () => changeStar("star5"),
                                                child: CustomImage(
                                                  width: MediaQuery.of(context).size.width / 5 - 23,
                                                  height: MediaQuery.of(context).size.width / 5 - 23,
                                                  image: 'assets/icons/disactive_star.svg',
                                                  color: star5,
                                                ),
                                              )
                                            ],
                                          ),
                                        ),
                                        SizedBox(height: 10.h),
                                        Visibility(
                                          visible: !visibilityReview,
                                          child: BasketButtonItem(
                                            buttonLabel: 'Оставить отзыв о курьере',
                                            onPressed: () {
                                              setState(() => visibilityReview = true);
                                            },
                                          ),
                                        ),
                                        SizedBox(height: 10.h),
                                        Visibility(
                                          visible: visibilityReview,
                                          child: Row(
                                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                            children: [
                                              Text(
                                                'Комментарий',
                                                style: AppTextStyles.interMed14
                                                    .copyWith(color: AppColors.black),
                                              ),
                                              Container(
                                                width: MediaQuery.of(context).size.width / 2,
                                                height: 45,
                                                child: TextField(
                                                  onChanged: (text) {
                                                    stringFromInput = text;
                                                  },
                                                  decoration: InputDecoration(
                                                    enabledBorder: UnderlineInputBorder(
                                                      borderSide: BorderSide(color: Colors.grey),
                                                    ),
                                                    focusedBorder: UnderlineInputBorder(
                                                      borderSide: BorderSide(color: Colors.grey),
                                                    ),
                                                  ),
                                                ),
                                              ),
                                            ],
                                          ),
                                        ),
                                      ],
                                      crossAxisAlignment: CrossAxisAlignment.start,
                                    ),
                                  ),
                                  Align(
                                    alignment: Alignment.bottomCenter,
                                    child: Container(
                                      margin: EdgeInsets.only(top: MediaQuery.of(context).size.height / 3 - 40),
                                      width: MediaQuery.of(context).size.width,
                                      height: 40,
                                      child: BasketButtonItem(
                                          buttonLabel: 'Подтвердить доставку',
                                          backgroundColor: AppColors.accent,
                                          textColor: AppColors.white,
                                          onPressed: () async {
                                            SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
                                            final String? action = sharedPreferences.getString('tokenSystem');

                                            Map dataFromUser = {
                                              "order_id": deliveryIdNow.toString(),
                                              "rating": starValue.toString(),
                                              "comment": stringFromInput.toString()
                                            };

                                            var res = json.encode(dataFromUser);

                                            var response = await http.post(
                                              Uri.parse("https://marzy.ru/api/order/success?order_id=$deliveryIdNow&rating=$starValue&comment=$stringFromInput"),
                                              headers: {"Auth": action!},
                                              // body: res
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
                                                }).whenComplete(() => {
                                              Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => HomePage()))
                                            });
                                          }
                                      ),
                                    ),
                                  )
                                ],
                              ),
                            ],
                          );
                        } if(snapshot.data[0] == "Готов") {
                          return Container(
                            child: Center(
                              child: Text(
                                "Ваш заказ был успешно завершён!",
                                style: AppTextStyles.interMed14.copyWith(
                                  color: AppColors.black,
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                            ),
                          );
                        }
                        else if(snapshot.data[0] == 0) {
                          return Center(
                            child: Container(
                              margin: EdgeInsets.only(top: 40),
                              child: Text(
                                  "Никто пока не откликнулся на заказ"
                              ),
                            ),
                          );
                        } else {
                          return ListView.separated(
                            itemCount: snapshot.data[1].responses.length,
                            shrinkWrap: true,
                            itemBuilder: (BuildContext context, int index) {
                              return CourierItem(
                                // snapshot.data[index].name
                                nameCourier: snapshot.data[1].responses[index].name != "" ?
                                "${snapshot.data[1].responses[index].name} ${snapshot.data[1].responses[index].surname}" :
                                "Неизвестное имя",
                                rateValue: "${snapshot.data[1].responses[index].rating}",
                                idCourier: "${snapshot.data[1].responses[index].id}",
                                idOrder: "${snapshot.data[1].id}",
                              );
                            },
                            separatorBuilder: (BuildContext context, int index) {
                              return SizedBox(
                                height: 10.h,
                              );
                            },
                          );
                        }
                      }
                  )
                  // ListView.separated(
                  //   separatorBuilder: (ctx, ind) {
                  //     return SizedBox(
                  //       height: 10.h,
                  //     );
                  //   },
                  //   physics: NeverScrollableScrollPhysics(),
                  //   shrinkWrap: true,
                  //   itemBuilder: (ctx, ind) => CourierItem(),
                  //   itemCount: 3,
                  // )
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  void changeStar(idStar) {
    setState(() {
      switch (idStar) {
        case "star1":
          starValue = 1;
          star1 = AppColors.accent;
          star2 = AppColors.grey2;
          star3 = AppColors.grey2;
          star4 = AppColors.grey2;
          star5 = AppColors.grey2;
          break;
        case "star2":
          starValue = 2;
          star1 = AppColors.accent;
          star2 = AppColors.accent;
          star3 = AppColors.grey2;
          star4 = AppColors.grey2;
          star5 = AppColors.grey2;
          break;
        case "star3":
          starValue = 3;
          star1 = AppColors.accent;
          star2 = AppColors.accent;
          star3 = AppColors.accent;
          star4 = AppColors.grey2;
          star5 = AppColors.grey2;
          break;
        case "star4":
          starValue = 4;
          star1 = AppColors.accent;
          star2 = AppColors.accent;
          star3 = AppColors.accent;
          star4 = AppColors.accent;
          star5 = AppColors.grey2;
          break;
        case "star5":
          starValue = 5;
          star1 = AppColors.accent;
          star2 = AppColors.accent;
          star3 = AppColors.accent;
          star4 = AppColors.accent;
          star5 = AppColors.accent;
          break;
      }
    });

    print("star1 $star1");
    print("star2 $star2");
    print("star3 $star3");
    print("star4 $star4");
    print("star5 $star5");
  }

  Future<Object?> getDataFromCurrentDelivery(int deliveryInt) async {
    SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
    final String? action = sharedPreferences.getString('tokenSystem');

    try {
      var response = await http.get(
        Uri.parse("https://marzy.ru/api/order/get/$deliveryInt"),
        headers: {
          "Auth": action!,
        },
      );

      var result = utf8.decode(response.bodyBytes);
      result = "[" + result.substring(0, result.length) + "]";
      final data = await json.decode(result);
      print(data);
      List<DataFromCurrentDelivery> itemsList = List<DataFromCurrentDelivery>.from(data.map((i) => DataFromCurrentDelivery.fromJson(i)));
      if(itemsList[0].order!.status == "Поиск исполнителя") {
        if(itemsList[0].order!.responses!.isEmpty) {
          return [0, 0];
        } else return [1, itemsList[0].order];
      } else if(itemsList[0].order!.status == "Ожидает отзыва") {
        return [
          "В пути к магазину",
          itemsList[0].order
        ];
      } else {
        return [
          "Готов",
          itemsList[0].order
        ];
      }
    } catch (e) {
      print("При попытке ошибка: $e");
      return [0];
    }
  }
}


class DataFromCurrentDelivery {
  String? status;
  String? message;
  Order? order;

  DataFromCurrentDelivery({this.status, this.message, this.order});

  DataFromCurrentDelivery.fromJson(Map<String, dynamic> json) {
    status = json['status'];
    message = json['message'];
    order = json['order'] != null ? new Order.fromJson(json['order']) : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['status'] = this.status;
    data['message'] = this.message;
    if (this.order != null) {
      data['order'] = this.order!.toJson();
    }
    return data;
  }
}

class Order {
  num? id;
  num? clientId;
  num? memberId;
  List<Products>? products;
  num? deliveryCost;
  num? productsCost;
  num? allCost;
  String? status;
  String? createDate;
  String? finishDate;
  num? shopId;
  num? resultRating;
  String? resultComment;
  List<Responses>? responses;
  Shop? shop;
  Member? member;

  Order(
      {this.id,
        this.clientId,
        this.memberId,
        this.products,
        this.deliveryCost,
        this.productsCost,
        this.allCost,
        this.status,
        this.createDate,
        this.finishDate,
        this.shopId,
        this.resultRating,
        this.resultComment,
        this.responses,
        this.shop,
        this.member});

  Order.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    clientId = json['client_id'];
    memberId = json['member_id'];
    if (json['products'] != null) {
      products = <Products>[];
      json['products'].forEach((v) {
        products!.add(new Products.fromJson(v));
      });
    }
    deliveryCost = json['delivery_cost'];
    productsCost = json['products_cost'];
    allCost = json['all_cost'];
    status = json['status'];
    createDate = json['create_date'];
    finishDate = json['finish_date'];
    shopId = json['shop_id'];
    resultRating = json['result_rating'];
    resultComment = json['result_comment'];
    if (json['responses'] != null) {
      responses = <Responses>[];
      json['responses'].forEach((v) {
        responses!.add(new Responses.fromJson(v));
      });
    }
    shop = json['shop'] != null ? new Shop.fromJson(json['shop']) : null;
    member = json['member'] != null ? new Member.fromJson(json['member']) : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['client_id'] = this.clientId;
    data['member_id'] = this.memberId;
    if (this.products != null) {
      data['products'] = this.products!.map((v) => v.toJson()).toList();
    }
    data['delivery_cost'] = this.deliveryCost;
    data['products_cost'] = this.productsCost;
    data['all_cost'] = this.allCost;
    if (this.member != null) {
      data['member'] = this.member!.toJson();
    }
    data['status'] = this.status;
    data['create_date'] = this.createDate;
    data['finish_date'] = this.finishDate;
    data['shop_id'] = this.shopId;
    data['result_rating'] = this.resultRating;
    data['result_comment'] = this.resultComment;
    if (this.responses != null) {
      data['responses'] = this.responses!.map((v) => v.toJson()).toList();
    }
    if (this.shop != null) {
      data['shop'] = this.shop!.toJson();
    }
    return data;
  }
}

class Products {
  num? count;
  Product? product;

  Products({this.count, this.product});

  Products.fromJson(Map<String, dynamic> json) {
    count = json['count'];
    product =
    json['product'] != null ? new Product.fromJson(json['product']) : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['count'] = this.count;
    if (this.product != null) {
      data['product'] = this.product!.toJson();
    }
    return data;
  }
}

class Responses {
  num? id;
  String? name;
  String? surname;
  String? secondName;
  num? rating;
  num? ordersCount;

  Responses(
      {this.id,
        this.name,
        this.surname,
        this.secondName,
        this.rating,
        this.ordersCount});

  Responses.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    name = json['name'];
    surname = json['surname'];
    secondName = json['second_name'];
    rating = json['rating'];
    ordersCount = json['orders_count'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['name'] = this.name;
    data['surname'] = this.surname;
    data['second_name'] = this.secondName;
    data['rating'] = this.rating;
    data['orders_count'] = this.ordersCount;
    return data;
  }
}

class Product {
  num? id;
  num? cost;
  String? name;
  String? unit;
  List<String>? photos;
  num? weight;
  String? article;
  num? shopId;
  num? categoryId;
  String? description;

  Product(
      {this.id,
        this.cost,
        this.name,
        this.unit,
        this.photos,
        this.weight,
        this.article,
        this.shopId,
        this.categoryId,
        this.description});

  Product.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    cost = json['cost'];
    name = json['name'];
    unit = json['unit'];
    photos = json['photos'].cast<String>();
    weight = json['weight'];
    article = json['article'];
    shopId = json['shop_id'];
    categoryId = json['category_id'];
    description = json['description'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['cost'] = this.cost;
    data['name'] = this.name;
    data['unit'] = this.unit;
    data['photos'] = this.photos;
    data['weight'] = this.weight;
    data['article'] = this.article;
    data['shop_id'] = this.shopId;
    data['category_id'] = this.categoryId;
    data['description'] = this.description;
    return data;
  }
}

class Shop {
  num? id;
  String? name;
  String? description;
  String? photo;
  String? cityId;

  Shop(
      {this.id,
        this.name,
        this.description,
        this.photo,
        this.cityId});

  Shop.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    name = json['name'];
    description = json['description'];
    photo = json['photo'];
    cityId = json['city_id'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['name'] = this.name;
    data['description'] = this.description;
    data['photo'] = this.photo;
    data['city_id'] = this.cityId;
    return data;
  }
}

class Member {
  num? id;
  String? phone;
  String? email;
  String? surname;
  String? name;
  String? secondName;
  String? createDate;
  num? createDateTimestamp;
  num? activateStatus;
  String? activateStatusStr;

  Member(
      {this.id,
        this.phone,
        this.email,
        this.surname,
        this.name,
        this.secondName,
        this.createDate,
        this.createDateTimestamp,
        this.activateStatus,
        this.activateStatusStr});

  Member.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    phone = json['phone'];
    email = json['email'];
    surname = json['surname'];
    name = json['name'];
    secondName = json['second_name'];
    createDate = json['create_date'];
    createDateTimestamp = json['create_date_timestamp'];
    activateStatus = json['activate_status'];
    activateStatusStr = json['activate_status_str'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['phone'] = this.phone;
    data['email'] = this.email;
    data['surname'] = this.surname;
    data['name'] = this.name;
    data['second_name'] = this.secondName;
    data['create_date'] = this.createDate;
    data['create_date_timestamp'] = this.createDateTimestamp;
    data['activate_status'] = this.activateStatus;
    data['activate_status_str'] = this.activateStatusStr;
    return data;
  }
}
