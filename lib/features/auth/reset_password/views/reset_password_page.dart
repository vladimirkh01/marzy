import 'package:flutter/material.dart';
import 'package:marzy/features/auth/reset_password/providers/reset_password_provider.dart';
import 'package:marzy/features/auth/reset_password/views/forms/reset_password_code_form.dart';
import 'package:marzy/features/auth/reset_password/views/forms/reset_password_form.dart';
import 'package:marzy/features/auth/reset_password/views/forms/reset_password_phone_form.dart';
import 'package:marzy/shared/localization/strings_ru.dart';
import 'package:marzy/shared/widgets/counter_widget.dart';
import 'package:marzy/shared/widgets/custom_buttons.dart';
import 'package:provider/provider.dart';

class ResetPasswordPage extends StatelessWidget {
  const ResetPasswordPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (context) => ResetPasswordProvider(),
      child: Builder(
        builder: (BuildContext context) {
          final provider = context.watch<ResetPasswordProvider>();
          Widget body = ResetPasswordEmailForm(provider: provider);
          if (provider.currentPage == 0) {
            body = ResetPasswordEmailForm(provider: provider);
          }
          if (provider.currentPage == 1) {
            body = ResetPasswordCodeForm(provider: provider);
          }
          if (provider.currentPage == 2) {
            body = ResetPasswordForm(provider: provider);
          }

          return Scaffold(
            appBar: AppBar(
              title: Text(AppStrings.restorePassword),
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
                CounterWidget(title: provider.title),
              ],
            ),
            body: body,
          );
        },
      ),
    );
  }
}
