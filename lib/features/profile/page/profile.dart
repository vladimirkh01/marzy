import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:marzy/features/auth/verification/page/verification_screen.dart';
import 'package:marzy/features/help/page/help.dart';
import 'package:marzy/features/home/page/home.dart';
import 'package:marzy/features/order_pub/order_pub.dart';
import 'package:marzy/features/profile/page/profile_item.dart';
import 'package:marzy/features/splash/views/splash.dart';
import 'package:marzy/features/static/basket/components/basket_button_item.dart';
import 'package:marzy/shared/images/images.dart';
import 'package:marzy/shared/localization/strings_ru.dart';
import 'package:marzy/shared/presentation/button_styles.dart';
import 'package:marzy/shared/presentation/colors.dart';
import 'package:marzy/shared/presentation/text_styles.dart';
import 'package:marzy/shared/widgets/custom_buttons.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

class ProfilePage extends StatelessWidget {
  static const route = '/profile_home';
  late var verification;
  ProfilePage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {

    Future.delayed(Duration.zero, () async {
      SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
      verification = sharedPreferences.getString("paramVerification");
    });

    var param = getParamCourier();
    return Scaffold(
      appBar: AppBar(
        title: Text(AppStrings.profile),
        automaticallyImplyLeading: false,
        leading: CustomBackButton(),
      ),
      body: Padding(
        padding: EdgeInsets.symmetric(horizontal: 20.w, vertical: 30.h),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              decoration: BoxDecoration(
                color: Colors.blue,
                borderRadius: BorderRadius.circular(100),
              ),
              height: 100.h,
              width: 100.w,
            ),
            SizedBox(height: 20.h),
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
                  return Column(
                    children: <Widget>[
                      Text(
                        snapshot.data.name == "" ? "Неизвестный пользователь" : snapshot.data.name + " " + snapshot.data.surname,
                        style: AppTextStyles.interSemiBold20,
                      ),
                      SizedBox(height: 20.h),
                      ProfileItem(
                        text: snapshot.data.email == "" ? "Незаполненное поле" : snapshot.data.email,
                        hint: "Почта",
                        isClickable: true,
                        onClick: () {
                        },
                      ),
                      SizedBox(height: 20.h),
                      ProfileItem(
                        text: snapshot.data.phone == "" ? "Незаполненное поле" : "+7" + snapshot.data.phone,
                        hint: "Телефон",
                        isClickable: true,
                        onClick: () {
                          // controller.editPhoneNumber();
                        },
                      )
                    ],
                  );
                }
              },
            ),
            if (param == "0") SizedBox(height: 20.h),
            if (param == "1")
              ProfileItem(
                text: "**** 1223",
                hint: "Способы оплаты",
                isClickable: true,
                icon: AppImages.payment,
                onClick: () {
                  // controller.editPhoneNumber();
                },
              ),
            SizedBox(height: 20.h),
            FutureBuilder(
              future: postRequest1(),
              builder: (BuildContext context, AsyncSnapshot<dynamic> snapshot) {
                if(snapshot.data == null) {
                  return SizedBox(
                    width: 30,
                    height: 30,
                    child: CircularProgressIndicator(
                      strokeWidth: 2,
                      color: AppColors.accent,
                    ),
                  );
                } else {
                  return ProfileItem(
                    text: snapshot.data.toString(),
                    hint: "Рейтинг",
                    onClick: () {
                      print("Tapped profile item Рейтинг");
                    },
                  );
                }
              },

            ),
            if (param == "1") SizedBox(height: 20.h),
            if (param == "1")
              ProfileItem(
                text: "Успешна",
                hint: "Верификация",
                textColor: AppColors.accent,
              ),
            Spacer(),
            ElevatedButton(
              style: ButtonStyles.selectedButtonStyle,
              onPressed: () async {
                // controller.sigInAsCourier();
                SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
                if(sharedPreferences.getString("paramUserType") == "0") {
                  print("accessType ${sharedPreferences.getString("accessType")}");
                  if(sharedPreferences.getString("paramVerification") == "3") {
                    sharedPreferences.setString("paramUserType", "1");
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => HomePage()));
                  } else if(sharedPreferences.getString("paramVerification") == "1") {
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => VerificationPage()));
                  } else if(sharedPreferences.getString("paramVerification") == "2") {
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
                                    "Вы уже подали заявку. Пожалуйста, ожидайте.",
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
                  }
                } else {
                  sharedPreferences.setString("paramUserType", "0");
                  Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => HomePage()));
                }
              },
              child: FutureBuilder(
                future: getParamCourier(),
                builder: (BuildContext context, AsyncSnapshot<dynamic> snapshot) {
                  if(snapshot.data == null) {
                    return Container(
                      height: 25,
                      width: 25,
                      child: CircularProgressIndicator(
                        color: AppColors.white,
                        strokeWidth: 2,
                      ),
                    );
                  } else {
                    return Container(
                      // mainAxisAlignment: MainAxisAlignment.start,
                      alignment: Alignment.centerLeft,
                      child: Text(
                        snapshot.data == "1" ? AppStrings.loginAsCustomer : AppStrings.loginAsCourier,
                      ),
                    );
                  }
                },
              )
            ),
            FutureBuilder(
              future: getParamVerify(),
              builder: (BuildContext context, AsyncSnapshot<dynamic> snapshot) {
                if(snapshot.data == "3") {
                  return Column(
                    children: [
                      SizedBox(height: 10.h),
                      ElevatedButton(
                        style: ButtonStyles.selectedButtonStyle.copyWith(
                          foregroundColor: MaterialStateProperty.all(AppColors.black),
                          backgroundColor: MaterialStateProperty.all(AppColors.fon),
                        ),
                        onPressed: () {
                          Navigator.push(context, MaterialPageRoute(builder: (context) => OrderPabPage()));
                        },
                        child: Container(
                          child: Text("История заказов"),
                          alignment: Alignment.centerLeft,
                        ),
                      ),
                    ],
                  );
                }

                return Container();
              },
            ),
            SizedBox(height: 10.h),
            ElevatedButton(
              style: ButtonStyles.selectedButtonStyle.copyWith(
                foregroundColor: MaterialStateProperty.all(AppColors.black),
                backgroundColor: MaterialStateProperty.all(AppColors.fon),
              ),
              onPressed: () {
                Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => HelpScreen()));
              },
              child: Container(
                child: Text(AppStrings.support),
                alignment: Alignment.centerLeft,
              ),
            ),
            SizedBox(height: 10.h),
            ElevatedButton(
              style: ButtonStyles.selectedButtonStyle.copyWith(
                foregroundColor: MaterialStateProperty.all(AppColors.black),
                backgroundColor: MaterialStateProperty.all(AppColors.fon),
              ),
              onPressed: () async {
                SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
                sharedPreferences.setString("tokenSystem", "");
                Navigator.pushReplacement(
                    context,
                    MaterialPageRoute(
                        builder: (context) => SplashPage()));
              },
              child: Container(
                child: Text(AppStrings.logOut),
                alignment: Alignment.centerLeft,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Future<String?> getParamVerify() async {
    SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
    return sharedPreferences.getString("paramVerification");
  }

  Future<String?> getParamCourier() async {
    SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
    return sharedPreferences.getString('paramUserType') == null ? "0" : sharedPreferences.getString('paramUserType');
  }

  Future<User?> postRequest() async {
    final prefs = await SharedPreferences.getInstance();
    final String? action = prefs.getString('tokenSystem');
    print(action);

    var response = await http.get(
        Uri.parse("https://marzy.ru/api/user/me"),
        headers: {
          "Auth": action!,
        },
    );

    var result = utf8.decode(response.bodyBytes);
    result = "[" + result.substring(0, result.length) + "]";
    final data = await json.decode(result);
    List<AccountItems> itemsList = List<AccountItems>.from(data.map((i) => AccountItems.fromJson(i)));
    print(itemsList[0].user!.phone);
    return itemsList[0].user;
  }

  Future<num?> postRequest1() async {
    final prefs = await SharedPreferences.getInstance();
    final String? action = prefs.getString('tokenSystem');
    print(action);

    var response = await http.get(
      Uri.parse("https://marzy.ru/api/user/me"),
      headers: {
        "Auth": action!,
      },
    );

    var result = utf8.decode(response.bodyBytes);
    result = "[" + result.substring(0, result.length) + "]";
    final data = await json.decode(result);
    List<AccountItems> itemsList = List<AccountItems>.from(data.map((i) => AccountItems.fromJson(i)));
    print(itemsList[0].user!.phone);
    return itemsList[0].rating!.rating;
  }
}

class AccountItems {
  String? status;
  String? message;
  User? user;
  Auth? auth;
  Rating? rating;

  AccountItems({this.status, this.message, this.user, this.auth, this.rating});

  AccountItems.fromJson(Map<String, dynamic> json) {
    status = json['status'];
    message = json['message'];
    user = json['user'] != null ? new User.fromJson(json['user']) : null;
    auth = json['auth'] != null ? new Auth.fromJson(json['auth']) : null;
    rating =
    json['rating'] != null ? new Rating.fromJson(json['rating']) : null;
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
    if (this.rating != null) {
      data['rating'] = this.rating!.toJson();
    }
    return data;
  }
}

class User {
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
  num? id;
  String? token;
  String? createDate;
  String? expireDate;
  num? accessType;
  num? userId;
  num? status;
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

class Rating {
  num? ordersCount;
  num? rating;

  Rating({this.ordersCount, this.rating});

  Rating.fromJson(Map<String, dynamic> json) {
    ordersCount = json['orders_count'];
    rating = json['rating'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['orders_count'] = this.ordersCount;
    data['rating'] = this.rating;
    return data;
  }
}