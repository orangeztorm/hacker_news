import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:hacker_news/helper/data.dart';
import 'package:hacker_news/helper/news.dart';
import 'package:hacker_news/models/article_model.dart';
import 'package:hacker_news/models/category_model.dart';
import 'package:hacker_news/views/article_view.dart';

import 'category_news.dart';

class Home extends StatefulWidget {
  @override
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<Home> {
  List<CategoryModel> categories = new List<CategoryModel>();
  List<ArticleModel> articles = new List<ArticleModel>();

  bool _loading = true;

  @override
  void initState() {
    super.initState();
    categories = getCategories();
    getNews();
  }

  getNews() async {
    News newsClass = News();
    await newsClass.getNews();
    articles = newsClass.news;
    setState(() {
      _loading = false;
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
        elevation: 0,
      ),
      body: _loading
          ? Container(
              child: Center(
                child: CircularProgressIndicator(),
              ),
            )
          : SingleChildScrollView(
              child: Container(
                  child: Column(
                children: [
                  Container(
                    height: 70,
                    child: ListView.builder(
                      itemCount: categories.length,
                      shrinkWrap: true,
                      scrollDirection: Axis.horizontal,
                      itemBuilder: (context, index) {
                        return CategoryTile(
                          categoryName: categories[index].categoryName,
                          imageUrl: categories[index].imageAssetUrl,
                        );
                      },
                    ),
                  ),

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
              )),
            ),
    );
  }
}

class CategoryTile extends StatelessWidget {
  final imageUrl, categoryName;

  const CategoryTile({Key key, this.imageUrl, this.categoryName})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        Navigator.push(context, MaterialPageRoute(builder: (context) => CategoryNews(
          category: categoryName.toString().toLowerCase(),
        )));
      },
      child: Container(
        margin: EdgeInsets.symmetric(horizontal: 8),
        alignment: Alignment.center,
        child: Stack(
          children: [
            ClipRRect(
                borderRadius: BorderRadius.circular(6),
                child: CachedNetworkImage(
                  imageUrl: imageUrl,
                  width: 120,
                  height: 60,
                  fit: BoxFit.cover,
                )),
            Container(
              width: 120,
              height: 60,
              decoration: BoxDecoration(
                  color: Colors.black26,
                  borderRadius: BorderRadius.circular(6)),
              alignment: Alignment.center,
              child: Text(
                categoryName,
                textAlign: TextAlign.center,
                style: TextStyle(
                    color: Colors.white,
                    fontSize: 14,
                    fontWeight: FontWeight.w500),
              ),
            )
          ],
        ),
      ),
    );
  }
}

class BlogTile extends StatelessWidget {
  final String title, imageUrl, desc, url;

  const BlogTile({Key key, this.title, this.imageUrl, this.desc, this.url})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        Navigator.push(
            context, MaterialPageRoute(builder: (context) => ArticleView(
          blogUrl: url,
        )));
      },
      child: Container(
          margin: EdgeInsets.only(bottom: 16),
          child: Column(
            children: [
              ClipRRect(
                  borderRadius: BorderRadius.circular(6),
                  child: CachedNetworkImage(imageUrl: imageUrl)),
              Text(title,
                  style: TextStyle(
                      fontSize: 18,
                      color: Colors.black87,
                      fontWeight: FontWeight.w600)),
              SizedBox(
                height: 8,
              ),
              Text(desc, style: TextStyle(color: Colors.black54)),
            ],
          )),
    );
  }
}
