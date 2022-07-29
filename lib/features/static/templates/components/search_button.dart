import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:marzy/shared/images/images.dart';
import 'package:marzy/shared/presentation/colors.dart';

class SearchButton extends StatelessWidget {
  final Color? color;
  final double? width;
  final double? height;
  final String image;
  final VoidCallback? onTap;
  const SearchButton({
    Key? key,
    this.color,
    this.width,
    this.height,
    required this.image,
    this.onTap,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Padding(
        padding: EdgeInsets.only(right: 6),
        child: CustomImage(
          image: AppImages.searchButton,
          width: width,
          height: height,
        ),
      ),
    );
  }
}
