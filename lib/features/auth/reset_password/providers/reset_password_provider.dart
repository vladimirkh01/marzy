import 'package:flutter/material.dart';
import 'package:marzy/features/auth/base/auth_provider.dart';
import 'package:marzy/shared/enums/AppEnums.dart';

class ResetPasswordProvider extends AuthProvider {
  late TextEditingController loginController;
  late TextEditingController passwordController;
  late TextEditingController passwordRepeatController;
  late TextEditingController codeController;
  late int currentPage;
  late String login;

  ResetPasswordProvider() {
    loginController = TextEditingController();
    passwordController = TextEditingController();
    passwordRepeatController = TextEditingController();
    codeController = TextEditingController();
    login = '';
    currentPage = 0;
  }

  Future<void> submitLogin() async {
    removeError(AuthErrorsTypes.login);
    String text = loginController.text;
    if (text.isEmpty) {
      addError(type: AuthErrorsTypes.login, error: "error");
    } else {
      next();
    }
  }

  Future<void> submitCode() async {
    next();
  }

  Future<void> submitPassword({required Function onSuccess}) async {
    // passwordError.value = 'dsad';
    // passwordRepeatError.value = 'dsad';
    // formKeyPassword.currentState!.validate();
    // Get.offNamedUntil(SingInPage.route, (route) => false);
    onSuccess();
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
      return '1/3';
    } else if (currentPage == 1) {
      return '2/3';
    }
    return '3/3';
  }
}
