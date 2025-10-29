import 'package:flutter/material.dart';
import 'package:news_app/utils/app_colors.dart';
import 'package:news_app/utils/app_style.dart';

class AppTheme {
  static final ThemeData lightTheme = ThemeData(
    primaryColor: AppColors.whiteColor,
    indicatorColor: AppColors.blackColor,
    scaffoldBackgroundColor: AppColors.whiteColor,
    appBarTheme: const AppBarTheme(
      backgroundColor: AppColors.whiteColor,
      iconTheme: IconThemeData(color: AppColors.blackColor),
      centerTitle: true,
    ),
    textTheme: TextTheme(
      labelLarge: AppStyle.bold16black,
      labelSmall: AppStyle.medium12gray,
      labelMedium: AppStyle.medium14black,
      headlineMedium: AppStyle.medium24black,
      headlineLarge: AppStyle.medium20black,
    ),
  );
  static final ThemeData darkTheme = ThemeData(
    primaryColor: AppColors.blackColor,
    indicatorColor: AppColors.whiteColor,
    scaffoldBackgroundColor: AppColors.blackColor,
    appBarTheme: const AppBarTheme(
      backgroundColor: AppColors.blackColor,
      centerTitle: true,
      iconTheme: IconThemeData(color: AppColors.whiteColor),
    ),
    textTheme: TextTheme(
      labelLarge: AppStyle.bold16white,
      labelSmall: AppStyle.medium12gray,
      labelMedium: AppStyle.medium14white,
      headlineMedium: AppStyle.medium20white,
      headlineLarge: AppStyle.medium20white,
    ),
  );
}