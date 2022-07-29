import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:marzy/features/static/catalog_detail/catalog_detail.dart';
import 'package:marzy/features/static/catalogs/catalogs.dart';
import 'package:marzy/shared/presentation/colors.dart';
import 'package:marzy/shared/presentation/text_styles.dart';

class CatalogItem extends StatelessWidget {
  final String title;
  final String? imageUrl;
  final int categoryId;

  CatalogItem({
    required this.title,
    this.imageUrl,
    required this.categoryId
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        Navigator.push(context,
            MaterialPageRoute(builder: (context) => CatalogsScreen(categoryId: categoryId,)));
      },
      child: Stack(
        children: [
          Container(
            padding: EdgeInsets.only(left: 18.w, bottom: 18.w),
            child: Container(),
            decoration: BoxDecoration(
              color: AppColors.fonGrey,
              borderRadius: BorderRadius.circular(15),
            ),
          ),
          Padding(
            padding: EdgeInsets.only(bottom: 18.w, left: 18.w),
            child: Align(
              child: Text(
                title,
                style:
                    AppTextStyles.interMed14.copyWith(color: AppColors.black),
              ),
              alignment: Alignment.bottomLeft,
            ),
          ),
        ],
      ),
    );
  }
}
