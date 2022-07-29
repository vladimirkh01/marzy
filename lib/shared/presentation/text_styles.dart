import 'package:flutter/cupertino.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:marzy/shared/presentation/colors.dart';

class AppTextStyles {
  static TextStyle interMed14 = GoogleFonts.inter(
    color: AppColors.white,
    fontSize: 14,
    fontWeight: FontWeight.w500,
  );

  static TextStyle interSemiBold64 = GoogleFonts.inter(
    color: AppColors.accent,
    fontSize: 64,
    fontWeight: FontWeight.w600,
  );

  static TextStyle interSemiBold10 = GoogleFonts.inter(
    color: AppColors.blackGrey,
    fontSize: 10,
    fontWeight: FontWeight.w600,
  );

  static TextStyle interSemiBold20 = GoogleFonts.inter(
    color: AppColors.black,
    fontSize: 20,
    fontWeight: FontWeight.w600,
  );

  static TextStyle interReg16 = GoogleFonts.inter(
    color: AppColors.black,
    fontSize: 16,
    fontWeight: FontWeight.normal,
  );
  static TextStyle interReg14 = GoogleFonts.inter(
    color: AppColors.black,
    fontSize: 14,
    fontWeight: FontWeight.normal,
  );

  static TextStyle interMed12 = GoogleFonts.inter(
    color: AppColors.black,
    fontSize: 12,
    height: 14.52 / 12,
    fontWeight: FontWeight.w500,
  );
}
