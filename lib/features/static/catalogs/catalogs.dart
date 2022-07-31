import 'dart:convert';
import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:marzy/features/static/basket/basket.dart';
import 'package:marzy/features/static/catalog_detail/catalog_detail.dart';
import 'package:marzy/shared/presentation/colors.dart';
import 'package:marzy/shared/presentation/text_styles.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import 'back_button.dart';

class CatalogsScreen extends StatelessWidget {
  static const String route = '/catalogs';
  final int categoryId;
  CatalogsScreen({Key? key, required this.categoryId}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: Padding(
          padding: const EdgeInsets.only(left: 5.0),
          child: CustomBack(
            width: 28,
            height: 28,
            onTap: () => Navigator.pop(context),
          ),
        ),
        // title: Text('Овощи и зелень'),
        title: Container(
          width: 227.w,
          height: 40,
          decoration: BoxDecoration(
            color: AppColors.fon,
            borderRadius: BorderRadius.circular(8),
            border: Border.all(
              color: AppColors.fon,
              width: 0.001,
            ),
          ),
          child: Center(
            child: TextField(
              decoration: InputDecoration(
                prefixIcon: Icon(
                  Icons.search,
                  size: 18,
                ),
                hintText: 'Поиск',
                border: InputBorder.none,
                hintStyle: AppTextStyles.interMed14
                    .copyWith(color: AppColors.blackGrey),
                focusColor: AppColors.fon,
                fillColor: AppColors.fon,
              ),
            ),
          ),
        ),
        // actions: [
        //   SearchButton(
        //     image: AppImages.searchButton,
        //     width: 60,
        //     height: 60,
        //   ),
        // ],
      ),
      body: CatalogScreenAdditional(categoryId: categoryId)
    );
  }
}

class CatalogScreenAdditional extends StatefulWidget {
  int categoryId;
  CatalogScreenAdditional({Key? key, required this.categoryId}) : super(key: key);

  @override
  State<CatalogScreenAdditional> createState() => CatalogScreenAdditionalState();
}

class CatalogScreenAdditionalState extends State<CatalogScreenAdditional> {
  // List<Map<String, dynamic>>? data;
  int valueBasketMain = 0;
  bool? stateUpdateData = false;
  List<CatalogItems>? itemsList;
  List<BasketUser>? itemsListBasket;

  @override
  initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(
        horizontal: 10.w,
        vertical: 10,
      ),
      child: Stack(
        children: [
          FutureBuilder(
            future: postRequest(widget.categoryId),
            builder: (BuildContext context, AsyncSnapshot<dynamic> snapshot) {
              if(snapshot.data == null) {
                return Center(
                  child: Container(
                    height: 25,
                    width: 25,
                    child: CircularProgressIndicator(
                      color: AppColors.accent,
                      strokeWidth: 2,
                    ),
                  ),
                );
              }
              else if(snapshot.data.length == 0) {
                return Center(
                    child: Text(
                      "Здесь нет товаров",
                      style: TextStyle(
                          color: AppColors.accent
                      ),
                    )
                );
              }
              else {
                return GridView.builder(
                  itemCount: snapshot.data.length,
                  gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 2,
                    childAspectRatio: 0.75,
                    crossAxisSpacing: 10,
                    mainAxisSpacing: 20,
                  ),
                  itemBuilder: (context, ind) => Container(
                    decoration: BoxDecoration(
                      // color: AppColors.accent,
                      borderRadius: BorderRadius.circular(10),
                      border: Border.all(color: AppColors.fonGrey),
                    ),
                    padding: const EdgeInsets.all(10),
                    child: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          snapshot.data[ind].photos.isEmpty == false ? GestureDetector(
                            onTap: () {
                              Navigator.push(context,
                                  MaterialPageRoute(builder: (context) => CatalogDetailScreen(
                                    urlImage: snapshot.data[ind].photos.isEmpty == false ?
                                    "https://marzy.ru/api/files/get?uuid=${snapshot.data[ind].photos[0]}" :
                                    "",
                                    name: snapshot.data[ind].name,
                                    value: snapshot.data[ind].basketValue.toString(),
                                    price: snapshot.data[ind].cost.toString(),
                                    desc: snapshot.data[ind].description,
                                  ))
                              );
                            },
                            child: Container(
                              width: 120,
                              height: 120,
                              child: Image.network(
                                "https://marzy.ru/api/files/get?uuid=${snapshot.data[ind].photos[0]}",
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
                              ),
                            ),
                          ) : GestureDetector(
                            onTap: () {
                              Navigator.push(context,
                                  MaterialPageRoute(builder: (context) => CatalogDetailScreen(
                                    urlImage: snapshot.data[ind].photos.isEmpty == false ?
                                    "https://marzy.ru/api/files/get?uuid=${snapshot.data[ind].photos[0]}" : "",
                                    name: snapshot.data[ind].name,
                                    value: snapshot.data[ind].basketValue.toString(),
                                    price: snapshot.data[ind].cost.toString(),
                                    desc: snapshot.data[ind].description,
                                  ))
                              );
                            },
                            child: Container(
                              width: 120,
                              height: 120,
                              color: Colors.white,
                            ),
                          ),
                          Spacer(),
                          Container(
                            // padding: const EdgeInsets.symmetric(horizontal: 7),
                            child: Text(
                              snapshot.data[ind].name,
                              // 'Lorem ipsum dolor sit amet, consectetur adipiscing elit',
                              style: AppTextStyles.interMed12,
                            ),
                          ),
                          SizedBox(height: 10),
                          // if (ind == 1 || ind == 3 || ind == 4)
                          //   Row(
                          //     mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          //     children: [
                          //       Text(
                          //         '233 ₽',
                          //         style: AppTextStyles.interReg16
                          //             .copyWith(fontSize: 18),
                          //       ),
                          //       Container(
                          //         padding: const EdgeInsets.all(6),
                          //         decoration: BoxDecoration(
                          //           color: AppColors.fonGrey,
                          //           borderRadius: BorderRadius.circular(43),
                          //         ),
                          //         child: Icon(
                          //           Icons.add,
                          //           size: 16,
                          //           color: AppColors.blackGrey,
                          //         ),
                          //       ),
                          //     ],
                          //   )
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                GestureDetector(
                                  onTap: () {
                                    changeBasketRemove(ind, snapshot.data[ind].id, snapshot.data[ind].basketValue);
                                  },
                                  child: Container(
                                    padding: const EdgeInsets.all(6),
                                    decoration: BoxDecoration(
                                      color: AppColors.fonGrey,
                                      borderRadius: BorderRadius.circular(43),
                                    ),
                                    child: Icon(
                                      Icons.remove,
                                      size: 16,
                                      color: AppColors.blackGrey,
                                    ),
                                  ),
                                ),
                                Text(
                                  snapshot.data[ind].basketValue.toString(),
                                  style: AppTextStyles.interReg16
                                      .copyWith(fontSize: 18),
                                ),
                                GestureDetector(
                                  onTap: () {
                                    changeBasketAdd(ind, snapshot.data[ind].id, snapshot.data[ind].basketValue);
                                  },
                                  child: Container(
                                    padding: const EdgeInsets.all(6),
                                    decoration: BoxDecoration(
                                      color: AppColors.fonGrey,
                                      borderRadius: BorderRadius.circular(43),
                                    ),
                                    child: Icon(
                                      Icons.add,
                                      size: 16,
                                      color: AppColors.blackGrey,
                                    ),
                                  ),
                                )
                              ],
                            ),
                        ],
                      ),
                    ),
                  ),
                );
              }
            },
          ),
          Column(
            children: [
              Spacer(),
              ElevatedButton(
                onPressed: () {
                  Navigator.push(context,
                      MaterialPageRoute(builder: (context) => BasketScreen()));
                },
                style: ButtonStyle(
                  minimumSize: MaterialStateProperty.all(
                    Size(double.infinity, 40),
                  ),
                  shape: MaterialStateProperty.all(
                    RoundedRectangleBorder(
                      borderRadius: BorderRadius.all(
                        Radius.circular(8.0),
                      ),
                    ),
                  ),
                ),
                child: Row(
                  children: [
                    Text(
                      'Корзина',
                      style: AppTextStyles.interMed14
                          .copyWith(color: AppColors.white),
                    ),
                    SizedBox(width: 10),
                    Container(
                      width: 24,
                      height: 24,
                      alignment: Alignment.center,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(45),
                        color: AppColors.white,
                      ),
                      padding: const EdgeInsets.all(2),
                      child: FutureBuilder(
                        future: getValueBasket(),
                        builder: (BuildContext context, AsyncSnapshot<dynamic> snapshot) {
                          if(!stateUpdateData! && snapshot.data != null) valueBasketMain = snapshot.data;
                          if(snapshot.data == null) {
                            return Center(
                              child: Container(
                                padding: EdgeInsets.all(2),
                                height: 25,
                                width: 25,
                                child: CircularProgressIndicator(
                                  color: AppColors.accent,
                                  strokeWidth: 2,
                                ),
                              ),
                            );
                          }
                          else {
                            return Text(
                              valueBasketMain.toString(),
                              style: AppTextStyles.interMed14
                                  .copyWith(color: AppColors.accent),
                              textAlign: TextAlign.center,
                            );
                          }
                        },
                      )
                    ),
                    Spacer(),
                    FutureBuilder(
                      future: getValueSum(),
                      builder: (BuildContext context, AsyncSnapshot<dynamic> snapshot) {
                        if(snapshot.data == null) {
                          return Text(
                            "Загрузка...",
                            style: AppTextStyles.interMed14
                                .copyWith(color: AppColors.white),
                          );
                        }
                        else {
                          return Text(
                            snapshot.data.toString() + ' ₽',
                            style: AppTextStyles.interMed14
                                .copyWith(color: AppColors.white),
                          );
                        }
                      },
                    )
                  ],
                ),
              ),
              SizedBox(height: 30),
            ],
          )
        ],
      ),
    );
  }

  Future<List<Products>?> postRequest(int categoryId) async {
    SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
    final String? action = sharedPreferences.getString('tokenSystem');
    if(!stateUpdateData!) {
      var response = await http.get(
          Uri.parse("https://marzy.ru/api/product/get/list?category_id=" + categoryId.toString())
      );

      var basketRes = await http.get(
        Uri.parse("https://marzy.ru/api/basket/get"),
        headers: {
          "Auth": action!,
        },
      );

      var basketResult = utf8.decode(basketRes.bodyBytes);
      basketResult = "[" + basketResult.substring(0, basketResult.length) + "]";
      final basketData = await json.decode(basketResult);
      itemsListBasket = List<BasketUser>.from(basketData.map((i) => BasketUser.fromJson(i)));

      print("https://marzy.ru/api/product/get/list?category_id=" + categoryId.toString());
      try {
        var result = utf8.decode(response.bodyBytes);
        result = "[" + result.substring(0, result.length) + "]";
        final data = await json.decode(result);
        itemsList = List<CatalogItems>.from(data.map((i) => CatalogItems.fromJson(i)));
      } catch (e) {
        print(e);
      }

      try {
        for(int i = 0; i < itemsList![0].products!.length; i++) {
          if(i == itemsListBasket![0].basket!.products![i].productId && i == itemsList![0].products![i].id) {
            print(i);
          }
        }
      } catch (e) {
        print(e);
      }

      stateUpdateData = true;
    }

    print(itemsList![0].products);
    return itemsList![0].products;
  }

  Future<int?> getValueBasket() async {
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

    try {
      List<BasketUser> itemsList = List<BasketUser>.from(data.map((i) => BasketUser.fromJson(i)));
      double a = 0;
      for(var i = 0; i < itemsList[0].basket!.products!.length; i++) a += itemsList[0].basket!.products![i].count!;
      return a.toInt();
    } catch (e) {
      print("Ошибка при получении данных количества товаров в корзине: " + e.toString());
    }

    return 0;
  }

  Future<num?> getValueSum() async {
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

    try {
      List<BasketUser> itemsList = List<BasketUser>.from(data.map((i) => BasketUser.fromJson(i)));
      return itemsList[0].basket!.cost;
    } catch (e) {
      print("Ошибка при получении суммы товаров в корзине: " + e.toString());
    }

    return 0;
  }

  Future<void> changeBasketAdd(int idProduct, int idProd, int countProduct) async {
    SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
    final String? action = sharedPreferences.getString('tokenSystem');

    setState(() {
      int? i = itemsList![0].products![idProduct].basketValue!;
      i++;
      countProduct++;
      valueBasketMain++;
      itemsList![0].products![idProduct].basketValue = i;
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
      setState(() {
        int? i = itemsList![0].products![idProduct].basketValue!;
        if(i != 0) {
          i--;
          valueBasketMain--;
          itemsList![0].products![idProduct].basketValue = i;
        }
      });

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

class SharedPreferencesBasket {
  int? idProduct;
  int? priceProduct;
  int? numberGoods;

  SharedPreferencesBasket(
      {this.idProduct, this.priceProduct, this.numberGoods});

  SharedPreferencesBasket.fromJson(Map<String, dynamic> json) {
    idProduct = json['idProduct'];
    priceProduct = json['priceProduct'];
    numberGoods = json['numberGoods'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['idProduct'] = this.idProduct;
    data['priceProduct'] = this.priceProduct;
    data['numberGoods'] = this.numberGoods;
    return data;
  }
}

class CatalogItems {
  String? status;
  String? message;
  List<Products>? products;
  int? count;
  int? page;
  int? pages;

  CatalogItems(
      {this.status,
        this.message,
        this.products,
        this.count,
        this.page,
        this.pages});

  CatalogItems.fromJson(Map<String, dynamic> json) {
    status = json['status'];
    message = json['message'];
    if (json['products'] != null) {
      products = <Products>[];
      json['products'].forEach((v) {
        products!.add(new Products.fromJson(v));
      });
    }
    count = json['count'];
    page = json['page'];
    pages = json['pages'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['status'] = this.status;
    data['message'] = this.message;
    if (this.products != null) {
      data['products'] = this.products!.map((v) => v.toJson()).toList();
    }
    data['count'] = this.count;
    data['page'] = this.page;
    data['pages'] = this.pages;
    return data;
  }
}

class Products {
  int? id;
  String? name;
  bool? inBasket;
  int? basketValue;
  int? categoryId;
  String? description;
  List<String>? photos;
  double? weight;
  String? article;
  double? cost;
  int? shopId;
  String? unit;
  QCategory? qCategory;
  QShop? qShop;

  Products(
      {this.id,
        this.name,
        this.inBasket,
        this.basketValue,
        this.categoryId,
        this.description,
        this.photos,
        this.weight,
        this.article,
        this.cost,
        this.shopId,
        this.unit,
        this.qCategory,
        this.qShop});

  Products.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    name = json['name'];
    basketValue = 0;
    categoryId = json['category_id'];
    photos = json['photos'].cast<String>();
    description = json['description'];
    weight = json['weight'];
    article = json['article'];
    cost = json['cost'];
    shopId = json['shop_id'];
    unit = json['unit'];
    qCategory = json['q_category'] != null
        ? new QCategory.fromJson(json['q_category'])
        : null;
    qShop = json['q_shop'] != null ? new QShop.fromJson(json['q_shop']) : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['name'] = this.name;
    data['category_id'] = this.categoryId;
    data['description'] = this.description;
    data['photos'] = this.photos;
    data['weight'] = this.weight;
    data['article'] = this.article;
    data['cost'] = this.cost;
    data['shop_id'] = this.shopId;
    data['unit'] = this.unit;
    if (this.qCategory != null) {
      data['q_category'] = this.qCategory!.toJson();
    }
    if (this.qShop != null) {
      data['q_shop'] = this.qShop!.toJson();
    }
    return data;
  }
}

class QCategory {
  int? id;
  String? name;
  int? parent;

  QCategory({this.id, this.name, this.parent});

  QCategory.fromJson(Map<String, dynamic> json) {
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

class QShop {
  int? id;
  String? name;
  String? description;
  String? photo;
  String? cityId;

  QShop(
      {this.id,
        this.name,
        this.description,
        this.photo,
        this.cityId});

  QShop.fromJson(Map<String, dynamic> json) {
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

class BasketUser {
  String? status;
  String? message;
  Basket? basket;

  BasketUser({this.status, this.message, this.basket});

  BasketUser.fromJson(Map<String, dynamic> json) {
    status = json['status'];
    message = json['message'];
    basket =
    json['basket'] != null ? new Basket.fromJson(json['basket']) : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['status'] = this.status;
    data['message'] = this.message;
    if (this.basket != null) {
      data['basket'] = this.basket!.toJson();
    }
    return data;
  }
}

class Basket {
  num? id;
  num? userId;
  List<ProductsAdditional>? products;
  num? status;
  String? createDate;
  num? cost;

  Basket(
      {this.id,
        this.userId,
        this.products,
        this.status,
        this.createDate,
        this.cost});

  Basket.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    userId = json['user_id'];
    if (json['products'] != null) {
      products = <ProductsAdditional>[];
      json['products'].forEach((v) {
        products!.add(new ProductsAdditional.fromJson(v));
      });
    }
    status = json['status'];
    createDate = json['create_date'];
    cost = json['cost'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['user_id'] = this.userId;
    if (this.products != null) {
      data['products'] = this.products!.map((v) => v.toJson()).toList();
    }
    data['status'] = this.status;
    data['create_date'] = this.createDate;
    data['cost'] = this.cost;
    return data;
  }
}

class ProductsAdditional {
  num? count;
  num? productId;
  Product? product;

  ProductsAdditional({this.count, this.productId, this.product});

  ProductsAdditional.fromJson(Map<String, dynamic> json) {
    count = json['count'];
    productId = json['product_id'];
    product =
    json['product'] != null ? new Product.fromJson(json['product']) : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['count'] = this.count;
    data['product_id'] = this.productId;
    if (this.product != null) {
      data['product'] = this.product!.toJson();
    }
    return data;
  }
}

class Product {
  int? id;
  String? name;
  int? categoryId;
  String? description;
  double? weight;
  String? article;
  double? cost;
  int? shopId;
  String? unit;

  Product(
      {this.id,
        this.name,
        this.categoryId,
        this.description,
        this.weight,
        this.article,
        this.cost,
        this.shopId,
        this.unit});

  Product.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    name = json['name'];
    categoryId = json['category_id'];
    description = json['description'];
    weight = json['weight'];
    article = json['article'];
    cost = json['cost'];
    shopId = json['shop_id'];
    unit = json['unit'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['name'] = this.name;
    data['category_id'] = this.categoryId;
    data['description'] = this.description;
    data['weight'] = this.weight;
    data['article'] = this.article;
    data['cost'] = this.cost;
    data['shop_id'] = this.shopId;
    data['unit'] = this.unit;
    return data;
  }
}