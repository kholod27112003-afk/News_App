import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:news_app/News/News_items.dart';
import 'package:news_app/api/api_manager.dart';
import 'package:news_app/models/NewsResponse.dart';
import 'package:news_app/models/SourceResponse.dart';
import 'package:news_app/utils/app_colors.dart';
import 'package:news_app/utils/app_routes.dart';
import 'package:shimmer/shimmer.dart';

class NewsWidget extends StatefulWidget {
  Sources sources;
  NewsWidget({super.key, required this.sources});
  @override
  State<NewsWidget> createState() => _NewsWidgetState();
}

class _NewsWidgetState extends State<NewsWidget> {
  final ScrollController _scrollController = ScrollController();
  List<Articles> newsList = [];
  int currentPage = 1;
  bool isLoading = false;
  bool isLoadingMore = false;
  bool hasMore = true;
  String? error;
  int? totalResults;
  final int pageSize = 10;

  @override
  void initState() {
    super.initState();
    _loadNews();
    _scrollController.addListener(_onScroll);
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  void _onScroll() {
    if (_scrollController.position.pixels >=
        _scrollController.position.maxScrollExtent - 200 &&
        !isLoadingMore &&
        hasMore) {
      _loadMoreNews();
    }
  }

  Future<void> _loadNews() async {
    setState(() {
      isLoading = true;
      error = null;
      currentPage = 1;
      newsList.clear();
    });

    try {
      final response = await ApiManger.getNews(
        widget.sources.id ?? "",
        page: currentPage,
        pageSize: pageSize,
      );

      if (response.status == "ok") {
        setState(() {
          newsList = response.articles ?? [];
          totalResults = response.totalResults;
          hasMore = newsList.length < (totalResults ?? 0);
          isLoading = false;
        });
      } else {
        setState(() {
          error = response.message ?? "Unknown error";
          isLoading = false;
        });
      }
    } catch (e) {
      setState(() {
        error = "Something went wrong";
        isLoading = false;
      });
    }
  }

  Future<void> _loadMoreNews() async {
    if (isLoadingMore || !hasMore) return;

    setState(() {
      isLoadingMore = true;
    });

    try {
      final response = await ApiManger.getNews(
        widget.sources.id ?? "",
        page: currentPage + 1,
        pageSize: pageSize,
      );

      if (response.status == "ok") {
        setState(() {
          currentPage++;
          newsList.addAll(response.articles ?? []);
          hasMore = newsList.length < (totalResults ?? 0);
          isLoadingMore = false;
        });
      } else {
        setState(() {
          isLoadingMore = false;
        });
      }
    } catch (e) {
      setState(() {
        isLoadingMore = false;
      });
    }
  }

  Widget buildSingleNewsShimmer(double height, double width) {
    return Container(
      padding: EdgeInsets.symmetric(
        horizontal: width * 0.028,
        vertical: height * 0.01,
      ),
      margin: EdgeInsets.symmetric(
        horizontal: width * 0.028,
      ),
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
  }

  Widget buildNewsShimmer(double height, double width) {
    return ListView.separated(
      padding: EdgeInsets.only(top: height * 0.02),
      itemCount: 5,
      separatorBuilder: (context, index) => SizedBox(height: height * 0.02),
      itemBuilder: (context, index) {
        return buildSingleNewsShimmer(height, width);
      },
    );
  }

  Widget _buildLoadingMoreIndicator() {
    var height = MediaQuery.of(context).size.height;
    var width = MediaQuery.of(context).size.width;

    return Padding(
      padding: EdgeInsets.symmetric(vertical: height * 0.02),
      child: buildSingleNewsShimmer(height, width),
    );
  }

  @override
  Widget build(BuildContext context) {
    var height = MediaQuery.of(context).size.height;
    var width = MediaQuery.of(context).size.width;

    if (isLoading) {
      return buildNewsShimmer(height, width);
    }

    if (error != null) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(error!, style: Theme.of(context).textTheme.labelMedium),
            SizedBox(height: height * 0.02),
            ElevatedButton(
              onPressed: _loadNews,
              child: Text("Try Again",
                  style: Theme.of(context).textTheme.labelMedium),
            )
          ],
        ),
      );
    }

    if (newsList.isEmpty) {
      return Center(
        child: Text("No news available for ${widget.sources.name}"),
      );
    }

    return ListView.separated(
      controller: _scrollController,
      padding: EdgeInsets.only(top: height * 0.02, bottom: height * 0.02),
      separatorBuilder: (context, index) => SizedBox(height: height * 0.02),
      itemCount: newsList.length + (isLoadingMore ? 1 : 0),
      itemBuilder: (context, index) {
        if (index == newsList.length) {
          return _buildLoadingMoreIndicator();
        }

        return GestureDetector(
          onTap: () => _showNewsModal(newsList[index]),
          child: NewsItem(news: newsList[index]),
        );
      },
    );
  }

  void _showNewsModal(Articles news) {
    var height = MediaQuery.of(context).size.height;
    var width = MediaQuery.of(context).size.width;

    String getFirstFourLines(String? text) {
      if (text == null || text.isEmpty) return '';
      final words = text.split(' ');
      final firstWords = words.take(30).toList();
      return firstWords.join(' ') + (words.length > 30 ? '...' : '');
    }

    int getRemainingChars(String? text, String preview) {
      if (text == null) return 0;
      return text.length - preview.length;
    }

    void openUrl(String url, String title) {
      Navigator.pushNamed(
        context,
        AppRoutes.webView,
        arguments: {
          'url': url,
          'title': title,
        },
      );
    }

    final content = news.content ?? news.description ?? '';
    final preview = getFirstFourLines(content);
    final remaining = getRemainingChars(content, preview);

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      isDismissible: true,
      enableDrag: true,
      backgroundColor: Colors.transparent,
      builder: (context) {
        return DraggableScrollableSheet(
          initialChildSize: 0.6,
          minChildSize: 0.3,
          maxChildSize: 0.6,
          builder: (context, scrollController) {
            return Container(
              margin: EdgeInsets.only(bottom: height * 0.05),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.vertical(
                    top: Radius.circular(20), bottom: Radius.circular(20)),
              ),
              child: Column(
                children: [
                  Expanded(
                    child: SingleChildScrollView(
                      controller: scrollController,
                      padding: EdgeInsets.all(16),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          if (news.urlToImage != null &&
                              news.urlToImage!.isNotEmpty)
                            ClipRRect(
                              borderRadius: BorderRadius.circular(12),
                              child: CachedNetworkImage(
                                imageUrl: news.urlToImage!,
                                height: height * 0.25,
                                width: double.infinity,
                                fit: BoxFit.cover,
                                placeholder: (context, url) =>
                                    Shimmer.fromColors(
                                      baseColor: Colors.grey.shade300,
                                      highlightColor: Colors.grey.shade100,
                                      child: Container(
                                        height: height * 0.25,
                                        width: double.infinity,
                                        color: Colors.grey.shade300,
                                      ),
                                    ),
                                errorWidget: (context, url, error) => Container(
                                  height: height * 0.25,
                                  color: Colors.grey.shade300,
                                  child: Icon(Icons.broken_image, size: 50),
                                ),
                              ),
                            ),

                          Container(
                            padding: EdgeInsets.all(16),
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(12),
                            ),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                RichText(
                                  text: TextSpan(
                                    style: TextStyle(
                                      fontSize: 16,
                                      height: 1.6,
                                      color: AppColors.primaryDarkColor,
                                    ),
                                    children: [
                                      TextSpan(text: preview),
                                    ],
                                  ),
                                ),
                              ],
                            ),
                          ),

                          SizedBox(height: height * 0.01),

                          SizedBox(
                            width: double.infinity,
                            height: 56,
                            child: ElevatedButton.icon(
                              onPressed: () {
                                if (news.url != null && news.url!.isNotEmpty) {
                                  openUrl(news.url!, news.title ?? 'news');
                                }
                              },
                              label: Text(
                                'View Full Article',
                                style: TextStyle(
                                  fontSize: 18,
                                  color: AppColors.primaryLightColor,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              style: ElevatedButton.styleFrom(
                                backgroundColor: AppColors.primaryDarkColor,
                                foregroundColor: Colors.black,
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(12),
                                ),
                                elevation: 4,
                              ),
                            ),
                          ),

                          SizedBox(height: height * 0.02),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            );
          },
        );
      },
    );
  }

  String _formatTimeAgo(DateTime dateTime) {
    final now = DateTime.now();
    final difference = now.difference(dateTime);

    if (difference.inDays > 0) {
      return '${difference.inDays} ${difference.inDays == 1 ? 'day' : 'days'} ago';
    } else if (difference.inHours > 0) {
      return '${difference.inHours} ${difference.inHours == 1 ? 'hour' : 'hours'} ago';
    } else if (difference.inMinutes > 0) {
      return '${difference.inMinutes} ${difference.inMinutes == 1 ? 'minute' : 'minutes'} ago';
    } else {
      return 'Just now';
    }
  }
}