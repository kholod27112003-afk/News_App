import 'package:animated_splash_screen/animated_splash_screen.dart';
import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';
import 'package:news_app/home/home_screen.dart';
import 'package:news_app/utils/app_colors.dart';

class SplashScreen extends StatelessWidget {
  const SplashScreen({super.key});

  @override
  Widget build(BuildContext context) {
    var height = MediaQuery.of(context).size.height;
    var width = MediaQuery.of(context).size.width;
    return AnimatedSplashScreen(
        backgroundColor: AppColors.primaryDarkColor,
        splashIconSize: 1000,
        duration: 5000,
        splash:
            Container(child: LottieBuilder.asset("assets/lottie/Splash.json")),
        nextScreen: HomeScreen());
  }
}
