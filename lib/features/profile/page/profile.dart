import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:marzy/features/auth/verification/page/verification_screen.dart';
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
            ProfileItem(
              text: "4.73",
              hint: "Рейтинг",
              onClick: () {
                print("Tapped profile item Рейтинг");
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
              onPressed: () => null,
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
}

class AccountItems {
  String? _status;
  String? _message;
  User? _user;
  Auth? _auth;

  AccountItems({String? status, String? message, User? user, Auth? auth}) {
    if (status != null) {
      this._status = status;
    }
    if (message != null) {
      this._message = message;
    }
    if (user != null) {
      this._user = user;
    }
    if (auth != null) {
      this._auth = auth;
    }
  }

  String? get status => _status;
  set status(String? status) => _status = status;
  String? get message => _message;
  set message(String? message) => _message = message;
  User? get user => _user;
  set user(User? user) => _user = user;
  Auth? get auth => _auth;
  set auth(Auth? auth) => _auth = auth;

  AccountItems.fromJson(Map<String, dynamic> json) {
    _status = json['status'];
    _message = json['message'];
    _user = json['user'] != null ? new User.fromJson(json['user']) : null;
    _auth = json['auth'] != null ? new Auth.fromJson(json['auth']) : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['status'] = this._status;
    data['message'] = this._message;
    if (this._user != null) {
      data['user'] = this._user!.toJson();
    }
    if (this._auth != null) {
      data['auth'] = this._auth!.toJson();
    }
    return data;
  }
}

class User {
  int? _id;
  String? _phone;
  String? _email;
  String? _surname;
  String? _name;
  String? _secondName;
  String? _createDate;
  int? _createDateTimestamp;
  int? _activateStatus;
  String? _activateStatusStr;

  User(
      {int? id,
        String? phone,
        String? email,
        String? surname,
        String? name,
        String? secondName,
        String? createDate,
        int? createDateTimestamp,
        int? activateStatus,
        String? activateStatusStr}) {
    if (id != null) {
      this._id = id;
    }
    if (phone != null) {
      this._phone = phone;
    }
    if (email != null) {
      this._email = email;
    }
    if (surname != null) {
      this._surname = surname;
    }
    if (name != null) {
      this._name = name;
    }
    if (secondName != null) {
      this._secondName = secondName;
    }
    if (createDate != null) {
      this._createDate = createDate;
    }
    if (createDateTimestamp != null) {
      this._createDateTimestamp = createDateTimestamp;
    }
    if (activateStatus != null) {
      this._activateStatus = activateStatus;
    }
    if (activateStatusStr != null) {
      this._activateStatusStr = activateStatusStr;
    }
  }

  int? get id => _id;
  set id(int? id) => _id = id;
  String? get phone => _phone;
  set phone(String? phone) => _phone = phone;
  String? get email => _email;
  set email(String? email) => _email = email;
  String? get surname => _surname;
  set surname(String? surname) => _surname = surname;
  String? get name => _name;
  set name(String? name) => _name = name;
  String? get secondName => _secondName;
  set secondName(String? secondName) => _secondName = secondName;
  String? get createDate => _createDate;
  set createDate(String? createDate) => _createDate = createDate;
  int? get createDateTimestamp => _createDateTimestamp;
  set createDateTimestamp(int? createDateTimestamp) =>
      _createDateTimestamp = createDateTimestamp;
  int? get activateStatus => _activateStatus;
  set activateStatus(int? activateStatus) => _activateStatus = activateStatus;
  String? get activateStatusStr => _activateStatusStr;
  set activateStatusStr(String? activateStatusStr) =>
      _activateStatusStr = activateStatusStr;

  User.fromJson(Map<String, dynamic> json) {
    _id = json['id'];
    _phone = json['phone'];
    _email = json['email'];
    _surname = json['surname'];
    _name = json['name'];
    _secondName = json['second_name'];
    _createDate = json['create_date'];
    _createDateTimestamp = json['create_date_timestamp'];
    _activateStatus = json['activate_status'];
    _activateStatusStr = json['activate_status_str'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this._id;
    data['phone'] = this._phone;
    data['email'] = this._email;
    data['surname'] = this._surname;
    data['name'] = this._name;
    data['second_name'] = this._secondName;
    data['create_date'] = this._createDate;
    data['create_date_timestamp'] = this._createDateTimestamp;
    data['activate_status'] = this._activateStatus;
    data['activate_status_str'] = this._activateStatusStr;
    return data;
  }
}

class Auth {
  int? _id;
  String? _token;
  String? _createDate;
  String? _expireDate;
  int? _accessType;
  int? _userId;
  int? _status;
  String? _qAccessTypeText;
  String? _qStatus;

  Auth(
      {int? id,
        String? token,
        String? createDate,
        String? expireDate,
        int? accessType,
        int? userId,
        int? status,
        String? qAccessTypeText,
        String? qStatus}) {
    if (id != null) {
      this._id = id;
    }
    if (token != null) {
      this._token = token;
    }
    if (createDate != null) {
      this._createDate = createDate;
    }
    if (expireDate != null) {
      this._expireDate = expireDate;
    }
    if (accessType != null) {
      this._accessType = accessType;
    }
    if (userId != null) {
      this._userId = userId;
    }
    if (status != null) {
      this._status = status;
    }
    if (qAccessTypeText != null) {
      this._qAccessTypeText = qAccessTypeText;
    }
    if (qStatus != null) {
      this._qStatus = qStatus;
    }
  }

  int? get id => _id;
  set id(int? id) => _id = id;
  String? get token => _token;
  set token(String? token) => _token = token;
  String? get createDate => _createDate;
  set createDate(String? createDate) => _createDate = createDate;
  String? get expireDate => _expireDate;
  set expireDate(String? expireDate) => _expireDate = expireDate;
  int? get accessType => _accessType;
  set accessType(int? accessType) => _accessType = accessType;
  int? get userId => _userId;
  set userId(int? userId) => _userId = userId;
  int? get status => _status;
  set status(int? status) => _status = status;
  String? get qAccessTypeText => _qAccessTypeText;
  set qAccessTypeText(String? qAccessTypeText) =>
      _qAccessTypeText = qAccessTypeText;
  String? get qStatus => _qStatus;
  set qStatus(String? qStatus) => _qStatus = qStatus;

  Auth.fromJson(Map<String, dynamic> json) {
    _id = json['id'];
    _token = json['token'];
    _createDate = json['create_date'];
    _expireDate = json['expire_date'];
    _accessType = json['access_type'];
    _userId = json['user_id'];
    _status = json['status'];
    _qAccessTypeText = json['q_access_type_text'];
    _qStatus = json['q_status'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this._id;
    data['token'] = this._token;
    data['create_date'] = this._createDate;
    data['expire_date'] = this._expireDate;
    data['access_type'] = this._accessType;
    data['user_id'] = this._userId;
    data['status'] = this._status;
    data['q_access_type_text'] = this._qAccessTypeText;
    data['q_status'] = this._qStatus;
    return data;
  }
}
