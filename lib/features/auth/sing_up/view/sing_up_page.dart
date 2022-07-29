import 'package:flutter/material.dart';
import 'package:marzy/features/auth/sing_up/providers/sing_up_provider.dart';
import 'package:marzy/features/auth/sing_up/view/forms/sing_up_code_form.dart';
import 'package:marzy/features/auth/sing_up/view/forms/sing_up_data_form.dart';
import 'package:marzy/features/auth/sing_up/view/forms/sing_up_login_form.dart';
import 'package:marzy/features/auth/sing_up/view/forms/sing_up_map_form.dart';
import 'package:marzy/shared/widgets/counter_widget.dart';
import 'package:marzy/shared/localization/strings_ru.dart';
import 'package:marzy/shared/widgets/custom_buttons.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:provider/provider.dart';

class SingUpPage extends StatelessWidget {
  SingUpPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (context) => SingUpProvider(),
      child: Builder(
        builder: (BuildContext context) {
          final provider = context.watch<SingUpProvider>();
          Widget body = SingUpLoginForm(provider: provider);
          if (provider.currentPage == 0) {
            body = SingUpLoginForm(provider: provider);
          }
          if (provider.currentPage == 1) {
            body = SingUpCodeForm(provider: provider);
          }
          if (provider.currentPage == 2) {
            body = SingUpDataForm(provider: provider);
          }
          if (provider.currentPage == 3) {
            body = SingUpMap(provider: provider);
          }

          return Scaffold(
            appBar: AppBar(
              title: Text(AppStrings.register),
              automaticallyImplyLeading: false,
              leading: CustomBackButtonAuth(
                onTap: () {
                  if (provider.currentPage == 0) {
                    Navigator.pop(context);
                  } else {
                    provider.back();
                  }
                },
              ),
              actions: [
                CounterWidget(
                  title: provider.title,
                ),
              ],
            ),
            body: Padding(
              padding: EdgeInsets.symmetric(horizontal: 20.w, vertical: 20.h),
              child: Form(
                autovalidateMode: AutovalidateMode.always,
                child: body,
              ),
            ),
          );
        },
      ),
    );
  }
}
