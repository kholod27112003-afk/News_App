import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:news_app/utils/app_colors.dart';

class AppStyle {
  static TextStyle medium20white = GoogleFonts.inter(
      fontSize: 20, fontWeight: FontWeight.w500, color: AppColors.primaryLightColor
  );

  static TextStyle medium20black = GoogleFonts.inter(
      fontSize: 20, fontWeight: FontWeight.w500, color: AppColors.blackColor
  );

  static TextStyle medium14white = GoogleFonts.inter(
      fontSize: 14, fontWeight: FontWeight.w500, color: AppColors.primaryLightColor
  );

  static TextStyle medium14black = GoogleFonts.inter(
      fontSize: 14, fontWeight: FontWeight.w500, color: AppColors.blackColor
  );

  static TextStyle medium24white = GoogleFonts.inter(
      fontSize: 24, fontWeight: FontWeight.w500, color: AppColors.primaryLightColor
  );

  static TextStyle medium24black = GoogleFonts.inter(
      fontSize: 24, fontWeight: FontWeight.w500, color: AppColors.blackColor
  );

  static TextStyle medium12gray = GoogleFonts.inter(
      fontSize: 12, fontWeight: FontWeight.w500, color: AppColors.grayColor
  );

  static TextStyle bold16white = GoogleFonts.inter(
      fontSize: 16, fontWeight: FontWeight.bold, color: AppColors.primaryLightColor
  );

  static TextStyle bold16black = GoogleFonts.inter(
      fontSize: 16, fontWeight: FontWeight.bold, color: AppColors.blackColor
  );

  static TextStyle bold20white = GoogleFonts.inter(
      fontSize: 20, fontWeight: FontWeight.bold, color: AppColors.primaryLightColor
  );

  static TextStyle bold20black = GoogleFonts.inter(
      fontSize: 16, fontWeight: FontWeight.bold, color: AppColors.blackColor
  );
}