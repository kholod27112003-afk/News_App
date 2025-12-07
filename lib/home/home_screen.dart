import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:icons_plus/icons_plus.dart';
import 'package:news_app/home/Category_Fragment/category_fragment.dart';
import 'package:news_app/home/DrawerManager/drawer_Screen.dart';
import 'package:news_app/home/Search_deligate.dart';
import 'package:news_app/home/category_details/Category_details.dart';
import 'package:news_app/models/Category.dart';
import 'dart:math' as math;


class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen>
    with SingleTickerProviderStateMixin {
  late AnimationController _animationController;
  late Animation<double> _sidebarAnim;
  bool isDrawerOpen = false;
  Category? selectedCategory;
  @override
  void initState() {
    super.initState();

    _animationController = AnimationController(
      vsync: this,
      duration: Duration(milliseconds: 300),
    );

    _sidebarAnim = CurvedAnimation(
      parent: _animationController,
      curve: Curves.easeInOut,
    );
  }
  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }
  void toggleDrawer() {
    setState(() {
      if (isDrawerOpen) {
        _animationController.reverse();
      } else {
        _animationController.forward();
      }
      isDrawerOpen = !isDrawerOpen;
    });
  }
  void onDrawerItemClick(Category? category) {
    setState(() {
      selectedCategory = category;
      toggleDrawer(); // أغلق القائمة بعد الاختيار
    });
  }
  void onCategoryItemClick(Category category) {
    setState(() {
      selectedCategory = category;
    });
  }
  void _handleHorizontalDragUpdate(DragUpdateDetails details) {
    if (details.delta.dx > 10 && !isDrawerOpen) {
      toggleDrawer();
    }
  }
  void _handleHorizontalDragEnd(DragEndDetails details) {

  }


  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final screenheight = MediaQuery.of(context).size.height;

    return Scaffold(
      body: Stack(
        children: [
          Positioned.fill(
            child: Container(
              color: Theme.of(context).scaffoldBackgroundColor,
            ),
          ),
          RepaintBoundary(
            child: AnimatedBuilder(
              animation: _sidebarAnim,
              builder: (context, child) {
                return Transform(
                  alignment: Alignment.center,
                  transform: Matrix4.identity()
                    ..setEntry(3, 2, 0.001)
                    ..rotateY(((1 - _sidebarAnim.value) * -30) * math.pi / 180)
                    ..translate((1 - _sidebarAnim.value) * -300),
                  child: child,
                );
              },
              child: FadeTransition(
                opacity: _sidebarAnim,
                child: SizedBox(
                  width: screenWidth * (2 / 3),
                  child: DrawerScreen(
                    onDrawerItemClick: onDrawerItemClick,
                  ),
                ),
              ),
            ),
          ),
          RepaintBoundary(
            child: AnimatedBuilder(
              animation: _sidebarAnim,
              builder: (context, child) {
                return Transform.scale(
                  scale: 1 - (_sidebarAnim.value * 0.1),
                  child: Transform.translate(
                    offset: Offset(_sidebarAnim.value * screenWidth * 0.66, 0),
                    child: Transform(
                      alignment: Alignment.center,
                      transform: Matrix4.identity()
                        ..setEntry(3, 2, 0.001)
                        ..rotateY((_sidebarAnim.value * 30) * math.pi / 180),
                      child: Stack(
                        children: [
                          GestureDetector(
                            onTap: isDrawerOpen ? toggleDrawer : null,
                            child: AbsorbPointer(
                              absorbing: isDrawerOpen,
                              child: child,
                            ),
                          ),
                          if (!isDrawerOpen)
                            Positioned(
                              left: 0,
                              top: 0,
                              bottom: 0,
                              child: GestureDetector(
                                behavior: HitTestBehavior.translucent,
                                onHorizontalDragUpdate:
                                _handleHorizontalDragUpdate,
                                onHorizontalDragEnd: _handleHorizontalDragEnd,
                                child: Container(
                                  width: 30,
                                  color: Colors.transparent,
                                ),
                              ),
                            ),
                        ],
                      ),
                    ),
                  ),
                );
              },
              child: Scaffold(
                appBar: AppBar(
                  actions: [
                    IconButton(
                        onPressed: () {
                          showSearch(
                            context: context,
                            delegate: Search(),
                          );
                        },
                        icon: Icon(
                          Iconsax.search_normal_1_outline,
                        ))
                  ],
                  scrolledUnderElevation: 0,
                  leading: SizedBox.shrink(),
                  title: Text(
                    selectedCategory == null ? "Home" : selectedCategory!.title,
                    style: Theme.of(context).textTheme.headlineLarge,
                  ),
                ),
                body: selectedCategory == null
                    ? CategoryFragment(
                  onCategoryItemClick: onCategoryItemClick,
                )
                    : CategoryDetails(
                  category: selectedCategory!,
                ),
              ),
            ),
          ),
          RepaintBoundary(
            child: AnimatedBuilder(
              animation: _sidebarAnim,
              builder: (context, child) {
                return SafeArea(
                  child: Row(
                    children: [
                      SizedBox(width: _sidebarAnim.value * (screenWidth * 0.5)),
                      child!,
                    ],
                  ),
                );
              },
              child: GestureDetector(
                onTap: toggleDrawer,
                child: Container(
                  width: screenWidth * 0.05,
                  height: screenheight * 0.02,
                  margin: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(25),
                  ),
                  child: Icon(
                    isDrawerOpen ? null : Icons.menu,
                    color: isDrawerOpen ? Colors.black : Colors.white,
                  ),
                ),
              ),
            ),
          )
        ],
      ),
    );
  }
}
