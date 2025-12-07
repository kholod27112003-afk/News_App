import 'package:flutter/material.dart';
import 'package:news_app/home/Category_Fragment/category_item.dart';
import 'package:news_app/models/Category.dart';

typedef OnCategoryItemClick = void Function(Category);

class CategoryFragment extends StatelessWidget {
  CategoryFragment({super.key, required this.onCategoryItemClick});
  List<Category> categoryList = [];
  OnCategoryItemClick onCategoryItemClick;
  
  @override
  Widget build(BuildContext context) {
    var height = MediaQuery.of(context).size.height;
    var width = MediaQuery.of(context).size.width;
    categoryList = Category.getCategoriesList(isDark: false);
    
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: width * 0.04),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            "Good Morning\nHere is Some News For You",
            style: Theme.of(context).textTheme.headlineMedium,
          ),
          Expanded(
            child: ListView.separated(
              padding: EdgeInsets.only(top: height * 0.02),
              itemBuilder: (context, index) {
                return GestureDetector(
                  onTap: () {
                   
                    onCategoryItemClick(categoryList[index]);
                  },
                  child: CategoryItem(
                    category: categoryList[index],
                    index: index,
                  ),
                );
              },
              separatorBuilder: (context, index) => SizedBox(
                height: height * 0.02,
              ),
              itemCount: categoryList.length,
            ),
          )
        ],
      ),
    );
  }
}