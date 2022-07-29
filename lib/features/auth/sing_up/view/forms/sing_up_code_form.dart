import 'package:flutter/material.dart';
import 'package:marzy/features/auth/sing_up/providers/sing_up_provider.dart';
import 'package:marzy/shared/localization/strings_ru.dart';
import 'package:marzy/shared/presentation/colors.dart';
import 'package:marzy/shared/presentation/text_styles.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:marzy/shared/widgets/loaders.dart';

class SingUpCodeForm extends StatelessWidget {
  final SingUpProvider provider;
  SingUpCodeForm({
    Key? key,
    required this.provider,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        RichText(
          textAlign: TextAlign.center,
          text: TextSpan(
            text: AppStrings.reset1,
            style: AppTextStyles.interMed12,
            children: [
              TextSpan(
                text: provider.phone,
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
          onPressed: !provider.requestSend ? provider.submitCode : null,
          child: !provider.requestSend
              ? Text(AppStrings.continue2)
              : CircularLoader(),
        ),
      ],
    );
  }
}
