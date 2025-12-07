import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:news_app/api/api_constants.dart';
import 'package:news_app/api/end_point.dart';
import 'package:news_app/models/NewsResponse.dart';
import 'package:news_app/models/SourceResponse.dart';

class ApiManger {
  static final Map<String, dynamic> _cache = {};
  static final Map<String, DateTime> _cacheTime = {};
  static const Duration _cacheDuration = Duration(minutes: 30);

  static bool _isCacheValid(String key) {
    if (!_cache.containsKey(key)) return false;
    final cacheTime = _cacheTime[key];
    if (cacheTime == null) return false;
    return DateTime.now().difference(cacheTime) < _cacheDuration;
  }

  static Future<SourceResponse> getSources({String? category}) async {
    print("=== getSources called ===");
    print("Category: $category");

    final cacheKey = 'sources_${category ?? 'all'}';

    if (_isCacheValid(cacheKey)) {
      print("Returning cached sources for: $cacheKey");
      return _cache[cacheKey] as SourceResponse;
    }

    Map<String, dynamic> queryParams = {
      "apiKey": ApiConstants.apiKey,
    };
    if (category != null) {
      queryParams["category"] = category;
    }

    Uri url = Uri.https(
      ApiConstants.baseUrl,
      EndPoint.apiSource,
      queryParams,
    );

    print("API URL: $url");

    try {
      var response = await http.get(url);
      print("Response status code: ${response.statusCode}");

      String responseBody = response.body;
      var json = jsonDecode(responseBody);

      print("Parsed JSON: $json");

      var sourceResponse = SourceResponse.fromJson(json);
      print("SourceResponse status: ${sourceResponse.status}");
      print("SourceResponse sources count: ${sourceResponse.sources?.length ?? 0}");

      if (sourceResponse.status == "ok") {
        _cache[cacheKey] = sourceResponse;
        _cacheTime[cacheKey] = DateTime.now();
        print("Cached sources for: $cacheKey");
      }

      return sourceResponse;
    } catch (e) {
      print("Error in getSources: $e");
      rethrow;
    }
  }

  // Updated getNews method with pagination support
  static Future<NewsResponse> getNews(String sourceId, {int page = 1, int pageSize = 10}) async {
    print("=== getNews called ===");
    print("Source ID: $sourceId, Page: $page");

    // Don't cache paginated results
    Uri url = Uri.https(ApiConstants.baseUrl, EndPoint.NewsApi, {
      "apiKey": ApiConstants.apiKey,
      "sources": sourceId,
      "page": page.toString(),
      "pageSize": pageSize.toString(),
    });

    print("API URL: $url");

    try {
      var response = await http.get(url);
      print("Response status code: ${response.statusCode}");

      String responseBody = response.body;
      var json = jsonDecode(responseBody);

      print("Parsed JSON status: ${json['status']}");
      print("Articles count: ${json['articles']?.length ?? 0}");
      print("Total results: ${json['totalResults']}");

      var newsResponse = NewsResponse.fromJson(json);

      return newsResponse;
    } catch (e) {
      print("Error in getNews: $e");
      rethrow;
    }
  }

  static void clearCache() {
    _cache.clear();
    _cacheTime.clear();
  }

  static Future<NewsResponse> searchNews(String query, {int page = 1, int pageSize = 10}) async {
    try {
      Uri url = Uri.https(
        ApiConstants.baseUrl,
        EndPoint.NewsApi,
        {
          "q": query,
          "searchIn": "title,description,content",
          "apiKey": ApiConstants.apiKey,
          "page": page.toString(),
          "pageSize": pageSize.toString(),
        },
      );

      var response = await http.get(url);

      if (response.statusCode != 200) {
        return NewsResponse(status: "error", articles: []);
      }

      var json = jsonDecode(response.body);
      NewsResponse data = NewsResponse.fromJson(json);

      data.articles ??= [];

      // فلترة الصور الغير صالحة
      data.articles!.removeWhere(
            (news) =>
        news.urlToImage == null ||
            news.urlToImage!.isEmpty ||
            !news.urlToImage!.startsWith("http") ||
            news.urlToImage!.contains("tim thumb.php") ||
            news.urlToImage!.contains("?src="),
      );

      return data;

    } catch (e) {
      return NewsResponse(status: "error", articles: []);
    }
  }
}
