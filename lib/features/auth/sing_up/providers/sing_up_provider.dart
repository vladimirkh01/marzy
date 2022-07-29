import 'dart:async';
import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:marzy/features/auth/base/auth_provider.dart';

class SingUpProvider extends AuthProvider {
  late TextEditingController emailController;
  late TextEditingController phoneController;
  late TextEditingController passwordController;
  late TextEditingController passwordRepeatController;
  late TextEditingController codeController;
  late TextEditingController sureNameController;
  late TextEditingController nameController;
  late TextEditingController dateController;
  late Timer timer;
  late String errorString;
  late double posError;
  late int currentPage;

  SingUpProvider() {
    emailController = TextEditingController();
    phoneController = TextEditingController();
    passwordController = TextEditingController();
    passwordRepeatController = TextEditingController();
    codeController = TextEditingController();
    sureNameController = TextEditingController();
    nameController = TextEditingController();
    dateController = TextEditingController();
    errorString = "";
    posError = -300;
    currentPage = 0;
  }

  Future<void> submitLogin() async {
    String phoneString = phoneController.text;
    String passwordString = passwordController.text;

    Map data = {
      'phone': phoneString,
      'password': passwordString
    };

    postRequest("https://marzy.ru/api/user/reg", data).then((value) {
      final Map responseJson = json.decode(value);

      if(responseJson["status"] == "error") {
        posError = 0;
        errorString = responseJson["message"];

        timer = Timer(Duration(seconds: 3), () {
          posError = -300;
          timer.cancel();
          notifyListeners();
        });

        notifyListeners();
      }

      else next();
    });

  }

  Future<void> submitCode() async {
    String phoneString = phoneController.text;
    String codeString = codeController.text;

    Map data = {
      'phone': phoneString,
      'code': codeString
    };

    postRequest("https://marzy.ru/api/user/code/accept", data).then((value) {
      final Map responseJson = json.decode(value);

      if(responseJson["status"] == "error") {
        posError = 0;
        errorString = responseJson["message"];

        timer = Timer(Duration(seconds: 3), () {
          posError = -300;
          timer.cancel();
          notifyListeners();
        });

        notifyListeners();
      }

      else {
        next();
      }
    });

  }

  Future<void> submitPassword() async {
    next();
  }

  Future<void> submitData() async {
    next();
  }

  void back() {
    currentPage = currentPage - 1;
    notifyListeners();
  }

  void next() {
    currentPage = currentPage + 1;
    notifyListeners();
  }

  String get title {
    if (currentPage == 0) {
      return '1/4';
    } else if (currentPage == 1) {
      return '2/4';
    } else if (currentPage == 2) {
      return "3/4";
    }
    return '4/4';
  }

  String get phone {
    return phoneController.text;
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
