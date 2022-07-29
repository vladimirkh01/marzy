import 'package:flutter/material.dart';
import 'package:marzy/features/auth/reset_password/views/reset_password_page.dart';
import 'package:marzy/shared/presentation/text_styles.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:marzy/shared/widgets/custom_buttons.dart';

class CustomTextField extends StatelessWidget {
  final String title;
  final TextEditingController controller;
  final FormFieldValidator<String>? validator;
  final bool obscureText;
  const CustomTextField({
    Key? key,
    required this.title,
    required this.controller,
    required this.validator,
    required this.obscureText,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Text(
          title,
          style: AppTextStyles.interMed12,
        ),
        SizedBox(height: 4.h),
        TextFormField(
          obscureText: obscureText,
          controller: controller,
          validator: validator,
        ),
      ],
    );
  }
}

class PasswordTextField extends StatelessWidget {
  final String title;
  final TextEditingController controller;
  final FormFieldValidator<String>? validator;
  final bool obscureText;
  const PasswordTextField({
    Key? key,
    required this.title,
    required this.controller,
    required this.validator,
    required this.obscureText,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              title,
              style: AppTextStyles.interMed12,
            ),
            CustomTextButton(
              onPressed: () {
                Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => ResetPasswordPage()));
              },
            ),
          ],
        ),
        TextFormField(
          obscureText: obscureText,
          controller: controller,
          validator: validator,
        ),
      ],
    );
  }
}
