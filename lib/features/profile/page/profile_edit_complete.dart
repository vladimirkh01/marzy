import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:marzy/features/profile/controller/profile_controller.dart';
import 'package:marzy/shared/enums/AppEnums.dart';
import 'package:marzy/shared/widgets/counter_widget.dart';
import 'package:marzy/shared/localization/strings_ru.dart';
import 'package:marzy/shared/widgets/custom_buttons.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:marzy/shared/widgets/custom_text_field.dart';
import 'package:marzy/shared/widgets/loaders.dart';

class ProfileEditCompletePage extends GetView<ProfileController> {
  static const route = '/profile_edit_complete';
  final AccountEditingType email;
  ProfileEditCompletePage({Key? key, required this.email}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final editingType = email;
    return Scaffold(
      appBar: AppBar(
        title: Text(editingType.title),
        automaticallyImplyLeading: false,
        leading: CustomBackButton(),
        actions: [
          CounterWidget(
            title: '3/3',
            width: 30.w,
            height: 30.w,
          ),
        ],
      ),
      body: Padding(
        padding: EdgeInsets.symmetric(horizontal: 20.w, vertical: 20.h),
        child: Form(
          key: controller.formKeyLogin,
          autovalidateMode: AutovalidateMode.always,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              if (editingType.title == AccountEditingType.phone.title)
                CustomTextField(
                  title: AppStrings.phoneNumber,
                  controller: controller.phoneController,
                  validator: (value) {
                    return controller.phoneError.value;
                  },
                  obscureText: false,
                )
              else
                CustomTextField(
                  title: AppStrings.email,
                  obscureText: true,
                  validator: (value) {
                    return null;
                  },
                  controller: controller.emailController,
                ),
              Spacer(flex: 2),
              Obx(
                () => ElevatedButton(
                  onPressed: controller.submittingLogin.isFalse
                      ? controller.submitLoginOrPhone
                      : null,
                  child: controller.submittingLogin.isFalse
                      ? Text(AppStrings.continue2)
                      : CircularLoader(),
                ),
              ),
              Spacer(flex: 6),
            ],
          ),
        ),
      ),
    );
  }
}
