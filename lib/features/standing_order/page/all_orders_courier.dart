import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:marzy/features/nearest_orders/page/nearest_orders.dart';
import 'package:marzy/features/static/basket/components/basket_button_item.dart';
import 'package:marzy/shared/presentation/button_styles.dart';
import 'package:marzy/shared/widgets/custom_navigation_button.dart';
import 'package:marzy/shared/images/images.dart';
import 'package:marzy/shared/presentation/colors.dart';
import 'package:marzy/shared/presentation/text_styles.dart';
import 'package:marzy/shared/widgets/custom_buttons.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'package:http/http.dart' as http;
import 'package:url_launcher/url_launcher_string.dart';
import 'package:yandex_mapkit/yandex_mapkit.dart';



class AllOrdersPage extends StatefulWidget {
  static const route = '/all_orders_page';
  final String idOrder;
  final String costCart;
  final AsyncSnapshot snapshot;

  AllOrdersPage({
    Key? key,
    required this.idOrder,
    required this.costCart,
    required this.snapshot
  }) : super(
      key: key
  );

  @override
  State<AllOrdersPage> createState() => _AllOrdersPageState(
      costCart: this.costCart,
      idOrder: this.idOrder,
      snapshot: this.snapshot
  );
}

class _AllOrdersPageState extends State<AllOrdersPage> {
  final String idOrder;
  final String costCart;
  final AsyncSnapshot snapshot;
  var star1 = AppColors.grey2;
  var star2 = AppColors.grey2;
  var star3 = AppColors.grey2;
  var star4 = AppColors.grey2;
  var star5 = AppColors.grey2;
  var visibilityReview = false;
  var stringFromInput;
  var deliveryIdNow;
  num starValue = 0;
  final List<MapObject> mapObjects = [];
  late YandexMapController controller;

  _AllOrdersPageState({
    required this.idOrder,
    required this.costCart,
    required this.snapshot
  }) : super();

  @override
  Widget build(BuildContext context) {

    Future.delayed(Duration(seconds: 2), () async {
      await controller.moveCamera(
          CameraUpdate.newCameraPosition(CameraPosition(target: Point(
              latitude: double.parse(snapshot.data.address.geoLat),
              longitude: double.parse(snapshot.data.address.geoLon)
          )))
      );

      await controller.moveCamera(CameraUpdate.zoomOut());
    });

    return Scaffold(
      appBar: AppBar(
        title: Text("Заказы"),
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
                    width: double.infinity,
                    height: snapshot.data.status == "В пути к магазину" ||
                        snapshot.data.status == "В пути к клиенту"
                        ? MediaQuery.of(context).size.width / 1.01 :
                          MediaQuery.of(context).size.width / 3,
                    decoration: BoxDecoration(
                      color: AppColors.fon,
                      borderRadius: BorderRadius.circular(8),
                    ),
                    padding: const EdgeInsets.all(16),
                    child: Column(
                      children: [
                        Text(
                          'Продуктовый заказ: $idOrder',
                          style: AppTextStyles.interMed14.copyWith(
                            color: AppColors.black,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                        SizedBox(height: 3.h),
                        RichText(
                          textAlign: TextAlign.start,
                          text: TextSpan(
                            text: 'Цена за доставку:',
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
                        SizedBox(height: 3.h),
                        Container(
                          child: Text(
                            "Статус заказа: ${snapshot.data.status}",
                            style: AppTextStyles.interMed14.copyWith(
                              fontSize: 13,
                              color: AppColors.black,
                              fontWeight: FontWeight.w100,
                            ),
                          ),
                        ),
                        SizedBox(height: 3.h),
                        if(snapshot.data.status == "В пути к магазину" || snapshot.data.status == "В пути к клиенту")
                          Container(
                            child: Text(
                              snapshot.data.client.name == null ?
                              "Имя заказчика: ${snapshot.data.client.name} ${snapshot.data.client.surname}" :
                              "Имя заказчика: неизвестно",
                              style: AppTextStyles.interMed14.copyWith(
                                fontSize: 13,
                                color: AppColors.black,
                                fontWeight: FontWeight.w100,
                              ),
                            ),
                          ),
                        SizedBox(height: 10.h),
                        if(snapshot.data.status != "В пути к магазину" && snapshot.data.status != "В пути к клиенту")
                          Row(
                            children: [
                              Container(
                                  width: 20,
                                  height: 20,
                                  child: CircularProgressIndicator(
                                    strokeWidth: 2,
                                    color: AppColors.accent,
                                  )
                              ),
                              SizedBox(width: 10),
                              Container(
                                child: Text(
                                  "Ожидание выбора заказчика",
                                  style: AppTextStyles.interMed14.copyWith(
                                    fontSize: 14,
                                    color: AppColors.black,
                                    fontWeight: FontWeight.w600,
                                  ),
                                ),
                              ),
                            ],
                          ),
                        Visibility(
                          visible: snapshot.data.status == "В пути к магазину" ? true : false,
                          child: Column(
                            children: [
                              BasketButtonItem(
                                  buttonLabel: 'Заказ получен, я в пути к клиенту',
                                  backgroundColor: AppColors.accent,
                                  textColor: AppColors.white,
                                  onPressed: () async {
                                    SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
                                    final String? action = sharedPreferences.getString('tokenSystem1');

                                    var response = await http.post(
                                      Uri.parse("https://marzy.ru/api/order/status"),
                                      headers: {"Auth": action!},
                                    );

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
                                        }).whenComplete(() => {
                                    Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => NearestOrdersPage()))
                                    });
                                  }
                              ),
                              ElevatedButton(
                                onPressed: () {
                                  launchUrlString("tel:+7${snapshot.data.client.phone}");
                                },
                                child: Text('+7${snapshot.data.client.phone}'),
                                style: ButtonStyles.button1.copyWith(
                                  minimumSize:
                                  MaterialStateProperty.all(Size(double.infinity, 40)),
                                ),
                              ),
                              SizedBox(height: 8.h),
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
                                  mapObjects: mapObjects,
                                  onMapCreated: (YandexMapController yandexMapController) async {
                                    controller = yandexMapController;
                                    print("snapshot.data.status ${snapshot.data.status}");
                                    final cameraPosition = await controller.getCameraPosition();
                                    final minZoom = await controller.getMinZoom();
                                    final maxZoom = await controller.getMaxZoom();

                                    print('Camera position: $cameraPosition');
                                    print('Min zoom: $minZoom, Max zoom: $maxZoom');
                                  },
                                  onCameraPositionChanged: (CameraPosition cameraPosition, CameraUpdateReason _, bool __) {
                                    var placeMark;

                                    placeMark = PlacemarkMapObject(
                                      consumeTapEvents: true,
                                      mapId: MapObjectId('placeMark_1'),
                                      point: Point(
                                        latitude: double.parse(
                                            snapshot.data.address.geoLat
                                        ),
                                        longitude: double.parse(
                                            snapshot.data.address.geoLon
                                        ),
                                      ),
                                      icon: PlacemarkIcon.single(
                                          PlacemarkIconStyle(
                                            image: BitmapDescriptor.fromAssetImage('assets/images/img_1.png'),
                                          )
                                      ),
                                      opacity: 1.0,
                                    );

                                    setState(() => mapObjects.add(placeMark));
                                  },
                                ),
                              )
                            ],
                          ),
                        ),
                        Visibility(
                          visible: snapshot.data.status == "В пути к клиенту" ? true : false,
                          child: Column(
                            children: [
                              BasketButtonItem(
                                  buttonLabel: 'Заказ выполнен и доставлен',
                                  backgroundColor: AppColors.accent,
                                  textColor: AppColors.white,
                                  onPressed: () async {
                                    SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
                                    final String? action = sharedPreferences.getString('tokenSystem1');

                                    var response = await http.post(
                                      Uri.parse("https://marzy.ru/api/order/status"),
                                      headers: {"Auth": action!},
                                    );

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
                                        }).whenComplete(() => {
                                      Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => NearestOrdersPage()))
                                    });
                                  }
                              ),
                              ElevatedButton(
                                onPressed: () {
                                  launchUrlString("tel:+7${snapshot.data.client.phone}");
                                },
                                child: Text('+7${snapshot.data.client.phone}'),
                                style: ButtonStyles.button1.copyWith(
                                  minimumSize:
                                  MaterialStateProperty.all(Size(double.infinity, 40)),
                                ),
                              ),
                              SizedBox(height: 8.h),
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
                                  mapObjects: mapObjects,
                                  onMapCreated: (YandexMapController yandexMapController) async {
                                    controller = yandexMapController;

                                    final cameraPosition = await controller.getCameraPosition();
                                    final minZoom = await controller.getMinZoom();
                                    final maxZoom = await controller.getMaxZoom();

                                    print('Camera position: $cameraPosition');
                                    print('Min zoom: $minZoom, Max zoom: $maxZoom');
                                  },
                                  onCameraPositionChanged: (CameraPosition cameraPosition, CameraUpdateReason _, bool __) {
                                    var placeMark;

                                    placeMark = PlacemarkMapObject(
                                      consumeTapEvents: true,
                                      mapId: MapObjectId('placeMark_1'),
                                      point: Point(
                                        latitude: double.parse(
                                            snapshot.data.address.geoLat
                                        ),
                                        longitude: double.parse(
                                            snapshot.data.address.geoLon
                                        ),
                                      ),
                                      icon: PlacemarkIcon.single(
                                          PlacemarkIconStyle(
                                            image: BitmapDescriptor.fromAssetImage('assets/images/img_1.png'),
                                          )
                                      ),
                                      opacity: 1.0,
                                    );

                                    setState(() => mapObjects.add(placeMark));
                                  },
                                ),
                              )
                            ],
                          ),
                        ),
                      ],
                      crossAxisAlignment: CrossAxisAlignment.start,
                    ),
                  ),
                  SizedBox(height: 18.h),
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
      } else {
        return [
          "В пути к магазину",
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
