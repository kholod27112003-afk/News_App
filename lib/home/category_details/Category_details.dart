import 'package:flutter/material.dart';
import 'package:news_app/api/api_manager.dart';
import 'package:news_app/home/category_details/SourceTabWid.dart';
import 'package:news_app/models/Category.dart';
import 'package:news_app/models/SourceResponse.dart';
import 'package:shimmer/shimmer.dart';

class CategoryDetails extends StatefulWidget {
  final Category category;

  const CategoryDetails({super.key, required this.category});

  @override
  State<CategoryDetails> createState() => _CategoryDetailsState();
}

class _CategoryDetailsState extends State<CategoryDetails> {
  late Future<SourceResponse> sourcesFuture;

  @override
  void initState() {
    super.initState();

    sourcesFuture = ApiManger.getSources(category: widget.category.id);
  }

  Widget buildSkeleton(double height, double width) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: width * 0.05),
      child: Shimmer.fromColors(
        baseColor: Colors.grey.shade300,
        highlightColor: Colors.grey.shade100,
        child: Column(
          children: List.generate(4, (index) {
            return Container(
              margin: EdgeInsets.only(bottom: height * 0.02),
              height: height * 0.08,
              width: double.infinity,
              decoration: BoxDecoration(
                color: Colors.grey.shade300,
                borderRadius: BorderRadius.circular(12),
              ),
            );
          }),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    var height = MediaQuery.of(context).size.height;
    var width = MediaQuery.of(context).size.width;

    return FutureBuilder<SourceResponse>(
      future: sourcesFuture,
      builder: (context, snapshot) {

        if (snapshot.hasError) {
        }

        if (snapshot.hasData) {
        }

        if (snapshot.connectionState == ConnectionState.waiting) {
          return buildSkeleton(height, width);
        }

        if (snapshot.hasError) {
          return Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text("Error: ${snapshot.error}"),
                SizedBox(height: height * 0.02),
                ElevatedButton(
                  onPressed: () {
                    setState(() {
                      sourcesFuture = ApiManger.getSources(category: widget.category.id);
                    });
                  },
                  child: Text("Try Again"),
                ),
              ],
            ),
          );
        }

        if (snapshot.data?.status == "error") {
          return Center(
            child: Padding(
              padding: EdgeInsets.all(20),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(Icons.error_outline, size: 64, color: Colors.red),
                  SizedBox(height: height * 0.02),
                  Text(
                    "API Error",
                    style: Theme.of(context).textTheme.headlineMedium,
                  ),
                  SizedBox(height: height * 0.02),
                  Text(
                    snapshot.data?.message ?? "Unknown error",
                    textAlign: TextAlign.center,
                    style: Theme.of(context).textTheme.bodyMedium,
                  ),
                  SizedBox(height: height * 0.03),
                  ElevatedButton(
                    onPressed: () {
                      setState(() {
                        sourcesFuture = ApiManger.getSources(category: widget.category.id);
                      });
                    },
                    child: Text("Try Again"),
                  ),
                ],
              ),
            ),
          );
        }

        var sourceList = snapshot.data?.sources ?? [];

        if (sourceList.isEmpty) {
          return Center(
            child: Text("No sources found for ${widget.category.title}"),
          );
        }

        return Sourcetabwidget(sourceList: sourceList);
      },
    );
  }
}
