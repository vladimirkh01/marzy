import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

class AppImages {
  static const paid = 'assets/images/paid.png';
  static const splashBg = 'assets/images/splash_bg.png';
  static const backButton = 'assets/icons/back_button.svg';
  static const locationButton = 'assets/images/location.svg';
  static const arrowRight = 'assets/images/arrow_right.svg';
  static const profileButton = 'assets/images/profile.svg';
  static const searchButton = 'assets/images/search.svg';
  static const threeDots = 'assets/images/three_dots.svg';
  static const expandDown = 'assets/images/expand_down.svg';
  static const payment = 'assets/icons/payment_icon.svg';
  static const paymentVisa = 'assets/icons/visa_pay.svg';
  static const paymentMIR = 'assets/icons/mir_pay.svg';
  static const favorite = 'assets/icons/favorite.svg';
  static const locationUp = 'assets/images/location_up.svg';
  static const more = 'assets/icons/more.svg';
  static const locationUser = 'assets/images/loc_user.svg';
}

class CustomImage extends StatelessWidget {
  final Color? color;
  final double? width;
  final double? height;
  final String image;
  const CustomImage({
    Key? key,
    this.color,
    this.width,
    this.height,
    required this.image,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SvgPicture.asset(
      image,
      color: color,
      width: width,
      height: height,
    );
  }
}
