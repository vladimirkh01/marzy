import 'package:flutter/material.dart';
import 'package:marzy/features/auth/reset_password/providers/reset_password_provider.dart';
import 'package:marzy/shared/localization/strings_ru.dart';
import 'package:marzy/shared/presentation/colors.dart';
import 'package:marzy/shared/presentation/text_styles.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:marzy/shared/widgets/loaders.dart';

class ResetPasswordCodeForm extends StatelessWidget {
  final ResetPasswordProvider provider;
  ResetPasswordCodeForm({
    Key? key,
    required this.provider,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 20.w, vertical: 30.h),
      child: Form(
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
                    text: provider.login,
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
              controller: provider.codeController,
              validator: (value) {
                return provider.codeError;
              },
              obscureText: false,
            ),
            SizedBox(height: 100.h),
            ElevatedButton(
              onPressed: !provider.requestSend ? provider.submitCode : null,
              child: !provider.requestSend
                  ? Text(AppStrings.continue2)
                  : CircularLoader(),
            ),
          ],
        ),
      ),
    );
  }
}
