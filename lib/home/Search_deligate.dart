import 'package:flutter/material.dart';
import 'package:news_app/News/News_items.dart';
import 'package:news_app/api/api_manager.dart';
import 'package:news_app/models/NewsResponse.dart';
import 'package:news_app/utils/app_colors.dart';
import 'package:shimmer/shimmer.dart';

class Search extends SearchDelegate {
  @override
  ThemeData appBarTheme(BuildContext context) {
    final theme = Theme.of(context);

    return theme.copyWith(
      indicatorColor: AppColors.primaryLightColor,
      appBarTheme: AppBarTheme(
        backgroundColor: theme.scaffoldBackgroundColor,
        elevation: 0,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.vertical(
            bottom: Radius.circular(22),
          ),
        ),
      ),
      inputDecorationTheme: InputDecorationTheme(
        border: InputBorder.none,
        hintStyle: TextStyle(color: Colors.white70),
      ),
      textTheme: theme.textTheme.copyWith(
        titleLarge: const TextStyle(
          color: Colors.white,
          fontSize: 18,
          fontWeight: FontWeight.w500,
        ),
      ),
    );
  }

  @override
  List<Widget>? buildActions(BuildContext context) {
    return [
      IconButton(
        icon: Icon(Icons.close),
        color: AppColors.primaryLightColor,
        onPressed: () {
          query = "";
        },
      )
    ];
  }

  @override
  Widget? buildLeading(BuildContext context) {
    return IconButton(
      icon: Icon(Icons.arrow_back),
      color: AppColors.primaryLightColor,
      onPressed: () {
        close(context, null);
      },
    );
  }

  @override
  Widget buildResults(BuildContext context) {
    var height = MediaQuery.of(context).size.height;
    var width = MediaQuery.of(context).size.width;
    return FutureBuilder<NewsResponse>(
      future: ApiManger.searchNews(query),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return ListView.builder(
            itemCount: 10,
            itemBuilder: (context, index) {
              return Container(
                padding: EdgeInsets.symmetric(
                  horizontal: width * 0.028,
                  vertical: height * 0.01,
                ),
                margin: EdgeInsets.symmetric(
                    horizontal: width * 0.028, vertical: height * 0.01),
                decoration: BoxDecoration(
                  border: Border.all(
                    color: Colors.grey.shade300,
                    width: 2,
                  ),
                  borderRadius: BorderRadius.circular(16),
                ),
                child: Shimmer.fromColors(
                  baseColor: Colors.grey.shade300,
                  highlightColor: Colors.grey.shade100,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Container(
                        height: height * 0.25,
                        width: double.infinity,
                        decoration: BoxDecoration(
                          color: Colors.grey.shade300,
                          borderRadius: BorderRadius.circular(8),
                        ),
                      ),
                      SizedBox(height: height * 0.01),
                      Container(
                        height: 20,
                        width: double.infinity,
                        decoration: BoxDecoration(
                          color: Colors.grey.shade300,
                          borderRadius: BorderRadius.circular(4),
                        ),
                      ),
                      SizedBox(height: 8),
                      Container(
                        height: 20,
                        width: width * 0.6,
                        decoration: BoxDecoration(
                          color: Colors.grey.shade300,
                          borderRadius: BorderRadius.circular(4),
                        ),
                      ),
                      SizedBox(height: height * 0.01),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Container(
                            height: 12,
                            width: width * 0.3,
                            decoration: BoxDecoration(
                              color: Colors.grey.shade300,
                              borderRadius: BorderRadius.circular(4),
                            ),
                          ),
                          Container(
                            height: 12,
                            width: width * 0.2,
                            decoration: BoxDecoration(
                              color: Colors.grey.shade300,
                              borderRadius: BorderRadius.circular(4),
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              );
            },
          );
        }

        if (snapshot.hasError || snapshot.data!.status != "ok") {
          return Center(
              child: Text(
                "News Not Found",
                style: Theme.of(context).textTheme.headlineLarge,
              ));
        }

        var results = snapshot.data!.articles ?? [];

        if (results.isEmpty) {
          return Center(
              child: Text(
                "No results found",
                style: Theme.of(context).textTheme.headlineLarge,
              ));
        }

        return ListView.separated(
          separatorBuilder: (context, index) => SizedBox(
            height: height * 0.02,
          ),
          itemCount: results.length,
          itemBuilder: (context, index) {
            return NewsItem(news: results[index]);
          },
        );
      },
    );
  }

  @override
  Widget buildSuggestions(BuildContext context) {
    if (query.isEmpty) {
      return Center(
          child: Text(
            "Type to search news...",
            style: Theme.of(context).textTheme.headlineLarge,
          ));
    }
    return buildResults(context);
  }
}

Widget shimmerItem() {
  return Padding(
    padding: const EdgeInsets.all(8.0),
    child: Row(
      children: [
        Container(
          width: 100,
          height: 100,
          color: Colors.grey[300],
        ),
        SizedBox(width: 10),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(height: 15, color: Colors.grey[300]),
              SizedBox(height: 10),
              Container(height: 15, width: 150, color: Colors.grey[300]),
              SizedBox(height: 10),
              Container(height: 15, width: 100, color: Colors.grey[300]),
            ],
          ),
        )
      ],
    ),
  );
}
