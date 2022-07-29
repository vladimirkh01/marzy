import 'package:flutter/material.dart';
import 'package:marzy/features/auth/sing_up/providers/sing_up_provider.dart';
import 'package:marzy/shared/localization/strings_ru.dart';
import 'package:marzy/shared/widgets/custom_text_field.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:marzy/shared/widgets/loaders.dart';

class SingUpDataForm extends StatelessWidget {
  final SingUpProvider provider;
  const SingUpDataForm({
    Key? key,
    required this.provider,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        CustomTextField(
          title: AppStrings.sureName,
          controller: provider.sureNameController,
          validator: (value) {
            return provider.sureNameError;
          },
          obscureText: false,
        ),
        SizedBox(height: 16.h),
        CustomTextField(
          title: AppStrings.name,
          controller: provider.nameController,
          validator: (value) {
            return provider.nameError;
          },
          obscureText: false,
        ),
        SizedBox(height: 16.h),
        CustomTextField(
          title: AppStrings.dateOfBirth,
          controller: provider.dateController,
          validator: (value) {
            return provider.dateError;
          },
          obscureText: false,
        ),
        SizedBox(height: 100.h),
        ElevatedButton(
          onPressed: !provider.requestSend ? provider.submitData : null,
          child: !provider.requestSend
              ? Text(AppStrings.continue2)
              : CircularLoader(),
        ),
      ],
    );
  }
}
