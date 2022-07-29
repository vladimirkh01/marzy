import 'package:flutter/material.dart';
import 'package:marzy/features/auth/sing_up/providers/sing_up_provider.dart';
import 'package:marzy/shared/localization/strings_ru.dart';
import 'package:marzy/shared/widgets/custom_text_field.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:marzy/shared/widgets/loaders.dart';

class SingUpPasswordForm extends StatelessWidget {
  final SingUpProvider provider;
  const SingUpPasswordForm({
    Key? key,
    required this.provider,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        CustomTextField(
          title: AppStrings.createPassword,
          controller: provider.passwordController,
          validator: (value) {
            return provider.passwordError;
          },
          obscureText: true,
        ),
        SizedBox(height: 16.h),
        CustomTextField(
          title: AppStrings.password,
          controller: provider.passwordRepeatController,
          validator: (value) {
            return provider.passwordRepeatError;
          },
          obscureText: true,
        ),
        SizedBox(height: 100.h),
        ElevatedButton(
          onPressed: !provider.requestSend ? provider.submitPassword : null,
          child: !provider.requestSend
              ? Text(AppStrings.continue2)
              : CircularLoader(),
        ),
      ],
    );
  }
}
