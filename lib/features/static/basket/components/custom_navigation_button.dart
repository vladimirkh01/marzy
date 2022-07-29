import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';

class CustomNavigationButton extends StatelessWidget {
  final Color? color;
  final double? width;
  final double? height;
  final String image;
  final VoidCallback? onTap;
  const CustomNavigationButton({
    Key? key,
    this.color,
    this.width,
    this.height,
    required this.image,
    this.onTap,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return IconButton(
      padding: EdgeInsets.zero,
      onPressed: onTap,
      icon: SvgPicture.asset(
        image,
        color: color,
        width: width,
        height: height,
      ),
    );
  }
}
