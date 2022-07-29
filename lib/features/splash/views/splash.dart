import 'package:flutter/material.dart';
import 'package:marzy/features/auth/sing_in/page/sing_in_page.dart';
import 'package:marzy/features/auth/sing_up/view/sing_up_page.dart';
import 'package:marzy/shared/images/images.dart';
import 'package:marzy/shared/localization/strings_ru.dart';
import 'package:marzy/shared/presentation/text_styles.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:marzy/shared/widgets/custom_buttons.dart';

class SplashPage extends StatelessWidget {
  const SplashPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xFFFCFCFC),
      body: Stack(
        children: [
          Center(
            child: Container(
              width: MediaQuery.of(context).size.width,
              height: MediaQuery.of(context).size.height,
              // margin: EdgeInsets.only(top: MediaQuery.of(context).size.height / 2),
              decoration: BoxDecoration(
                color: Color(0xFFFCFCFC),
                image: DecorationImage(
                  fit: BoxFit.fitWidth,
                  image: AssetImage(
                    "assets/images/marzy_logo.jpg"
                  ),
                )
              ),
            ),
          ),
          SafeArea(
            child: Padding(
              padding: EdgeInsets.symmetric(horizontal: 20.w),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  // Text(
                  //   AppStrings.appName,
                  //   style: AppTextStyles.interSemiBold64,
                  // ),
                  SizedBox(height: 30.h),
                  ElevatedButton(
                    onPressed: () {
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => SingInPage()));
                    },
                    child: Text(AppStrings.singIn),
                  ),
                  SizedBox(height: 11.h),
                  CustomButton(onTap: () {
                    Navigator.push(context,
                        MaterialPageRoute(builder: (context) => SingUpPage()));
                  }),
                  SizedBox(height: 11.h),
                ],
              ),
            ),
          )
        ],
      ),
    );
  }
}
