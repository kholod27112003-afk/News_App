import 'package:flutter/material.dart';
import 'package:news_app/models/Category.dart';
import 'package:news_app/utils/app_colors.dart';

class CategoryItem extends StatelessWidget {
  Category category;
  int index;
  CategoryItem({super.key, required this.category, required this.index});
  @override
  Widget build(BuildContext context) {
    var height = MediaQuery.of(context).size.height;
    var width = MediaQuery.of(context).size.width;

    return Container(
      clipBehavior: Clip.antiAlias,
      decoration: BoxDecoration(borderRadius: BorderRadius.circular(24)),
      child: Stack(
        alignment:
        (index % 2 == 0) ? Alignment.bottomRight : Alignment.bottomLeft,
        children: [
          Image.asset(
            category.image,
            width: double.infinity,
            fit: BoxFit.cover,
          ),

          // ----- BUTTON ----- //
          Container(
            padding: EdgeInsetsDirectional.only(
              end: (index % 2 == 0) ? 0 : width * 0.05,
              start: (index % 2 == 0) ? width * 0.05 : 0,
            ),
            margin: EdgeInsets.symmetric(
              horizontal: width * 0.02,
              vertical: height * 0.02,
            ),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(84),
              color: AppColors.grayColor,
            ),

            child: IntrinsicWidth(
              child: Row(
                mainAxisSize: MainAxisSize.min,
                textDirection:
                (index % 2 == 0) ? TextDirection.ltr : TextDirection.rtl,
                children: [
                  Flexible(
                    child: Text(
                      "View All",
                      style: Theme.of(context).textTheme.headlineMedium,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                  const SizedBox(width: 6),

                  // smaller circle
                  CircleAvatar(
                    radius: 18, // ← بدل 25
                    backgroundColor: Theme.of(context).primaryColor,
                    child: Icon(
                      (index % 2 == 0)
                          ? Icons.arrow_forward_ios_outlined
                          : Icons.arrow_back_ios_new_outlined,
                      size: 18,
                      color: Theme.of(context).splashColor,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
