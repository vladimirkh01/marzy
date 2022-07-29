import 'package:flutter/material.dart';
import 'package:marzy/shared/presentation/button_styles.dart';
import 'package:marzy/shared/presentation/colors.dart';
import 'package:marzy/shared/presentation/text_styles.dart';

class AppThemes {
  static var kElevationButtonTheme = ElevatedButtonThemeData(
    style: ButtonStyles.button1,
  );

  static var kTextTheme = TextTheme(
    subtitle1: AppTextStyles.interReg16,
  );

  static var kAppBarTheme = AppBarTheme(
    centerTitle: true,
    color: Colors.white,
    elevation: 0.0,
    titleTextStyle: AppTextStyles.interSemiBold20,
    toolbarTextStyle: AppTextStyles.interSemiBold20,
  );

  static var kInputDecorationTheme = InputDecorationTheme(
    filled: false,
    labelStyle: AppTextStyles.interReg16,
    contentPadding: EdgeInsets.symmetric(horizontal: 12, vertical: 12),
    hintStyle: AppTextStyles.interReg16.copyWith(color: Colors.grey),
    focusedBorder: kInputDecorationBorder,
    disabledBorder: kInputDecorationBorder,
    errorMaxLines: 4,
    errorBorder: kInputDecorationBorder,
    enabledBorder: kInputDecorationBorder,
    focusedErrorBorder: kInputDecorationBorder,
    border: kInputDecorationBorder,
  );

  static const kInputDecorationBorder = OutlineInputBorder(
    borderRadius: BorderRadius.all(
      Radius.circular(8),
    ),
    borderSide: BorderSide(
      color: AppColors.fonGrey,
    ),
  );

  static var textButtonTheme = TextButtonThemeData(
    style: ButtonStyles.textButtonStyle,
  );
}
