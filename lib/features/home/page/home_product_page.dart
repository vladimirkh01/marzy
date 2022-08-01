import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:marzy/features/nearest_orders/page/nearest_orders.dart';
import 'package:marzy/features/standing_order/page/standing_order.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:marzy/shared/enums/AppEnums.dart';
import 'package:marzy/shared/images/images.dart';
import 'package:marzy/shared/presentation/colors.dart';
import 'package:marzy/shared/presentation/text_styles.dart';
import 'package:marzy/shared/widgets/custom_buttons.dart';
import 'package:shared_preferences/shared_preferences.dart';

import './catalog_item.dart';
import 'package:http/http.dart' as http;

class ProductTab extends StatelessWidget {
  final HomePageType type;
  final int currentPos;
  const ProductTab({Key? key, required this.type, required this.currentPos}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ProductTabAdditional(
      type: type,
      currentPos: currentPos
    );
  }
}

class ProductTabAdditional extends StatefulWidget {
  var currentPos;
  HomePageType type;

  ProductTabAdditional({Key? key, required this.currentPos, required this.type}) : super(key: key);

  @override
  State<ProductTabAdditional> createState() => _ProductTabAdditionalState();
}

class _ProductTabAdditionalState extends State<ProductTabAdditional> {
  var val1 = 0;
  int posButton = 0;
  final ScrollController _controller = ScrollController();

  @override
  Widget build(BuildContext context) {
    return ListView(
      controller: _controller,
      children: [
        Padding(
          padding: EdgeInsets.symmetric(horizontal: 20.w, vertical: 10.h),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Container(
              //   decoration: BoxDecoration(
              //     color: AppColors.fon,
              //     borderRadius: BorderRadius.circular(8),
              //   ),
              //   padding: const EdgeInsets.all(16),
              //   child: Column(
              //     children: [
              //       Row(
              //         mainAxisAlignment: MainAxisAlignment.spaceBetween,
              //         children: [
              //           Text(
              //             'Действующий заказ: U223321',
              //             style: AppTextStyles.interMed14
              //                 .copyWith(color: AppColors.black),
              //           ),
              //           CustomTextButton(
              //             text: 'перейти',
              //             onPressed: () {
              //               // Get.toNamed(StandingOrderPage.route,
              //               // arguments: ['U223321', 5000]);
              //               Navigator.push(
              //                   context,
              //                   MaterialPageRoute(
              //                       builder: (context) => StandingOrderPage()));
              //             },
              //           )
              //         ],
              //       ),
              //       Text(
              //         'Доставит к Артем П.',
              //         style: AppTextStyles.interMed12,
              //       ),
              //       SizedBox(height: 10.h),
              //       ElevatedButton(
              //         onPressed: () {},
              //         child: Text('+7 920 000 00 00'),
              //         style: ButtonStyles.button1.copyWith(
              //           minimumSize:
              //           MaterialStateProperty.all(Size(double.infinity, 40)),
              //         ),
              //       ),
              //     ],
              //     crossAxisAlignment: CrossAxisAlignment.start,
              //   ),
              // ),
              SizedBox(height: 10.h),
              FutureBuilder(
                future: postRequestGetAllOrdersUsers(),
                builder: (BuildContext context, AsyncSnapshot<dynamic> snapshot) {
                  print(snapshot);
                  print(snapshot.data);
                  if(snapshot.data == null) {
                    return CircularProgressIndicator(
                      color: AppColors.accent,
                      strokeWidth: 2,
                    );
                  } else if(snapshot.data[0] == 0) {
                    return Container(
                      child: Center(
                        child: Text(
                            "Закажите и здесь появится ваш заказ"
                        ),
                      ),
                    );
                  } else {
                    return ListView.builder(
                      itemCount: val1 + 1,
                      shrinkWrap: true,
                      physics: NeverScrollableScrollPhysics(),
                      itemBuilder: (context, index) {
                        if(index == val1) {
                          return GestureDetector(
                            onTap: () {
                              setState(() {
                                if(posButton == 0) {
                                  posButton = 2;
                                } else {
                                  posButton = 0;
                                  _controller.animateTo(
                                    _controller.position.minScrollExtent,
                                    duration: Duration(milliseconds: 600),
                                    curve: Curves.fastOutSlowIn,
                                  );
                                }
                              });
                            },
                            child: Container(
                                margin: EdgeInsets.only(left: 100, right: 100),
                                padding: EdgeInsets.all(14),
                                decoration: BoxDecoration(
                                  color: AppColors.accent,
                                  borderRadius: BorderRadius.circular(8),
                                ),
                                child: RotatedBox(
                                  quarterTurns: posButton,
                                  child: CustomImage(
                                    width: 9.w,
                                    height: 9.w,
                                    color: AppColors.white,
                                    image: AppImages.more,
                                  ),
                                )
                            ),
                          );
                        } else if(index < 3) {
                          return Container(
                            decoration: BoxDecoration(
                              color: AppColors.fon,
                              borderRadius: BorderRadius.circular(8),
                            ),
                            padding: const EdgeInsets.all(16),
                            margin: EdgeInsets.only(bottom: 20),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                  children: [
                                    Text(
                                      'Номер заказа: ${snapshot.data[index].idOrder}',
                                      style: AppTextStyles.interMed14
                                          .copyWith(color: AppColors.black),
                                    ),
                                    CustomTextButton(
                                      text: 'перейти',
                                      onPressed: () {
                                        Navigator.push(
                                          context,
                                          MaterialPageRoute(
                                            builder: (context) => StandingOrderPage(
                                              idOrder: '${snapshot.data[index].idOrder}',
                                              allCouriers: [],
                                              costCart: '${snapshot.data[index].allCost}'
                                            )
                                          ),
                                        );
                                      },
                                    ),
                                  ],
                                ),
                                Text(
                                  snapshot.data[index].textOrder.toString(),
                                  style: AppTextStyles.interMed12,
                                ),
                              ],
                            ),
                          );
                        } else if(index >= 3) {
                          return Visibility(
                            visible: posButton == 0 ? false : true,
                            child: Container(
                              decoration: BoxDecoration(
                                color: AppColors.fon,
                                borderRadius: BorderRadius.circular(8),
                              ),
                              padding: const EdgeInsets.all(16),
                              margin: EdgeInsets.only(bottom: 20),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Row(
                                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                    children: [
                                      Text(
                                        'Номер заказа: ${snapshot.data[index].idOrder}',
                                        style: AppTextStyles.interMed14
                                            .copyWith(color: AppColors.black),
                                      ),
                                      CustomTextButton(
                                        text: 'перейти',
                                        onPressed: () {
                                          Navigator.push(
                                            context,
                                            MaterialPageRoute(
                                                builder: (context) => StandingOrderPage(
                                                    idOrder: '${snapshot.data[index].idOrder}',
                                                    allCouriers: [],
                                                    costCart: '${snapshot.data[index].allCost}'
                                                )
                                            ),
                                          );
                                        },
                                      ),
                                    ],
                                  ),
                                  Text(
                                    snapshot.data[index].textOrder.toString(),
                                    style: AppTextStyles.interMed12,
                                  ),
                                ],
                              ),
                            ),
                          );
                        }

                        return Container();
                      },
                    );
                  }
                },
              ),
              SizedBox(height: 18.h),
              Text(
                'Быстрые действия',
                style: AppTextStyles.interReg16
                    .copyWith(fontWeight: FontWeight.w600),
              ),
              SizedBox(height: 14.h),
              Row(
                children: [
                  Container(
                    height: 130.h,
                    width: 107.w,
                    decoration: BoxDecoration(
                      color: AppColors.fon,
                      borderRadius: BorderRadius.circular(8),
                    ),
                  ),
                  SizedBox(width: 7.w),
                  Container(
                    height: 130.h,
                    width: 107.w,
                    decoration: BoxDecoration(
                      color: AppColors.fon,
                      borderRadius: BorderRadius.circular(8),
                    ),
                  ),
                ],
              ),
              SizedBox(height: 18.h),
              Text(
                'Каталог',
                style: AppTextStyles.interReg16
                    .copyWith(fontWeight: FontWeight.w600),
              ),
              SizedBox(height: 14.h),
              FutureBuilder(
                future: postRequest(),
                builder: (BuildContext context, AsyncSnapshot<dynamic> snapshot) {
                  if(snapshot.data == null) {
                    return Container(
                      height: 25,
                      width: 25,
                      child: CircularProgressIndicator(
                        color: AppColors.accent,
                        strokeWidth: 2,
                      ),
                    );
                  }
                  else {
                    return GridView.builder(
                      gridDelegate: SliverGridDelegateWithMaxCrossAxisExtent(
                        maxCrossAxisExtent: 200,
                        childAspectRatio: 1 / 1,
                        crossAxisSpacing: 5,
                        mainAxisSpacing: 5,
                      ),
                      itemCount: snapshot.data.length,
                      physics: NeverScrollableScrollPhysics(),
                      shrinkWrap: true,
                      itemBuilder: (ctx, index) {
                        return CatalogItem(
                            imageUrl: snapshot.data[index].image,
                            title: snapshot.data[index].name,
                            categoryId: snapshot.data[index].id,
                        );
                      },
                    );
                  }
                },
              )
            ],
          ),
        ),
      ],
    );
  }

  Future<List<Object?>> postRequestGetAllOrdersUsers() async {
    SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
    final String? action = sharedPreferences.getString('tokenSystem');

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
      List<DataAllOrders> arrayDataAllOrders = [];
      val1 = itemsList[0].orders!.length;
      for(var i = 0; i < itemsList[0].orders!.length; i++) {
        var id = itemsList[0].orders![i].id;
        var status = itemsList[0].orders![i].status;
        var costAll = itemsList[0].orders![i].allCost.toString();
        arrayDataAllOrders.add(DataAllOrders(idOrder: id, textOrder: status, allCost: costAll));
      }

      if(arrayDataAllOrders.reversed.toList().isEmpty) {
        return [0, 0];
      } else return arrayDataAllOrders.toList();
    } catch (e) {
      return [0, 0];
    }
  }

  Future<List<CategoriesAdd>?> postRequest() async {
    var response = await http.get(
        Uri.parse("https://marzy.ru/api/category/tree")
    );

    var result = utf8.decode(response.bodyBytes);
    result = "[" + result.substring(0, result.length) + "]";
    final data = await json.decode(result);
    List<ItemProducts> itemsList = List<ItemProducts>.from(data.map((i) => ItemProducts.fromJson(i)));
    return itemsList[0].categories![widget.type.index].categories;
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
  String? image;
  List<CategoriesAdd>? categories;

  Categories({this.id, this.name, this.parent, this.categories});

  Categories.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    name = json['name'];
    parent = json['parent'];
    image = json['image'];
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
    data['image'] = this.image;
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
  String? image;

  CategoriesAdd({this.id, this.name, this.parent});

  CategoriesAdd.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    name = json['name'];
    parent = json['parent'];
    image = json['image'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['name'] = this.name;
    data['parent'] = this.parent;
    data['image'] = this.image;

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