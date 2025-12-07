import 'package:flutter/material.dart';
import 'package:news_app/News/Web_Screen.dart';
import 'package:news_app/SplashScreen/splash_screen.dart';
import 'package:news_app/home/home_screen.dart';
import 'package:news_app/utils/app_routes.dart';
import 'package:news_app/utils/app_theme.dart';

void main() {
  runApp(const NewsApp());
}

class NewsApp extends StatelessWidget {
  const NewsApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      initialRoute: AppRoutes.splashscreen,
      routes: {
        AppRoutes.homeRoute: (context) => const HomeScreen(),
        AppRoutes.splashscreen: (context) => const SplashScreen(),
      },
      onGenerateRoute: (settings) {
        if (settings.name == AppRoutes.webView) {
          final args = settings.arguments as Map<String, String>;
          return MaterialPageRoute(
            builder: (context) => WebViewScreen(
              url: args['url']!,
              title: args['title']!,
            ),
          );
        }
        return null;
      },
      theme: AppTheme.lightTheme,
      darkTheme: AppTheme.darkTheme,
      themeMode: ThemeMode.dark,
      locale: Locale("en"),
    );
  }
}