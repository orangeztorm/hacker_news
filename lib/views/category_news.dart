import 'package:flutter/material.dart';
import 'package:hacker_news/helper/news.dart';
import 'package:hacker_news/models/article_model.dart';

import 'home.dart';

class CategoryNews extends StatefulWidget {
  final String category;

  const CategoryNews({Key key, this.category}) : super(key: key);
  @override
  _CategoryNewsState createState() => _CategoryNewsState();
}

class _CategoryNewsState extends State<CategoryNews> {
  List<ArticleModel> articles = new List();
  bool _isLoading = true;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    getCategoryNews();
  }
  getCategoryNews() async {
    CategoryNewsClass categoryNews = CategoryNewsClass();
    await categoryNews.getCategoryNews(category: widget.category);
    articles = categoryNews.news;
    setState(() {
      _isLoading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text('Flutter'),
            Text(
              'News',
              style: TextStyle(color: Colors.blue),
            ),
          ],
        ),
        actions: [
          Opacity(
            opacity: 0,
            child: Container(
              padding: EdgeInsets.symmetric(horizontal: 16),
              child: Icon(Icons.save),
            ),
          )
        ],
        elevation: 0,
      ),
      body: Container(
        child: Column(
          children: [
            /// Blogs
            Container(
              padding: EdgeInsets.symmetric(horizontal: 16),
              child: ListView.builder(
                padding: EdgeInsets.only(top: 20),
                shrinkWrap: true,
                physics: ClampingScrollPhysics(),
                itemCount: articles.length,
                itemBuilder: (context, index) {
                  return BlogTile(
                    imageUrl: articles[index].urlToImage,
                    title: articles[index].title,
                    desc: articles[index].description,
                    url: articles[index].url,
                  );
                },
              ),
            )
          ],
        ),
      )
    );
  }
}
