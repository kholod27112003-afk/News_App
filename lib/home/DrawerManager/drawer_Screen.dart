import 'package:flutter/material.dart';
import 'package:icons_plus/icons_plus.dart';
import 'package:news_app/home/DrawerManager/Drawer_item.dart';
import 'package:news_app/models/Category.dart';
import 'package:news_app/utils/app_colors.dart';
import 'package:news_app/utils/app_style.dart';

class DrawerScreen extends StatefulWidget {
  final Function(Category?) onDrawerItemClick;
  DrawerScreen({super.key, required this.onDrawerItemClick});

  @override
  State<DrawerScreen> createState() => _DrawerScreenState();
}

class _DrawerScreenState extends State<DrawerScreen> {
  String selectedTheme = 'Dark';
  String selectedLanguage = 'English';

  @override
  Widget build(BuildContext context) {
    var height = MediaQuery.of(context).size.height;
    var width = MediaQuery.of(context).size.width;
    return Container(
      color: AppColors.primaryDarkColor,
      child: SafeArea(
        child: Column(
          children: [
            Container(
              alignment: Alignment.center,
              width: double.infinity,
              height: height * 0.2,
              color: AppColors.primaryLightColor,
              child: Text(
                "News App",
                style: AppStyle.medium24black,
              ),
            ),
            Expanded(
              child: SingleChildScrollView(
                padding: EdgeInsets.symmetric(horizontal: width * 0.02),
                child: Column(
                  children: [
                    GestureDetector(
                      onTap: () {
                        widget.onDrawerItemClick(null);
                      },
                      child: DrawerItem(
                        icon: Clarity.home_line,
                        text: "Go to Home",
                      ),
                    ),
                    Divider(
                      color: AppColors.primaryLightColor,
                      indent: width * 0.01,
                      endIndent: width * 0.01,
                    ),
                    DrawerItem(
                      icon: Icons.format_paint_outlined,
                      text: "Theme",
                    ),
                    Padding(
                      padding: EdgeInsets.symmetric(
                        horizontal: 20,
                        vertical: 8,
                      ),
                      child: Container(
                        width: double.infinity,
                        padding: EdgeInsets.symmetric(horizontal: 12),
                        decoration: BoxDecoration(
                          border: Border.all(
                            color: Colors.white,
                            width: 2,
                          ),
                          borderRadius: BorderRadius.circular(16),
                        ),
                        child: DropdownButton<String>(
                          iconEnabledColor: AppColors.primaryLightColor,
                          dropdownColor: AppColors.primaryDarkColor,
                          borderRadius: BorderRadius.circular(16),
                          isExpanded: true,
                          underline: SizedBox(),
                          value: selectedTheme,
                          items: <String>[
                            'Dark',
                            'Light',
                          ].map((String value) {
                            return DropdownMenuItem<String>(
                              value: value,
                              child: Text(
                                value,
                                style: AppStyle.bold20white,
                              ),
                            );
                          }).toList(),
                          onChanged: (String? newValue) {
                            if (newValue != null) {
                              setState(() {
                                selectedTheme = newValue;
                              });
                            }
                          },
                        ),
                      ),
                    ),
                    SizedBox(height: height * 0.02),
                    Divider(
                      color: AppColors.primaryLightColor,
                      indent: width * 0.01,
                      endIndent: width * 0.01,
                    ),
                    DrawerItem(
                      icon: IonIcons.earth,
                      text: "Language",
                    ),
                    Padding(
                      padding: EdgeInsets.symmetric(
                        horizontal: 20,
                        vertical: 8,
                      ),
                      child: Container(
                        width: double.infinity,
                        padding: EdgeInsets.symmetric(horizontal: 12),
                        decoration: BoxDecoration(
                          border: Border.all(
                            color: Colors.white,
                            width: 2,
                          ),
                          borderRadius: BorderRadius.circular(16),
                        ),
                        child: DropdownButton<String>(
                          iconEnabledColor: AppColors.primaryLightColor,
                          dropdownColor: AppColors.primaryDarkColor,
                          borderRadius: BorderRadius.circular(16),
                          isExpanded: true,
                          underline: SizedBox(),
                          value: selectedLanguage,
                          items: <String>[
                            'English',
                            'Arabic',
                          ].map((String value) {
                            return DropdownMenuItem<String>(
                              value: value,
                              child: Text(
                                value,
                                style: AppStyle.bold20white,
                              ),
                            );
                          }).toList(),
                          onChanged: (String? newValue) {
                            if (newValue != null) {
                              setState(() {
                                selectedLanguage = newValue;
                              });
                            }
                          },
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
