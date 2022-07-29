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

class ProfileEditConfirmPage extends GetView<ProfileController> {
  static const route = '/profile_edit_confirm';
  const ProfileEditConfirmPage({Key? key}) : super(key: key);

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
            title: '1/3',
            width: 30.w,
            height: 30.w,
          ),
        ],
      ),
      body: Padding(
        padding: EdgeInsets.symmetric(horizontal: 20.w, vertical: 30.h),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Text(
              editingType.edit1Subtitle,
              textAlign: TextAlign.center,
              style: AppTextStyles.interMed12.copyWith(color: AppColors.black),
            ),
            Spacer(flex: 2),
            ElevatedButton(
              onPressed: () {
                controller.verifyCode(editingType);
              },
              child: Text(AppStrings.confirm),
            ),
            Spacer(flex: 5),
          ],
        ),
      ),
    );
  }
}
