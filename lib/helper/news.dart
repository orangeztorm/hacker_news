import 'dart:convert';

import 'package:hacker_news/models/article_model.dart';
import 'package:http/http.dart' as http;

class News {
  List<ArticleModel> news = [];

  Future<void> getNews() async {
    String url =
        'https://newsapi.org/v2/top-headlines?country=us&category=business&apiKey=ae370509b1e24f268396c64957fd223a';

    var response = await http.get(url);
    var jsonData = jsonDecode(response.body);
    print(response.statusCode);

    if (jsonData['status'] == 'ok') {
      jsonData['articles'].forEach((element) {
        if (element["urlToImage"] != null && element['description'] != null) {
          ArticleModel articleModel = ArticleModel(
              title: element['title'],
              content: element['content'],
              author: element['author'],
              description: element['description'],
              url: element['url'],
              urlToImage: element['urlToImage'],
              publishedAt: element['publishedAt']);
          news.add(articleModel);
        }
      });
    }
  }
}

class CategoryNewsClass {
  List<ArticleModel> news = [];

  Future<void> getCategoryNews({String category}) async {
    String url =
        'https://newsapi.org/v2/top-headlines?country=us&category=$category&apiKey=ae370509b1e24f268396c64957fd223a';

    var response = await http.get(url);

    var jsonData = jsonDecode(response.body);

    if (jsonData['status'] == "ok") {
      jsonData["articles"].forEach((element) {
        if (element['urlToImage'] != null && element['description'] != null) {
          ArticleModel article = ArticleModel(
            title: element['title'],
            author: element['author'],
            description: element['description'],
            urlToImage: element['urlToImage'],
            content: element["content"],
            publishedAt: element['publishedAt'],
            url: element["url"],
          );
          news.add(article);
        }
      });
    }
  }
}
