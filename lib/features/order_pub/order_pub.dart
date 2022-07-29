import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:marzy/features/nearest_orders/page/nearest_orders.dart';
import 'package:marzy/shared/presentation/colors.dart';
import 'package:marzy/shared/presentation/text_styles.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'package:http/http.dart' as http;

class OrderPabPage extends StatefulWidget {
  static const route = '/order_pub';
  OrderPabPage({Key? key}) : super(key: key);

  @override
  _OrderPabPageState createState() => _OrderPabPageState();
}

class _OrderPabPageState extends State<OrderPabPage> with SingleTickerProviderStateMixin {
  var val1 = 0;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Container(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text("Ваши заказы"),
              ],
            ),
            margin: EdgeInsets.only(left: 5.w),
          ),
          automaticallyImplyLeading: false,
          centerTitle: false,
        ),
        body: FutureBuilder(
          future: postRequestGetAllOrdersUsers(),
          builder: (BuildContext context, AsyncSnapshot<dynamic> snapshot) {
            if(snapshot.data == null) {
              return Center(
                child: CircularProgressIndicator(
                  strokeWidth: 2,
                  color: AppColors.accent,
                ),
              );
            } else {
              return ListView.builder(
                itemCount: val1,
                itemBuilder: (BuildContext context, int index) {
                  return Container(
                    color: Colors.white,
                    width: MediaQuery.of(context).size.width,
                    height: 185.h,
                    child: Container(
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
                                'Исполненный заказ: ${snapshot.data[index].id}',
                                style:
                                AppTextStyles.interMed14.copyWith(color: AppColors.black),
                              ),
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
                                  text: '250 ₽',
                                  style: AppTextStyles.interMed12.copyWith(
                                    color: AppColors.accent,
                                  ),
                                ),
                              ],
                            ),
                          ),
                          SizedBox(height: 10.h),
                          RichText(
                            textAlign: TextAlign.start,
                            text: TextSpan(
                              text: 'Статус заказа: ',
                              style: AppTextStyles.interMed12,
                              children: [
                                WidgetSpan(child: SizedBox(width: 10)),
                                TextSpan(
                                  text: '${snapshot.data[index].status}',
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
                                  text: 'отрицательный',
                                  style: AppTextStyles.interMed12.copyWith(
                                    color: Colors.red,
                                  ),
                                ),
                              ],
                            ),
                          ),
                          SizedBox(height: 6.h),
                          RichText(
                            textAlign: TextAlign.start,
                            text: TextSpan(
                              text: 'Отзыв от клиента: ',
                              style: AppTextStyles.interMed12,
                              children: [
                                WidgetSpan(child: SizedBox(width: 10)),
                                TextSpan(
                                  text: '${snapshot.data[index].resultComment}',
                                  style: AppTextStyles.interMed12.copyWith(
                                    color: AppColors.black,
                                  ),
                                ),
                              ],
                            ),
                          ),
                          SizedBox(height: 10.h),
                        ],
                        crossAxisAlignment: CrossAxisAlignment.start,
                      ),
                    ),
                  );
                },
              );
            }
          },
        )
    );
  }

  Future<List<Object?>> postRequestGetAllOrdersUsers() async {
    SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
    final String? action = sharedPreferences.getString('tokenSystem1');

    try {
      var response = await http.get(
        Uri.parse("https://marzy.ru/api/order/get/me"),
        headers: {
          "Auth": action!,
        },
      );

      var result = utf8.decode(response.bodyBytes);
      result = "[" + result.substring(0, result.length) + "]";
      final data = await json.decode(result);
      List<ListOrders> itemsList = List<ListOrders>.from(data.map((i) => ListOrders.fromJson(i)));
      val1 = itemsList[0].orders!.length;
      if(itemsList[0].orders!.toList().isEmpty) {
        return [0, 0];
      } else return itemsList[0].orders!;
    } catch (e) {
      return [0, 0];
    }
  }
}

class DataAllOrders {
  int? idOrder;
  String? textOrder;
  String? allCost;

  DataAllOrders({this.idOrder, this.textOrder, this.allCost});
}

class ItemProducts {
  String? status;
  String? message;
  List<Categories>? categories;

  ItemProducts({this.status, this.message, this.categories});

  ItemProducts.fromJson(Map<String, dynamic> json) {
    status = json['status'];
    message = json['message'];
    if (json['categories'] != null) {
      categories = <Categories>[];
      json['categories'].forEach((v) {
        categories!.add(new Categories.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['status'] = this.status;
    data['message'] = this.message;
    if (this.categories != null) {
      data['categories'] = this.categories!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class Categories {
  num? id;
  String? name;
  num? parent;
  List<CategoriesAdd>? categories;

  Categories({this.id, this.name, this.parent, this.categories});

  Categories.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    name = json['name'];
    parent = json['parent'];
    if (json['categories'] != null) {
      categories = <CategoriesAdd>[];
      json['categories'].forEach((v) {
        categories!.add(new CategoriesAdd.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['name'] = this.name;
    data['parent'] = this.parent;
    if (this.categories != null) {
      data['categories'] = this.categories!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class CategoriesAdd {
  num? id;
  String? name;
  num? parent;

  CategoriesAdd({this.id, this.name, this.parent});

  CategoriesAdd.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    name = json['name'];
    parent = json['parent'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['name'] = this.name;
    data['parent'] = this.parent;
    return data;
  }
}

class ListOrders {
  String? status;
  String? message;
  List<Orders>? orders;

  ListOrders({this.status, this.message, this.orders});

  ListOrders.fromJson(Map<String, dynamic> json) {
    status = json['status'];
    message = json['message'];
    if (json['orders'] != null) {
      orders = <Orders>[];
      json['orders'].forEach((v) {
        orders!.add(new Orders.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['status'] = this.status;
    data['message'] = this.message;
    if (this.orders != null) {
      data['orders'] = this.orders!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class Orders {
  int? id;
  int? clientId;
  int? memberId;
  List<Products>? products;
  double? deliveryCost;
  double? productsCost;
  double? allCost;
  String? status;
  Address? address;
  String? createDate;
  int? shopId;
  double? resultRating;
  String? resultComment;
  Shop? shop;

  Orders(
      {this.id,
        this.clientId,
        this.memberId,
        this.products,
        this.deliveryCost,
        this.productsCost,
        this.allCost,
        this.status,
        this.address,
        this.createDate,
        this.shopId,
        this.resultRating,
        this.resultComment,
        this.shop});

  Orders.fromJson(Map<String, dynamic> json) {
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
    address =
    json['address'] != null ? new Address.fromJson(json['address']) : null;
    createDate = json['create_date'];
    shopId = json['shop_id'];
    resultRating = json['result_rating'];
    resultComment = json['result_comment'];
    shop = json['shop'] != null ? new Shop.fromJson(json['shop']) : null;
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
    data['status'] = this.status;
    if (this.address != null) {
      data['address'] = this.address!.toJson();
    }
    data['create_date'] = this.createDate;
    data['shop_id'] = this.shopId;
    data['result_rating'] = this.resultRating;
    data['result_comment'] = this.resultComment;
    if (this.shop != null) {
      data['shop'] = this.shop!.toJson();
    }
    return data;
  }
}

class Products {
  int? count;

  Products.fromJson(Map<String, dynamic> json) {
    count = json['count'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['count'] = this.count;
    return data;
  }
}

class Product {
  int? id;
  int? cost;
  String? name;
  String? unit;
  int? weight;
  String? article;
  int? shopId;
  int? categoryId;
  String? description;

  Product(
      {this.id,
        this.cost,
        this.name,
        this.unit,
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
    data['weight'] = this.weight;
    data['article'] = this.article;
    data['shop_id'] = this.shopId;
    data['category_id'] = this.categoryId;
    data['description'] = this.description;
    return data;
  }
}

class Shop {
  int? id;
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