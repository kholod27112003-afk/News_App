import 'package:flutter/material.dart';
import 'package:news_app/News/News_wid.dart';
import 'package:news_app/home/category_details/SourceTab.dart';
import 'package:news_app/models/SourceResponse.dart';


class Sourcetabwidget extends StatefulWidget {
  Sourcetabwidget({super.key, required this.sourceList});
  List<Sources> sourceList = [];

  @override
  State<Sourcetabwidget> createState() => _SourcetabwidgetState();
}

class _SourcetabwidgetState extends State<Sourcetabwidget> {
  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: widget.sourceList.length,
      child: Builder(
        builder: (context) {
          final tabController = DefaultTabController.of(context);

          return Column(
            children: [
              TabBar(
                tabAlignment: TabAlignment.start,
                dividerColor: Colors.transparent,
                indicatorColor: Theme.of(context).splashColor,
                isScrollable: true,
                tabs: widget.sourceList.map(
                      (source) {
                    int index = widget.sourceList.indexOf(source);
                    return AnimatedBuilder(
                      animation: tabController!,
                      builder: (context, _) {
                        bool isSelected = tabController.index == index;
                        return SourceTab(
                          source: source,
                          isSelected: isSelected,
                        );
                      },
                    );
                  },
                ).toList(),
              ),
              Expanded(
                child: TabBarView(
                  children: widget.sourceList
                      .map((source) => NewsWidget(sources: source))
                      .toList(),
                ),
              ),
            ],
          );
        },
      ),
    );
  }
}
