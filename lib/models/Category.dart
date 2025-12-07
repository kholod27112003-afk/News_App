import 'package:news_app/utils/app_assets.dart';

class Category {
  String id;
  String title;
  String image;
  Category({required this.id, required this.image, required this.title});
  static List<Category> getCategoriesList({required bool isDark}) {
    return [
      Category(
          id: "general",
          image: isDark ? AppAssets.generalDark : AppAssets.generalLight,
          title: "General"),
      Category(
          id: "business",
          image: isDark ? AppAssets.businessDark : AppAssets.busniessLight,
          title: "Business"),
      Category(
          id: "entertainment",
          image: isDark
              ? AppAssets.entertainmentDark
              : AppAssets.entertainmentLight,
          title: "Entertainment"),
      Category(
          id: "health",
          image: isDark ? AppAssets.healthDark : AppAssets.helthLight,
          title: "Health"),
      Category(
          id: "science",
          image: isDark ? AppAssets.scienceDark : AppAssets.scienceLight,
          title: "Science"),
      Category(
          id: "technology",
          image: isDark ? AppAssets.technologyDark : AppAssets.technologyLight,
          title: "Technology"),
      Category(
          id: "sports",
          image: isDark ? AppAssets.sportsDark : AppAssets.sportLight,
          title: "Sports"),
    ];
  }
}

