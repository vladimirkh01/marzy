import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';
import 'package:marzy/features/static/catalogs/catalogs.dart';
import 'package:marzy/shared/presentation/colors.dart';
import 'package:marzy/shared/presentation/text_styles.dart';

import './back_button.dart';

class CatalogDetailScreen extends StatelessWidget {
  static const String route = '/catalog_detail';
  final String urlImage;
  final String name;
  final String price;
  final String desc;
  final String value;

  CatalogDetailScreen({
    Key? key,
    required this.urlImage,
    required this.name,
    required this.price,
    required this.desc,
    required this.value
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: buildAppBar(context),
      body: Padding(
        padding: const EdgeInsets.symmetric(
          horizontal: 20.0,
          vertical: 10,
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            urlImage.isEmpty ? Container(
              height: 314.h,
              decoration: BoxDecoration(
                color: AppColors.fonGrey,
                borderRadius: BorderRadius.circular(8),
              ),
            ) : Center(
              child: Container(
                height: 314.h,
                child: Image.network(
                  "$urlImage",
                  fit: BoxFit.contain,
                  loadingBuilder: (BuildContext context, Widget child,
                      ImageChunkEvent? loadingProgress) {
                    if (loadingProgress == null) return child;
                    return Center(
                      child: CircularProgressIndicator(
                        strokeWidth: 2,
                        color: AppColors.accent,
                        value: loadingProgress.expectedTotalBytes != null
                            ? loadingProgress.cumulativeBytesLoaded /
                            loadingProgress.expectedTotalBytes!
                            : null,
                      ),
                    );
                  },
                ),
              ),
            ),
            SizedBox(height: 15),
            Text(
              '$name',
              style: AppTextStyles.interReg16.copyWith(fontSize: 18),
            ),
            SizedBox(height: 20),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Row(
                  children: [
                    Container(
                      padding: const EdgeInsets.all(8),
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(4),
                        // color: Color.fromRGBO(51, 189, 138, 0.1),
                        color: AppColors.accent.withAlpha(10),
                      ),
                      child: Text(
                        '$price ₽',
                        style: AppTextStyles.interMed14
                            .copyWith(color: AppColors.accent),
                      ),
                    ),
                    SizedBox(width: 14),
                  ],
                ),
                // Row(
                //   mainAxisAlignment: MainAxisAlignment.spaceBetween,
                //   children: [
                //     Container(
                //       padding: const EdgeInsets.all(10),
                //       decoration: BoxDecoration(
                //         color: AppColors.fonGrey,
                //         borderRadius: BorderRadius.circular(43),
                //       ),
                //       child: Icon(
                //         Icons.remove,
                //         size: 20,
                //         color: AppColors.blackGrey,
                //       ),
                //     ),
                //     SizedBox(width: 26),
                //     Text(
                //       '$value',
                //       style: AppTextStyles.interMed14
                //           .copyWith(color: AppColors.black),
                //     ),
                //     SizedBox(width: 26),
                //     Container(
                //       padding: const EdgeInsets.all(10),
                //       decoration: BoxDecoration(
                //         color: AppColors.fonGrey,
                //         borderRadius: BorderRadius.circular(43),
                //       ),
                //       child: GestureDetector(
                //         onTap: () {
                //           CatalogScreenAdditionalState().changeBasketRemove(1, 1, int.parse(value));
                //         },
                //         child: Icon(
                //           Icons.add,
                //           size: 20,
                //           color: AppColors.blackGrey,
                //         ),
                //       ),
                //     ),
                //   ],
                // ),
              ],
            ),
            SizedBox(height: 20),
            Text(
              '$desc',
              style: AppTextStyles.interReg14.copyWith(fontSize: 18),
            ),
            Spacer(),
            // ElevatedButton(
            //   onPressed: () {},
            //   style: ButtonStyle(
            //     minimumSize: MaterialStateProperty.all(
            //       Size(double.infinity, 40),
            //     ),
            //     shape: MaterialStateProperty.all(
            //       RoundedRectangleBorder(
            //         borderRadius: BorderRadius.all(
            //           Radius.circular(8.0),
            //         ),
            //       ),
            //     ),
            //   ),
            //   child: Text(
            //     'Добавить в корзину',
            //     style:
            //         AppTextStyles.interMed14.copyWith(color: AppColors.white),
            //   ),
            // ),
            SizedBox(height: 20),
          ],
        ),
      ),
    );
  }

  AppBar buildAppBar(BuildContext context) {
    return AppBar(
      automaticallyImplyLeading: false,
      leading: Padding(
        padding: const EdgeInsets.only(left: 5.0),
        child: CustomBack(
          width: 28,
          height: 28,
          onTap: () {
            Navigator.pop(context);
          },
        ),
      ),
      titleSpacing: 8,
      title: Row(
        mainAxisAlignment: MainAxisAlignment.end,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: <Widget>[
        ],
      ),
    );
  }
}
