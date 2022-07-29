import 'package:flutter/material.dart';
import 'package:marzy/features/auth/sing_up/providers/sing_up_provider.dart';
import 'package:marzy/shared/localization/strings_ru.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:marzy/shared/widgets/custom_text_field.dart';
import 'package:marzy/shared/widgets/loaders.dart';

class SingUpLoginForm extends StatelessWidget {
  final SingUpProvider provider;
  const SingUpLoginForm({
    Key? key,
    required this.provider
  }) : super(key: key);


  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        CustomTextField(
          title: AppStrings.phoneNumber,
          controller: provider.phoneController,
          validator: (value) {
            return provider.loginError;
          },
          obscureText: false,
        ),
        SizedBox(height: 16.h),
        CustomTextField(
          title: AppStrings.password,
          obscureText: true,
          validator: (value) {
            return provider.loginError;
          },
          controller: provider.passwordController,
        ),
        SizedBox(height: 6.h),
        AnimatedOpacity(
          duration: Duration(seconds: 1),
          curve: Curves.easeInOutExpo,
          opacity: provider.posError == -300 ? 0.0 : 1.0,
          child: SizedBox(
            width: 100.w,
            height: 15.h,
            child: Stack(
              children: <Widget>[
                AnimatedPositioned(
                  left: provider.posError,
                  duration: Duration(seconds: 1),
                  curve: Curves.easeInOutExpo,
                  child: Text(
                    provider.errorString,
                    style: TextStyle(
                        color: Colors.red
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
        SizedBox(height: 12.h),
        ElevatedButton(
          onPressed: !provider.requestSend
              ? () {
                  provider.submitLogin();
                }
              : null,
          child: !provider.requestSend
              ? Text(AppStrings.continue2)
              : CircularLoader(),
        ),
      ],
    );
  }
}
