import 'dart:async';
import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:marzy/features/auth/sing_in/providers/sing_in_provider.dart';
import 'package:marzy/features/home/page/home.dart';
import 'package:marzy/shared/localization/strings_ru.dart';
import 'package:marzy/shared/widgets/custom_buttons.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:marzy/shared/widgets/custom_text_field.dart';
import 'package:marzy/shared/widgets/loaders.dart';
import 'package:provider/provider.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

class SingInPage extends StatefulWidget {
  SingInPage({Key? key}) : super(key: key);

  @override
  State<SingInPage> createState() => _SingInPageState();
}

class _SingInPageState extends State<SingInPage> {
  late TextEditingController _loginController;
  late TextEditingController _passwordController;
  Timer? timer;
  bool? statusLoadData = false;
  double posError = -300;
  String? errorString = "";
  String? loginString;
  String? passwordString;

  @override
  void initState() {
    _loginController = TextEditingController();
    _loginController.addListener(() => loginString = _loginController.text);

    _passwordController = TextEditingController();
    _passwordController.addListener(() => passwordString = _passwordController.text);

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    var request = http.Request('POST', Uri.parse('https://marzy.ru/api/user/auth'));
    request.body = '''{\r\n    "phone": "$_loginController",\r\n    "password": "$_passwordController"\r\n}''';

    return ChangeNotifierProvider(
      create: (BuildContext context) => SingInProvider(),
      child: Scaffold(
        appBar: AppBar(
          title: Text(AppStrings.login),
          automaticallyImplyLeading: false,
          leading: CustomBackButton(),
        ),
        body: Builder(
          builder: (BuildContext context) {
            var provider = context.watch<SingInProvider>();
            return Padding(
              padding: EdgeInsets.symmetric(horizontal: 20.w, vertical: 20.h),
              child: Form(
                autovalidateMode: AutovalidateMode.always,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    CustomTextField(
                      title: AppStrings.phoneOrEmail,
                      controller: _loginController,
                      validator: (value) {
                        return null;
                      },
                      obscureText: false,
                    ),
                    SizedBox(height: 16.h),
                    PasswordTextField(
                      title: AppStrings.password,
                      obscureText: true,
                      validator: (value) {
                        return null;
                      },
                      controller: _passwordController,
                    ),
                    SizedBox(height: 6.h),
                    AnimatedOpacity(
                      duration: Duration(seconds: 1),
                      curve: Curves.easeInOutExpo,
                      opacity: posError == -300 ? 0.0 : 1.0,
                      child: SizedBox(
                        width: 100.w,
                        height: 15.h,
                        child: Stack(
                          children: <Widget>[
                            AnimatedPositioned(
                              left: posError,
                              duration: Duration(seconds: 1),
                              curve: Curves.easeInOutExpo,
                              child: Text(
                                errorString!,
                                style: TextStyle(
                                    color: Colors.red
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                    SizedBox(height: 32.h),
                    ElevatedButton(
                      onPressed: provider.requestSend
                          ? null
                          : () async {

                        setState(() => statusLoadData = true);

                        Map data = {
                          'phone': loginString,
                          'password': passwordString
                        };

                        postRequest("https://marzy.ru/api/user/auth", data).then((value) {
                          final Map responseJson = json.decode(value);
                          print(responseJson);
                          setState(() => statusLoadData = false);
                          print(postRequestAdditional(value));

                          if(responseJson["status"] == "error") {
                            setState(() {
                              posError = 0;
                              errorString = responseJson["message"];
                            });

                            timer = Timer(Duration(seconds: 3), () {
                              setState(() => posError = -300);
                              timer!.cancel();
                            });
                          }
                          else {
                            Navigator.pushAndRemoveUntil(
                                context,
                                MaterialPageRoute(
                                    builder: (context) => HomePage()),
                                    (route) => false
                            );
                          }
                        });
                          },
                      child: statusLoadData! ? CircularLoader() : Text(AppStrings.singIn),
                    ),
                  ],
                ),
              ),
            );
          },
        ),
      ),
    );
  }

  Future<String?> postRequestAdditional(var result) async {
    result = "[" + result.substring(0, result.length) + "]";
    final data = await json.decode(result);
    List<AuthItemsAdditonal> itemsList = List<AuthItemsAdditonal>.from(data.map((i) => AuthItemsAdditonal.fromJson(i)));
    print("TokenSystem: ${itemsList[0].tokens!.customer!.token.toString()}");
    print("TokenSystem1: ${itemsList[0].tokens!.executor!.token.toString()}");
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString('accessType', itemsList[0].tokens!.executor!.accessType.toString());
    await prefs.setString('tokenSystem', itemsList[0].tokens!.customer!.token.toString());
    await prefs.setString('tokenSystem1', itemsList[0].tokens!.executor!.token.toString());
    return itemsList[0].tokens!.customer!.token;
  }

  Future<String> postRequest (String uri, Map data) async {
    var body = json.encode(data);

    var response = await http.post(
        Uri.parse(uri),
        headers: {"Content-Type": "application/json"},
        body: body
    );

    String bodyUTF8 = utf8.decode(response.bodyBytes);

    print("${response.statusCode}");
    print(bodyUTF8);

    return bodyUTF8;
  }
}

class AuthItemsAdditonal {
  String? status;
  String? message;
  int? userId;
  Tokens? tokens;

  AuthItemsAdditonal({this.status, this.message, this.userId, this.tokens});

  AuthItemsAdditonal.fromJson(Map<String, dynamic> json) {
    status = json['status'];
    message = json['message'];
    userId = json['user_id'];
    tokens =
    json['tokens'] != null ? new Tokens.fromJson(json['tokens']) : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['status'] = this.status;
    data['message'] = this.message;
    data['user_id'] = this.userId;
    if (this.tokens != null) {
      data['tokens'] = this.tokens!.toJson();
    }
    return data;
  }
}

class Tokens {
  Customer? customer;
  Customer? executor;

  Tokens({this.customer, this.executor});

  Tokens.fromJson(Map<String, dynamic> json) {
    customer = json['customer'] != null
        ? new Customer.fromJson(json['customer'])
        : null;
    executor = json['executor'] != null
        ? new Customer.fromJson(json['executor'])
        : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    if (this.customer != null) {
      data['customer'] = this.customer!.toJson();
    }
    if (this.executor != null) {
      data['executor'] = this.executor!.toJson();
    }
    return data;
  }
}

class Customer {
  int? id;
  String? token;
  String? createDate;
  String? expireDate;
  int? accessType;
  int? userId;
  int? status;
  String? qAccessTypeText;
  String? qStatus;

  Customer(
      {this.id,
        this.token,
        this.createDate,
        this.expireDate,
        this.accessType,
        this.userId,
        this.status,
        this.qAccessTypeText,
        this.qStatus});

  Customer.fromJson(Map<String, dynamic> json) {
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
