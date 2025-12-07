import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:news_app/models/NewsResponse.dart';
import 'package:news_app/utils/app_style.dart';
import 'package:timeago/timeago.dart' as timeago;
import 'package:shimmer/shimmer.dart';

class NewsItem extends StatefulWidget {
  final Articles news;

  const NewsItem({
    super.key,
    required this.news,
  });

  @override
  State<NewsItem> createState() => _NewsItemState();
}

class _NewsItemState extends State<NewsItem> {
  @override
  Widget build(BuildContext context) {
    var height = MediaQuery.of(context).size.height;
    var width = MediaQuery.of(context).size.width;

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
          color: Theme.of(context).splashColor,
          width: 2,
        ),
        borderRadius: BorderRadius.circular(16),
      ),
      child: Column(
        children: [
          ClipRRect(
            borderRadius: BorderRadius.circular(8),
            child: (widget.news.urlToImage == null ||
                widget.news.urlToImage!.isEmpty)
                ? Container(
              height: height * 0.25,
              color: Colors.grey.shade300,
              child: Icon(Icons.broken_image),
            )
                : CachedNetworkImage(
              imageUrl: widget.news.urlToImage!,
              fit: BoxFit.cover,
              height: height * 0.25,
              width: double.infinity,
              placeholder: (context, url) => Shimmer.fromColors(
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
                child: Icon(Icons.broken_image),
              ),
            ),
          ),
          SizedBox(
            height: height * 0.01,
          ),
          Text(widget.news.title ?? "",
              style: Theme.of(context).textTheme.labelLarge),
          SizedBox(
            height: height * 0.01,
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Expanded(
                child: Text(
                  " By : ${widget.news.author ?? ""}",
                  style: AppStyle.medium12gray,
                ),
              ),
              Expanded(
                child: Text(
                  textAlign: TextAlign.end,
                  _formatTimeAgo(
                      DateTime.parse(widget.news.publishedAt ?? "")),
                  style: AppStyle.medium12gray,
                ),
              )
            ],
          )
        ],
      ),
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

  bool isValidImageUrl(String? url) {
    if (url == null || url.isEmpty) return false;

    if (url.contains("tim thumb.php")) return false;

    if (!(url.endsWith(".png") ||
        url.endsWith(".jpg") ||
        url.endsWith(".jpeg") ||
        url.endsWith(".webp"))) return false;

    return true;
  }
}
