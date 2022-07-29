import 'package:flutter/material.dart';
import 'package:marzy/shared/presentation/text_styles.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'colors.dart';

class ButtonStyles {
  static var button1 = ButtonStyle(
    minimumSize: MaterialStateProperty.all(Size(150.w, 40.h)),
    textStyle: MaterialStateProperty.all(AppTextStyles.interMed14),
    foregroundColor: MaterialStateProperty.all(AppColors.white),
    backgroundColor: MaterialStateProperty.all(AppColors.accent),
    shape: MaterialStateProperty.all(
      RoundedRectangleBorder(
        borderRadius: BorderRadius.all(
          Radius.circular(8.0),
        ),
      ),
    ),
  );
  static var tabItemBtnSelected = ButtonStyle(
    elevation: MaterialStateProperty.all(0),
    minimumSize: MaterialStateProperty.all(Size(107.w, 33.h)),
    textStyle: MaterialStateProperty.all(AppTextStyles.interMed14),
    foregroundColor: MaterialStateProperty.all(AppColors.white),
    backgroundColor: MaterialStateProperty.all(AppColors.accent),
    shape: MaterialStateProperty.all(
      RoundedRectangleBorder(
        borderRadius: BorderRadius.all(
          Radius.circular(8.0),
        ),
      ),
    ),
  );

  static var tabItemBtnUnSelected = ButtonStyle(
    minimumSize: MaterialStateProperty.all(Size(107.w, 33.h)),
    textStyle: MaterialStateProperty.all(AppTextStyles.interMed14),
    foregroundColor: MaterialStateProperty.all(AppColors.blackGrey),
    backgroundColor: MaterialStateProperty.all(AppColors.fonGrey),
    elevation: MaterialStateProperty.all(0),
    shape: MaterialStateProperty.all(
      RoundedRectangleBorder(
        borderRadius: BorderRadius.all(
          Radius.circular(8.0),
        ),
      ),
    ),
  );

  static var button2 = tabItemBtnUnSelected.copyWith(
    minimumSize: MaterialStateProperty.all(Size(107.w, 40.h)),
    textStyle: MaterialStateProperty.all(AppTextStyles.interMed12),
    foregroundColor: MaterialStateProperty.all(AppColors.black),
  );

  static var selectedButtonStyle = ButtonStyle(
    padding: MaterialStateProperty.all(EdgeInsets.only(left: 20, right: 20)),
    minimumSize: MaterialStateProperty.all(Size(150, 50)),
    textStyle: MaterialStateProperty.all(
        AppTextStyles.interMed14.copyWith(color: AppColors.black)),
    foregroundColor: MaterialStateProperty.all(AppColors.white),
    backgroundColor: MaterialStateProperty.all(AppColors.accent),
    shape: MaterialStateProperty.all(
      RoundedRectangleBorder(
        borderRadius: BorderRadius.all(
          Radius.circular(8.0),
        ),
      ),
    ),
  );

  static var textButtonStyle = ButtonStyle(
    padding: MaterialStateProperty.all(EdgeInsets.only(left: 20, right: 20)),
    minimumSize: MaterialStateProperty.all(Size(150, 50)),
    textStyle: MaterialStateProperty.all(AppTextStyles.interReg14),
    foregroundColor: MaterialStateProperty.all(AppColors.black),
    backgroundColor: MaterialStateProperty.all(AppColors.white),
    shape: MaterialStateProperty.all(
      RoundedRectangleBorder(
        borderRadius: BorderRadius.all(
          Radius.circular(8.0),
        ),
      ),
    ),
  );
}
