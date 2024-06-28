// news_service.dart

import 'dart:convert';
import 'package:http/http.dart' as http;
import 'news_model.dart';

class NewsService {
  final String apiKey = "198a91fd521a4cefbbad1b2e193415cd";
  final String baseUrl =
      "https://newsapi.org/v2/top-headlines?country=id&apiKey=198a91fd521a4cefbbad1b2e193415cd";

  Future<List<News>> fetchNews({String? category}) async {
    String apiUrl = baseUrl;
    if (category != null && category.isNotEmpty) {
      apiUrl += "&category=$category";
    }

    final response = await http.get(Uri.parse(apiUrl));

    if (response.statusCode == 200) {
      List jsonResponse = json.decode(response.body)['articles'];
      return jsonResponse.map((news) => News.fromJson(news)).toList();
    } else {
      throw Exception('Failed to load news');
    }
  }

  Future<List<News>> fetchNewsByDateRange(
      DateTime startDate, DateTime endDate) async {
    final String from = "${startDate.year}-${startDate.month}-${startDate.day}";
    final String to = "${endDate.year}-${endDate.month}-${endDate.day}";

    final String apiUrl = "$baseUrl&from=$from&to=$to";

    final response = await http.get(Uri.parse(apiUrl));

    if (response.statusCode == 200) {
      List jsonResponse = json.decode(response.body)['articles'];
      return jsonResponse.map((news) => News.fromJson(news)).toList();
    } else {
      throw Exception('Failed to load news');
    }
  }

  Future<List<News>> searchNews(String query) async {
    final String searchUrl =
        "https://newsapi.org/v2/everything?q=$query&apiKey=$apiKey";
    final response = await http.get(Uri.parse(searchUrl));

    if (response.statusCode == 200) {
      List jsonResponse = json.decode(response.body)['articles'];
      return jsonResponse.map((news) => News.fromJson(news)).toList();
    } else {
      throw Exception('Failed to search news');
    }
  }
}
