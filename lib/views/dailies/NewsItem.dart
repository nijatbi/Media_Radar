import 'package:flutter/cupertino.dart' show CupertinoActivityIndicator;
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:media_radar/constants/Constant.dart';
import 'package:media_radar/providers/AuthProvider.dart';
import 'package:media_radar/providers/FavouriteProvider.dart';
import 'package:media_radar/providers/NewsProvider.dart';
import 'package:media_radar/services/NewsService.dart';
import 'package:media_radar/views/Favourites/Selected%C4%B0temforList.dart';
import 'package:provider/provider.dart';

import '../../models/New.dart';
import '../../services/SecureStorageService.dart';

class NewsItem extends StatefulWidget {
  final String? image;
  final String? title;
  final String? text;
  final String date;
  final int? channelId;
  final bool? isSaved;
  final String? categoryName;
  final int id;
  final List<News>? similiarNews;
  final String? descFull;

  const NewsItem({
    super.key,
    this.image,
    this.similiarNews,
    this.channelId,
    this.descFull,
    this.isSaved,
    this.categoryName,
    this.title,
    this.text,
    required this.id,
    required this.date,
  });

  @override
  State<NewsItem> createState() => _NewsItemState();
}

class _NewsItemState extends State<NewsItem> {
  String? _token;
  bool _isTokenLoaded = false;
  List<News> similiarNews=[];


  @override
  void initState() {
    super.initState();
    getSimiliarNews();
    _loadInitialData();
  }

  Future<void> getSimiliarNews() async {
    final response = await NewsService.getSimiliarsNews(widget.id);

    if (response == null || response.isEmpty) {
      if (mounted) {
        setState(() {
          similiarNews = [];
        });
      }
    } else {
      if (mounted) {
        setState(() {
          similiarNews = response;
        });
      }
    }
  }

  Future<void> _loadInitialData() async {
    final token = await SecureStorageService.getToken();
    if (mounted) {
      setState(() {
        _token = token;
        _isTokenLoaded = true;
      });
    }
  }

  List<TextSpan> _getHighlightedText(String fullText, List<String> keywords) {
    if (keywords.isEmpty) return [TextSpan(text: fullText)];

    final String patternString = keywords.map((k) => RegExp.escape(k)).join('|');
    final pattern = RegExp('($patternString)', caseSensitive: false);
    final matches = pattern.allMatches(fullText);

    List<TextSpan> spans = [];
    int lastMatchEnd = 0;

    for (final match in matches) {
      if (match.start > lastMatchEnd) {
        spans.add(TextSpan(text: fullText.substring(lastMatchEnd, match.start)));
      }
      spans.add(TextSpan(
        text: fullText.substring(match.start, match.end),
        style: TextStyle(
          backgroundColor: Colors.yellow.withOpacity(0.7),
          color: Colors.black,
          fontWeight: FontWeight.bold,
        ),
      ));
      lastMatchEnd = match.end;
    }

    if (lastMatchEnd < fullText.length) {
      spans.add(TextSpan(text: fullText.substring(lastMatchEnd)));
    }

    return spans;
  }

  String _formatDate(String rawDate) {
    if (rawDate.isEmpty) return "";
    try {
      return rawDate.split('.').first;
    } catch (e) {
      return rawDate;
    }
  }

  bool _isValidUrl(String? url) {
    if (url == null || url.trim().isEmpty || url.toLowerCase() == "null") return false;
    return url.startsWith('http');
  }

  void copyNewsLink(int id, String date) {
    final String shareLink = "https://www.mediaradar.com/newsItem?id=$id&date=$date";
    Clipboard.setData(ClipboardData(text: shareLink)).then((_) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Link kopyalandı!")),
      );
    });
  }


  void showModalSimiliarNews(BuildContext context){
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.transparent,
      isScrollControlled: true,
      builder: (context) {
        return StatefulBuilder(
          builder: (context, modalSetState) {
            return Container(
              height: MediaQuery.of(context).size.height * 0.6,
              decoration: const BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
              ),
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 24),
                child: Stack(
                  children: [
                    SingleChildScrollView(
                      padding: const EdgeInsets.only(bottom: 100),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const SizedBox(height: 12),
                          Center(
                            child: Container(
                              width: 80,
                              height: 4,
                              decoration: BoxDecoration(
                                color: Colors.black26,
                                borderRadius: BorderRadius.circular(2),
                              ),
                            ),
                          ),
                          const SizedBox(height: 30),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                               Text(
                                'Oxşar xəbərlər ${widget.similiarNews!.length}',
                                style: TextStyle(
                                    fontSize: 15, fontWeight: FontWeight.w500),
                              ),
                              GestureDetector(
                                onTap: () => Navigator.pop(context),
                                child: Text(
                                  'İmtina et',
                                  style: TextStyle(
                                      fontSize: 15, color: Constant.baseColor),
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: 30),

                          ListView.builder(
                            shrinkWrap: true,
                            physics: const NeverScrollableScrollPhysics(),
                            itemCount: widget.similiarNews!.length,
                            itemBuilder: (context, index) {
                              return SelectedItemForList(news: widget.similiarNews![index]);
                            },
                          )


                        ],
                      ),
                    ),

                  ],
                ),
              ),
            );
          },
        );
      },
    );
  }


  @override
  Widget build(BuildContext context) {
    final newsProvider = Provider.of<NewsProvider>(context, listen: false);
    final favouriteProvider = Provider.of<FavouriteProvider>(context);
    final authProvider = Provider.of<AuthProvider>(context);
    List<String> allKeywords = [];
    if (authProvider.user?.streams != null) {
      for (var stream in authProvider.user!.streams!) {
        if (stream.is_active == true) {
          allKeywords.addAll(stream.keywords?.map((k) => k.value ?? "").toList() ?? []);
        }
      }
    }
    allKeywords = allKeywords.where((k) => k.isNotEmpty).toSet().toList();

    int foundCount = 0;
    if (widget.text != null && allKeywords.isNotEmpty) {
      final String patternString = allKeywords.map((k) => RegExp.escape(k)).join('|');
      final pattern = RegExp('($patternString)', caseSensitive: false);
      foundCount = pattern.allMatches(widget.text!).length;
    }
    final bool isSavedLocally = favouriteProvider.isItemSaved(widget.id);
    return Scaffold(
      backgroundColor: Colors.white,
      extendBodyBehindAppBar: true,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios_new, color: Colors.white),
          onPressed: () => Navigator.pop(context),
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.link, color: Colors.white),
            onPressed: () => copyNewsLink(widget.id, widget.date),
          ),
          favouriteProvider.isLoading
              ? const Padding(
            padding: EdgeInsets.symmetric(horizontal: 12.0),
            child: CupertinoActivityIndicator(color: Colors.white),
          )
              : IconButton(
            icon: Icon(
              isSavedLocally ? Icons.bookmark : Icons.bookmark_border,
              color: isSavedLocally ? Colors.amber : Colors.white,
            ),
            onPressed: () {
              if (newsProvider.statucCode == 1) {
                isSavedLocally
                    ? favouriteProvider.deleteNewsFromMainProvider(widget.id, newsProvider)
                    : favouriteProvider.addNewsToFavourite(widget.id, newsProvider);
              } else {
                isSavedLocally
                    ? favouriteProvider.deleteNewsFromTelegram(widget.channelId, widget.id, newsProvider)
                    : favouriteProvider.addNewsToFavouriteInTelegram(widget.channelId!, widget.id, newsProvider);
              }
            },
          ),
          IconButton(
            icon: const Icon(Icons.ios_share, color: Colors.white),
            onPressed: () {},
          ),
        ],
      ),
      body: Stack(
        children: [
          SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Hero(
                  tag: widget.id,
                  child: Stack(
                    children: [
                      _buildImageSection(newsProvider.statucCode),
                      Container(
                        height: 120,
                        decoration: BoxDecoration(
                          gradient: LinearGradient(
                            begin: Alignment.topCenter,
                            end: Alignment.bottomCenter,
                            colors: [Colors.black.withOpacity(0.4), Colors.transparent],
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.only(left: 20,right: 20,top: 10),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      widget.similiarNews!.isNotEmpty
                          ? Column(
                            children: [
                              GestureDetector(
                                onTap: (){
                                  showModalSimiliarNews(context);
                                },
                                child: Container(
                                        padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 5),
                                        decoration: BoxDecoration(
                                             borderRadius: BorderRadius.circular(25),
                                         color: Constant.baseColor,
                                          ),
                                          child: Text(
                                         '${widget.similiarNews!.length} Oxşar xəbər',
                                       style: const TextStyle(fontSize: 14, color: Colors.white),
                                       ),
                                                            ),
                              ),
                              SizedBox(height: 20,),
                            ],
                          )
                          : const SizedBox.shrink(),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Container(
                            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                            decoration: BoxDecoration(
                              color: Colors.green.withOpacity(0.1),
                              borderRadius: BorderRadius.circular(10),
                            ),
                            child:  Text("${widget.categoryName!}", style: TextStyle(color: Colors.green, fontWeight: FontWeight.bold)),
                          ),
                          Text(_formatDate(widget.date), style: const TextStyle(color: Colors.grey, fontSize: 13)),
                        ],
                      ),
                      const SizedBox(height: 15),
                      Text(
                        widget.title ?? "",
                        style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold, height: 1.2),
                      ),
                      const SizedBox(height: 15),
                      const Divider(),
                      const SizedBox(height: 15),
                      RichText(
                        text: TextSpan(
                          style: const TextStyle(fontSize: 16, color: Colors.black87, height: 1.6, letterSpacing: 0.3),
                          children: _getHighlightedText(widget.text ?? "", allKeywords),
                        ),
                      ),
                      const SizedBox(height: 120),
                    ],
                  ),
                ),
              ],
            ),
          ),
          _buildFloatingBadge(foundCount),
        ],
      ),
    );
  }

  Widget _buildImageSection(int statusCode) {
    if (!_isValidUrl(widget.image)) return _buildErrorPlaceholder();

    if (statusCode == 1) {
      return Image.network(
        widget.image!.trim(),
        fit: BoxFit.cover,
        width: double.infinity,
        height: MediaQuery.of(context).size.height * 0.45,
        errorBuilder: (context, error, stackTrace) => _buildErrorPlaceholder(),
      );
    }

    if (!_isTokenLoaded) {
      return Container(
        width: double.infinity,
        height: MediaQuery.of(context).size.height * 0.45,
        color: Colors.grey[100],
        child: const Center(child: CupertinoActivityIndicator()),
      );
    }

    return Image.network(
      widget.image!.trim(),
      fit: BoxFit.cover,
      width: double.infinity,
      height: MediaQuery.of(context).size.height * 0.45,
      headers: {'Authorization': "Bearer $_token"},
      errorBuilder: (context, error, stackTrace) => _buildErrorPlaceholder(),
      loadingBuilder: (context, child, loadingProgress) {
        if (loadingProgress == null) return child;
        return Container(
          width: double.infinity,
          height: MediaQuery.of(context).size.height * 0.45,
          color: Colors.grey[100],
          child: const Center(child: CupertinoActivityIndicator()),
        );
      },
    );
  }

  Widget _buildFloatingBadge(int foundCount) {
    return Positioned(
      bottom: 30,
      left: 0,
      right: 0,
      child: Center(
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 25, vertical: 12),
          decoration: BoxDecoration(
            color: Colors.black.withOpacity(0.85),
            borderRadius: BorderRadius.circular(35),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.3),
                blurRadius: 15,
                offset: const Offset(0, 8),
              )
            ],
          ),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              const Icon(Icons.star, color: Colors.amber, size: 18),
              const SizedBox(width: 10),
              Text(
                foundCount > 0
                    ? "Tapılan açar sözlər: $foundCount"
                    : "Tapılan açar sözlər : 0",
                style: const TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                    fontSize: 14
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildErrorPlaceholder() {
    return Container(
      width: double.infinity,
      height: MediaQuery.of(context).size.height * 0.45,
      color: Colors.grey[300],
      child: const Icon(Icons.broken_image, size: 50, color: Colors.grey),
    );
  }
}