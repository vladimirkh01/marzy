import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:marzy/shared/images/images.dart';
import 'package:marzy/shared/presentation/colors.dart';
import 'package:marzy/shared/presentation/text_styles.dart';
import 'package:marzy/shared/widgets/custom_buttons.dart';

import './components/search_button.dart';
import './components/template_item.dart';

class TemplatesScreen extends StatelessWidget {
  static const String route = '/templates';
  const TemplatesScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: Padding(
          padding: const EdgeInsets.only(left: 10.0),
          child: CustomBackButton(),
        ),
        title: Text('Шаблоны'),
        // title: Container(
        //   width: 227.w,
        //   height: 40,
        //   decoration: BoxDecoration(
        //     color: AppColors.fon,
        //     borderRadius: BorderRadius.circular(8),
        //     border: Border.all(
        //       color: AppColors.fon,
        //       width: 0.001,
        //     ),
        //   ),
        //   child: Center(
        //     child: TextField(
        //       decoration: InputDecoration(
        //         prefixIcon: Icon(
        //           Icons.search,
        //           size: 18,
        //         ),
        //         hintText: 'Поиск',
        //         border: InputBorder.none,
        //         hintStyle: AppTextStyles.interMed14
        //             .copyWith(color: AppColors.blackGrey),
        //         focusColor: AppColors.fon,
        //         fillColor: AppColors.fon,
        //       ),
        //     ),
        //   ),
        // ),
        // actions: [
        //   Padding(
        //     padding: const EdgeInsets.only(right: 10.0),
        //     child: SearchButton(
        //       image: AppImages.searchButton,
        //       width: 48,
        //       height: 48,
        //     ),
        //   ),
        // ],
      ),
      body: Padding(
        padding: EdgeInsets.symmetric(
          horizontal: 20.w,
          vertical: 10.h,
        ),
        child: Column(children: [
          TemplateItem(),
          SizedBox(height: 20),
          TemplateItem(),
          Spacer(),
          ElevatedButton(
            onPressed: () {},
            style: ButtonStyle(
              minimumSize: MaterialStateProperty.all(
                Size(double.infinity, 40.h),
              ),
              shape: MaterialStateProperty.all(
                RoundedRectangleBorder(
                  borderRadius: BorderRadius.all(
                    Radius.circular(8.0),
                  ),
                ),
              ),
            ),
            child: Text(
              'Создать новый шаблон',
              style: AppTextStyles.interMed14.copyWith(color: AppColors.white),
            ),
          ),
          SizedBox(height: 20),
        ]),
      ),
    );
  }
}
