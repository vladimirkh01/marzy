import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:marzy/features/nearest_orders/page/nearest_orders.dart';
import 'package:marzy/shared/presentation/colors.dart';
import 'package:marzy/shared/presentation/text_styles.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'package:http/http.dart' as http;

class OrderCourierPage extends StatefulWidget {
  static const route = '/order_pub';
  final int idCourierFrom;

  OrderCourierPage({
    Key? key,
    required this.idCourierFrom
  }) : super(
      key: key
  );

  @override
  _OrderPabPageState createState() => _OrderPabPageState();
}

class _OrderPabPageState extends State<OrderCourierPage> with SingleTickerProviderStateMixin {
  var val1 = 0;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Container(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text("Отзывы курьера"),
              ],
            ),
            margin: EdgeInsets.only(left: 5.w),
          ),
          automaticallyImplyLeading: false,
          centerTitle: false,
        ),
        body: FutureBuilder(
          future: postRequestGetAllOrdersUsers(widget.idCourierFrom),
          builder: (BuildContext context, AsyncSnapshot<dynamic> snapshot) {
            if(snapshot.data == null) {
              return Center(
                child: CircularProgressIndicator(
                  strokeWidth: 2,
                  color: AppColors.accent,
                ),
              );
            } else if(snapshot.data[0] == [0]) {
              return Center(
                child: Text(
                  "У курьера нет отзывов"
                ),
              );
            } else {
              return ListView.builder(
                itemCount: val1,
                itemBuilder: (BuildContext context, int index) {
                  return Container(
                    color: Colors.white,
                    width: MediaQuery.of(context).size.width,
                    height: 100.h,
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
                          SizedBox(height: 6.h),
                          RichText(
                            textAlign: TextAlign.start,
                            text: TextSpan(
                              text: 'Рейтинг заказа: ',
                              style: AppTextStyles.interMed12,
                              children: [
                                WidgetSpan(child: SizedBox(width: 10)),
                                TextSpan(
                                  text: '${snapshot.data[1][index].rating}',
                                  style: AppTextStyles.interMed12.copyWith(
                                    color: Colors.black,
                                  ),
                                ),
                              ],
                            ),
                          ),
                          RichText(
                            textAlign: TextAlign.start,
                            text: TextSpan(
                              text: 'Отзыв от клиента: ',
                              style: AppTextStyles.interMed12,
                              children: [
                                WidgetSpan(child: SizedBox(width: 10)),
                                TextSpan(
                                  text: '${snapshot.data[1][index].comment}',
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

  Future<List<Object?>> postRequestGetAllOrdersUsers(idCourier) async {
    try {
      SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
      final String? action = sharedPreferences.getString('tokenSystem');
      var response = await http.get(
        Uri.parse("https://marzy.ru/api/order/get/comments/$idCourier"),
        headers: {
          "Auth": action!,
        },
      );

      var result = utf8.decode(response.bodyBytes);
      result = "[" + result.substring(0, result.length) + "]";
      final data = await json.decode(result);
      List<ListOrders> itemsList = List<ListOrders>.from(data.map((i) => ListOrders.fromJson(i)));
      val1 = itemsList[0].result!.length;
      if(itemsList[0].result!.toList().isEmpty) {
        return [0, 0];
      } else return [1, itemsList[0].result!];
    } catch (e) {
      print(e);
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
  List<Result>? result;

  ListOrders({this.status, this.message, this.result});

  ListOrders.fromJson(Map<String, dynamic> json) {
    status = json['status'];
    message = json['message'];
    if (json['result'] != null) {
      result = <Result>[];
      json['result'].forEach((v) {
        result!.add(new Result.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['status'] = this.status;
    data['message'] = this.message;
    if (this.result != null) {
      data['result'] = this.result!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class Result {
  num? rating;
  String? comment;

  Result({this.rating, this.comment});

  Result.fromJson(Map<String, dynamic> json) {
    rating = json['rating'];
    comment = json['comment'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['rating'] = this.rating;
    data['comment'] = this.comment;
    return data;
  }
}