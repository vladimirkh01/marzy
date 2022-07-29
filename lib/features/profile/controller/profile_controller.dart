import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:marzy/features/auth/verification/page/verification_screen.dart';
import 'package:marzy/features/home/page/home.dart';
import 'package:marzy/features/profile/page/profile_edit_complete.dart';
import 'package:marzy/features/profile/page/profile_edit_confirm.dart';
import 'package:marzy/features/profile/page/profile_edit_verify.dart';
import 'package:marzy/shared/enums/AppEnums.dart';

class ProfileController extends GetxController {
  late TextEditingController codeController;
  late TextEditingController emailController;
  late TextEditingController phoneController;

  late GlobalKey<FormState> formKeyCode;
  late GlobalKey<FormState> formKeyLogin;

  var codeError = RxnString();
  var phoneError = RxnString();

  var submittingCode = false.obs;
  var submittingLogin = false.obs;

  late String phone;

  @override
  void onInit() {
    super.onInit();
    codeController = TextEditingController();
    emailController = TextEditingController();
    phoneController = TextEditingController();

    formKeyCode = GlobalKey<FormState>();
    formKeyLogin = GlobalKey<FormState>();

    phone = '+7 920 222 22 22';
  }

  Future<void> editEmail() async {
    Get.toNamed(ProfileEditConfirmPage.route,
        arguments: AccountEditingType.email);
  }

  Future<void> editPhoneNumber() async {
    Get.toNamed(ProfileEditConfirmPage.route,
        arguments: AccountEditingType.phone);
  }

  Future<void> verifyCode(AccountEditingType aet) async {
    Get.toNamed(ProfileEditVerifyPage.route, arguments: aet);
  }

  Future<void> submitCode(AccountEditingType aet) async {
    // codeError.value = 'Not completed';
    // formKeyCode.currentState!.validate();
    Get.toNamed(ProfileEditCompletePage.route, arguments: aet);
  }

  Future<void> submitLoginOrPhone() async {
    if (!formKeyLogin.currentState!.validate()) return;

    submittingLogin.value = true;
    await Future.delayed(Duration(seconds: 1));

    submittingLogin.value = false;
    // Get.offAllNamed(HomePage.route);
    try {
      submittingLogin.value = false;

      formKeyLogin.currentState!.validate();
    } catch (e) {
      print(e);
      formKeyLogin.currentState!.validate();
    } finally {
      submittingLogin.value = false;
    }
  }

  void sigInAsCourier() {
    // Get.toNamed(VerificationPage.route);
  }
}
