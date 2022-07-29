import 'package:flutter/material.dart';
import 'package:marzy/features/auth/reset_password/providers/reset_password_provider.dart';
import 'package:marzy/shared/localization/strings_ru.dart';
import 'package:marzy/shared/widgets/custom_text_field.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:marzy/shared/widgets/loaders.dart';

class ResetPasswordEmailForm extends StatelessWidget {
  final ResetPasswordProvider provider;
  const ResetPasswordEmailForm({
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
            CustomTextField(
              title: AppStrings.phoneOrEmail,
              controller: provider.loginController,
              validator: (value) {
                return provider.loginError;
              },
              obscureText: false,
            ),
            SizedBox(height: 100.h),
            ElevatedButton(
              onPressed: !provider.requestSend ? provider.submitLogin : null,
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
