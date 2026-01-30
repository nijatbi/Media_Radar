class News {
  final int? id;
  final String? domain;
  final String? url;
  final String? title;
  final String? text;
  final DateTime? publishedAt;
  final String? sentiment;
  final String? category;
  final bool? isPlagiat;
  final String? imageUrl;
  final DateTime? scrapedAt;
  final bool? isSaved;
  final int? similarsCount;
  final List<News>? similarNews;
  final String? channelImage;
  final int? channel_Id;

  News({
    this.id,
    this.channelImage,
    this.domain,
    this.channel_Id,
    this.url,
    this.title,
    this.text,
    this.publishedAt,
    this.sentiment,
    this.category,
    this.isPlagiat,
    this.imageUrl,
    this.scrapedAt,
    this.isSaved,
    this.similarsCount,
    this.similarNews,
  });

  factory News.fromJson(Map<String, dynamic> json) {
    return News(
      id: json['id'] as int?,
      domain: json['domain'] as String?,
      url: json['url'] as String?,
      title: json['title'] as String?,
      text: json['text'] as String?,
      publishedAt: json['published_at'] != null
          ? DateTime.tryParse(json['published_at'].toString())
          : null,
      sentiment: json['sentiment'] as String?,
      category: json['category'] as String?,
      isPlagiat: json['is_plagiat'] is bool
          ? json['is_plagiat']
          : json['is_plagiat']?.toString() == 'true',
      imageUrl: json['image_url'] as String?,
      scrapedAt: json['scraped_at'] != null
          ? DateTime.tryParse(json['scraped_at'].toString())
          : null,
      isSaved: json['is_saved'] as bool?,
      similarsCount: json['similars_count'] as int?,

      similarNews: (json['similar_news'] != null && json['similar_news'] is List)
          ? (json['similar_news'] as List)
          .map((e) => News.fromJson(e as Map<String, dynamic>))
          .toList()
          : [],
    );
  }

  factory News.fromTelegramJson(Map<String, dynamic> json) {
    String? getFirstValidPath(dynamic images) {
      if (images is List && images.isNotEmpty) {
        final first = images[0]?.toString();
        if (first == null || first.isEmpty || first.toLowerCase() == "null") {
          return null;
        }
        return first;
      }
      return null;
    }

    return News(
      id:  json['message_id'] as int?,
      domain: json['channel_name'] as String?,
      url: json['link_for_post'] as String?,
      title: json['channel_username'] as String?,
      text: json['post_content'] as String?,
      channel_Id: json['channel_id']  ?? 0,
      channelImage: getFirstValidPath(json['channel_image_filenames']),
      imageUrl: getFirstValidPath(json['post_image_filenames']),
      publishedAt: json['post_publish_date'] != null
          ? DateTime.tryParse(json['post_publish_date'].toString())
          : null,
      scrapedAt: json['post_scrape_date'] != null
          ? DateTime.tryParse(json['post_scrape_date'].toString())
          : null,
      isSaved: json['is_favourite'] as bool? ?? false,
      category: '',
      similarsCount: 0,
      similarNews: (json['similar_news'] != null && json['similar_news'] is List)
          ? (json['similar_news'] as List)
          .map((e) => News.fromJson(e as Map<String, dynamic>))
          .toList()
          : [],
    );
  }

  @override
  String toString() {
    return "${title} ${domain}";
  }
}