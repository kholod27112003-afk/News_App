import 'package:flutter/material.dart';
import 'package:news_app/utils/app_colors.dart';
import 'package:news_app/utils/app_style.dart';

class DrawerItem extends StatelessWidget {
  DrawerItem({super.key, required this.icon, required this.text});
  IconData icon;
  String text;
  @override
  Widget build(BuildContext context) {
    var width = MediaQuery.of(context).size.width;
    var height = MediaQuery.of(context).size.height;
    return Padding(
      padding: EdgeInsets.symmetric(
          horizontal: width * 0.04, vertical: height * 0.02),
      child: Row(
        children: [
          Icon(
            icon,
            color: AppColors.primaryLightColor,
          ),
          SizedBox(
            width: width * 0.02,
          ),
          Text(
            text,
            style: AppStyle.bold16white,
          )
        ],
      ),
    );
  }
}
