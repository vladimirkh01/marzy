import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:marzy/shared/models/scrolling_text.dart';
import 'package:marzy/shared/widgets/custom_navigation_button.dart';
import 'package:marzy/features/home/providers/home_provider.dart';
import 'package:marzy/features/nearest_orders/page/nearest_orders.dart';
import 'package:marzy/features/profile/page/profile.dart';
import 'package:marzy/shared/enums/AppEnums.dart';
import 'package:marzy/shared/images/images.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:marzy/shared/presentation/colors.dart';
import 'dart:async';
import 'package:marzy/shared/presentation/button_styles.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:provider/provider.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import 'home_product_page.dart';

class HomePage extends StatefulWidget {
  HomePage({Key? key}) : super(key: key);

  @override
  HomePageState createState() => HomePageState();
}

class HomePageState extends State<HomePage>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;
  late int _currentTab;
  late TextEditingController _searchController;
  var statusLoadingUserData = false;
  String location = "Неизвестный адрес";
  Future<bool> get locationPermissionNotGranted async => !(await Permission.location.request().isGranted);

  @override
  void initState() {
    Future.delayed(Duration(seconds: 1), () async {
      postReqGetInfoAboutUser();
      final prefs = await SharedPreferences.getInstance();
      setState(() => location = prefs.getString("locationUser")!);
      if (await locationPermissionNotGranted) {
        return;
      }
    });
    _searchController = TextEditingController();
    _currentTab = 0;
    _tabController = TabController(vsync: this, length: 3);
    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
    _tabController.dispose();
  }

  void _goToTab(int index) {
    _tabController.animateTo(index);
    setState(() {
      _currentTab = index;
    });
  }


  Widget getTitle(bool searching, String title, BuildContext _context) {
    if (searching) {
      return TextFormField(
        onChanged: (value) {
          Provider.of<HomeProvider>(_context, listen: false).search(value);
        },
        controller: _searchController,
      );
    }
    return Text(title);
  }

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (context) => HomeProvider(),
      child: Builder(
        builder: (BuildContext context) {
          var provider = context.watch<HomeProvider>();
          return WillPopScope(
            onWillPop: () {
              return Future(() => true);
            },
            child: Scaffold(
              appBar: AppBar(
                centerTitle: false,
                titleTextStyle: TextStyle(
                    fontSize: 10,
                    color: Colors.black
                ),
                title: Container(
                  height: 90,
                  child: ScrollingText(
                    textStyle: TextStyle(
                        color: Colors.black,
                        fontSize: 18
                    ),
                    text: location,
                  ),
                ),
                leading: Padding(
                  padding: const EdgeInsets.only(left: 8.0),
                  child: CustomNavigationButton(
                    image: AppImages.locationButton,
                    width: 44.w,
                    height: 44.w,
                    onTap: () {
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => NearestOrdersPage()
                          )
                      );
                    },
                  ),
                ),
                actions: [
                  // if (!provider.searching)
                  //   CustomNavigationButton(
                  //     image: AppImages.searchButton,
                  //     onTap: () {
                  //       _searchController.clear();
                  //       provider.setSearching = true;
                  //     },
                  //   ),
                  if (!provider.searching) SizedBox(width: 5.w),
                  if (!provider.searching)
                    statusLoadingUserData == false ? CustomNavigationButton(
                      image: statusLoadingUserData == false ? AppImages.profileButton : "",
                      onTap: () {
                        if(!statusLoadingUserData) {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) =>
                                  ProfilePage(),
                            ),
                          );
                        }
                      },
                    ) : Container(
                      width: 55,
                      height: 55,
                      padding: EdgeInsets.all(16),
                      child: CircularProgressIndicator(
                        strokeWidth: 2,
                        color: AppColors.accent,
                      ),
                    ),
                  if (provider.searching)
                    IconButton(
                      padding: EdgeInsets.zero,
                      onPressed: () {
                        _searchController.clear();
                        provider.setSearching = false;
                      },
                      icon: Icon(
                        Icons.close,
                        color: Colors.grey,
                      ),
                    ),
                  SizedBox(width: 8.w),
                ],
              ),
              body: Column(
                children: [
                  Padding(
                    padding:
                    EdgeInsets.symmetric(horizontal: 20.w, vertical: 10.w),
                    child: Row(
                      children: [
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
                              return Container(
                                width: MediaQuery.of(context).size.width - 39,
                                height: 30,
                                child: ListView.builder(
                                  itemCount: snapshot.data.length,
                                  scrollDirection: Axis.horizontal,
                                  shrinkWrap: true,
                                  itemBuilder: (ctx, index) {
                                    return Container(
                                      margin: EdgeInsets.only(right: 6),
                                      child: ElevatedButton(
                                        onPressed: () {
                                          _goToTab(index);
                                        },
                                        child: Text(snapshot.data[index].name),
                                        style: _currentTab == index
                                            ? ButtonStyles.tabItemBtnSelected
                                            : ButtonStyles.tabItemBtnUnSelected,
                                      ),
                                    );
                                  },
                                ),
                              );
                            }
                          },
                        )
                      ],
                    ),
                  ),
                  Expanded(
                    child: TabBarView(
                      physics: const NeverScrollableScrollPhysics(),
                      controller: _tabController,
                      children: [
                        ProductTab(
                          currentPos: _currentTab,
                          type: HomePageType.products,
                        ),
                        ProductTab(
                          currentPos: _currentTab,
                          type: HomePageType.medicines,
                        ),
                        ProductTab(
                          currentPos: _currentTab,
                          type: HomePageType.other,
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }

  Future<List<Categories>?> postRequest() async {
    var response = await http.get(
        Uri.parse("https://marzy.ru/api/category/tree")
    );

    var result = utf8.decode(response.bodyBytes);
    result = "[" + result.substring(0, result.length) + "]";
    final data = await json.decode(result);

    List<ItemProducts> itemsList = List<ItemProducts>.from(data.map((i) => ItemProducts.fromJson(i)));
    return itemsList[0].categories;
  }

  Future<void> postReqGetInfoAboutUser() async {
    setState(() => statusLoadingUserData = true);
    SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
    final String? action = sharedPreferences.getString('tokenSystem');
    print("AUTH DATA $action");

    var response = await http.get(
        Uri.parse("https://marzy.ru/api/user/me"),
        headers: {"Auth": action!}
    );

    var result = utf8.decode(response.bodyBytes);
    result = "[" + result.substring(0, result.length) + "]";
    final data = await json.decode(result);
    var data2 = List<UserDataGetter>.from(data.map((i) => UserDataGetter.fromJson(i)));
    sharedPreferences.setString("paramVerification", data2[0].user!.activateStatus.toString());
    setState(() => statusLoadingUserData = false);
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

class UserDataGetter {
  String? status;
  String? message;
  User? user;
  Auth? auth;

  UserDataGetter({this.status, this.message, this.user, this.auth});

  UserDataGetter.fromJson(Map<String, dynamic> json) {
    status = json['status'];
    message = json['message'];
    user = json['user'] != null ? new User.fromJson(json['user']) : null;
    auth = json['auth'] != null ? new Auth.fromJson(json['auth']) : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['status'] = this.status;
    data['message'] = this.message;
    if (this.user != null) {
      data['user'] = this.user!.toJson();
    }
    if (this.auth != null) {
      data['auth'] = this.auth!.toJson();
    }
    return data;
  }
}

class User {
  int? id;
  String? phone;
  String? email;
  String? surname;
  String? name;
  String? secondName;
  String? createDate;
  int? createDateTimestamp;
  int? activateStatus;
  String? activateStatusStr;

  User(
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

  User.fromJson(Map<String, dynamic> json) {
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

class Auth {
  int? id;
  String? token;
  String? createDate;
  String? expireDate;
  int? accessType;
  int? userId;
  int? status;
  String? qAccessTypeText;
  String? qStatus;

  Auth(
      {this.id,
        this.token,
        this.createDate,
        this.expireDate,
        this.accessType,
        this.userId,
        this.status,
        this.qAccessTypeText,
        this.qStatus});

  Auth.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    token = json['token'];
    createDate = json['create_date'];
    expireDate = json['expire_date'];
    accessType = json['access_type'];
    userId = json['user_id'];
    status = json['status'];
    qAccessTypeText = json['q_access_type_text'];
    qStatus = json['q_status'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['token'] = this.token;
    data['create_date'] = this.createDate;
    data['expire_date'] = this.expireDate;
    data['access_type'] = this.accessType;
    data['user_id'] = this.userId;
    data['status'] = this.status;
    data['q_access_type_text'] = this.qAccessTypeText;
    data['q_status'] = this.qStatus;
    return data;
  }
}