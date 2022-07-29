import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:marzy/shared/widgets/counter_widget.dart';
import 'package:marzy/features/profile/controller/profile_controller.dart';
import 'package:marzy/shared/enums/AppEnums.dart';
import 'package:marzy/shared/localization/strings_ru.dart';
import 'package:marzy/shared/presentation/colors.dart';
import 'package:marzy/shared/presentation/text_styles.dart';
import 'package:marzy/shared/widgets/custom_buttons.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:marzy/shared/widgets/loaders.dart';

class ProfileEditVerifyPage extends GetView<ProfileController> {
  static const route = '/profile_edit_verify';

  ProfileEditVerifyPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final editingType = Get.arguments as AccountEditingType;
    return Scaffold(
      appBar: AppBar(
        title: Text(editingType.title),
        automaticallyImplyLeading: false,
        leading: CustomBackButton(),
        actions: [
          CounterWidget(
            title: '2/3',
            width: 30.w,
            height: 30.w,
          ),
        ],
      ),
      body: Padding(
        padding: EdgeInsets.symmetric(horizontal: 20.w, vertical: 30.h),
        child: Form(
          key: controller.formKeyCode,
          autovalidateMode: AutovalidateMode.always,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              RichText(
                textAlign: TextAlign.center,
                text: TextSpan(
                  text: AppStrings.reset1,
                  style: AppTextStyles.interMed12,
                  children: [
                    TextSpan(
                      text: controller.phone,
                      style: AppTextStyles.interMed12.copyWith(
                        color: AppColors.accent,
                      ),
                    ),
                    TextSpan(
                      text: AppStrings.reset2,
                      style: AppTextStyles.interMed12,
                    ),
                  ],
                ),
              ),
              SizedBox(height: 20.h),
              TextFormField(
                controller: controller.codeController,
                validator: (value) {
                  return controller.codeError.value;
                },
                obscureText: false,
              ),
              Spacer(flex: 2),
              ElevatedButton(
                onPressed: controller.submittingCode.isFalse
                    ? () {
                        controller.submitCode(editingType);
                      }
                    : null,
                child: controller.submittingCode.isFalse
                    ? Text(AppStrings.continue2)
                    : CircularLoader(),
              ),
              Spacer(flex: 8),
            ],
          ),
        ),
      ),
    );
  }
}
