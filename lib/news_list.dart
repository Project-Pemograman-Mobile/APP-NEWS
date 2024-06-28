import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:share/share.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';
import 'news_service.dart';
import 'news_model.dart';
import 'settings_page.dart'; // Import halaman SettingsPage
import 'about_page.dart'; // Import halaman AboutPage

class NewsList extends StatefulWidget {
  @override
  _NewsListState createState() => _NewsListState();
}

class _NewsListState extends State<NewsList> with SingleTickerProviderStateMixin {
  late Future<List<News>> futureNews;
  final RefreshController _refreshController = RefreshController(initialRefresh: false);
  List<News> _newsList = [];
  final List<Bookmark> _bookmarks = [];
  late TabController _tabController;
  final List<String> _categories = ['business', 'entertainment', 'health', 'science', 'sports', 'technology'];

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: _categories.length, vsync: this);
    _loadNews(category: _categories.first); // Load news for the first category initially
  }

  void _loadNews({required String category}) async {
    var newsList = await NewsService().fetchNews(category: category);
    setState(() {
      _newsList = newsList;
    });
    _refreshController.refreshCompleted();
  }

  void _onRefresh() async {
    _loadNews(category: _categories[_tabController.index]);
  }

  void _onSearch(String query) async {
    if (query.isNotEmpty) {
      var searchResults = await NewsService().searchNews(query);
      setState(() {
        _newsList = searchResults;
      });
    } else {
      _loadNews(category: _categories[_tabController.index]);
    }
  }

  void _addToBookmarks(News news) {
    setState(() {
      _bookmarks.add(Bookmark(
        title: news.title,
        description: news.description,
        imageUrl: news.imageUrl,
        url: news.url,
      ));
    });
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Article bookmarked')));
  }

  void _removeFromBookmarks(News news) {
    setState(() {
      _bookmarks.removeWhere((bookmark) => bookmark.url == news.url);
    });
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Article removed from bookmarks')));
  }

  bool isBookmarked(News news) {
    return _bookmarks.any((bookmark) => bookmark.url == news.url);
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('News App'),
        actions: [
          IconButton(
            icon: Icon(Icons.search),
            onPressed: () {
              showSearch(context: context, delegate: NewsSearchDelegate(onSearch: _onSearch));
            },
          ),
          IconButton(
            icon: Icon(Icons.bookmark),
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => BookmarkList(bookmarks: _bookmarks),
                ),
              );
            },
          ),
          PopupMenuButton<String>(
            onSelected: (value) {
              if (value == 'settings') {
                // Navigasi ke halaman SettingsPage
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => SettingsPage()),
                );
              } else if (value == 'about') {
                // Navigasi ke halaman AboutPage
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => AboutPage()),
                );
              }
            },
            itemBuilder: (BuildContext context) => <PopupMenuEntry<String>>[
              const PopupMenuItem<String>(
                value: 'settings',
                child: ListTile(
                  leading: Icon(Icons.settings),
                  title: Text('Settings'),
                ),
              ),
              const PopupMenuItem<String>(
                value: 'about',
                child: ListTile(
                  leading: Icon(Icons.info),
                  title: Text('About'),
                ),
              ),
            ],
          ),
        ],
        bottom: TabBar(
          controller: _tabController,
          isScrollable: true,
          tabs: _categories.map((category) => Tab(text: category.capitalize())).toList(),
          onTap: (index) {
            _loadNews(category: _categories[index]);
          },
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          _refreshController.requestRefresh();
          _onRefresh();
        },
        child: Icon(Icons.refresh),
      ),
      body: SmartRefresher(
        controller: _refreshController,
        onRefresh: _onRefresh,
        child: _buildNewsList(),
      ),
    );
  }

  Widget _buildNewsList() {
    return ListView.builder(
      itemCount: _newsList.length,
      itemBuilder: (context, index) {
        return GestureDetector(
          onTap: () {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => NewsDetail(news: _newsList[index]),
              ),
            );
          },
          child: Card(
            elevation: 5,
            margin: EdgeInsets.all(10.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Container(
                  height: 150,
                  decoration: BoxDecoration(
                    image: DecorationImage(
                      image: _newsList[index].imageUrl.isNotEmpty
                          ? NetworkImage(_newsList[index].imageUrl)
                          : AssetImage('assets/placeholder_image.png'),
                      fit: BoxFit.cover,
                    ),
                  ),
                ),
                Padding(
                  padding: EdgeInsets.all(10),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        _newsList[index].title,
                        style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                      ),
                      SizedBox(height: 5),
                      Text(
                        _newsList[index].description,
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                      ),
                      SizedBox(height: 10),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.end,
                        children: [
                          IconButton(
                            icon: Icon(Icons.bookmark),
                            onPressed: () {
                              if (!isBookmarked(_newsList[index])) {
                                _addToBookmarks(_newsList[index]);
                              } else {
                                _removeFromBookmarks(_newsList[index]);
                              }
                            },
                          ),
                          IconButton(
                            icon: Icon(Icons.share),
                            onPressed: () {
                              _shareArticle(_newsList[index]);
                            },
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  void _shareArticle(News news) {
    final RenderBox box = context.findRenderObject() as RenderBox;
    final String text = '${news.title}\n${news.url}';

    Share.share(
      text,
      subject: news.title,
      sharePositionOrigin: box.localToGlobal(Offset.zero) & box.size,
    );
  }
}

class NewsDetail extends StatelessWidget {
  final News news;

  NewsDetail({required this.news});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(news.title),
      ),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Container(
              height: 200,
              decoration: BoxDecoration(
                image: DecorationImage(
                  image: news.imageUrl.isNotEmpty ? NetworkImage(news.imageUrl) : AssetImage('assets/placeholder_image.png'),
                  fit: BoxFit.cover,
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  SizedBox(height: 16),
                  Text(news.title, style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold)),
                  SizedBox(height: 8),
                  Text(news.description),
                  SizedBox(height: 16),
                  ElevatedButton(
                    onPressed: () => _launchURL(news.url),
                    child: Text('Read more'),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _launchURL(String url) async {
    if (await canLaunch(url)) {
      await launch(url);
    } else {
      throw 'Could not launch $url';
    }
  }
}

class BookmarkList extends StatelessWidget {
  final List<Bookmark> bookmarks;

  BookmarkList({required this.bookmarks});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Bookmarks'),
      ),
      body: ListView.builder(
        itemCount: bookmarks.length,
        itemBuilder: (context, index) {
          return ListTile(
            title: Text(bookmarks[index].title),
            subtitle: Text(bookmarks[index].description),
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => NewsDetail(
                    news: News(
                      title: bookmarks[index].title,
                      description: bookmarks[index].description,
                      imageUrl: bookmarks[index].imageUrl,
                      url: bookmarks[index].url,
                    ),
                  ),
                ),
              );
            },
          );
        },
      ),
    );
  }
}

class NewsSearchDelegate extends SearchDelegate {
  final Function(String) onSearch;

  NewsSearchDelegate({required this.onSearch});

  @override
  List<Widget> buildActions(BuildContext context) {
    return [
      IconButton(
        icon: Icon(Icons.clear),
        onPressed: () {
          query = '';
          onSearch('');
        },
      ),
    ];
  }

  @override
  Widget buildLeading(BuildContext context) {
    return IconButton(
      icon: Icon(Icons.arrow_back),
      onPressed: () {
        close(context, null);
      },
    );
  }

  @override
  Widget buildResults(BuildContext context) {
    onSearch(query);
    close(context, null);
    return Container();
  }

  @override
  Widget buildSuggestions(BuildContext context) {
    return Container();
  }
}

extension StringExtension on String {
  String capitalize() {
    return "${this[0].toUpperCase()}${this.substring(1)}";
  }
}

class Bookmark {
  final String title;
  final String description;
  final String imageUrl;
  final String url;

  Bookmark({
    required this.title,
    required this.description,
    required this.imageUrl,
    required this.url,
  });
}
