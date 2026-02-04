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
    List<News> parsedSimilars = [];

    var similarData = json['similar_news'] ?? json['similarNews'];

    if (similarData != null && similarData is List) {
      parsedSimilars = similarData.map((item) {
        final m = item as Map<String, dynamic>;
        return News(
          id: m['id'] as int?,
          title: m['title'] as String?,
          domain: m['domain'] as String?,
          imageUrl: m['image_url'] as String?,
          similarNews: [],
          isSaved: m['is_saved'] as bool? ?? false,
        );
      }).toList();
    }

    return News(
      id: json['id'] as int?,
      title: json['title'] as String?,
      text: json['text'] as String?,
      imageUrl: json['image_url'] as String?,
      url: json['url'] as String?,
      category: json['category'] as String?,
      similarNews: parsedSimilars,
      domain: json['domain'] as String?,
      isSaved: json['is_saved'] as bool? ?? false,
      scrapedAt: json['scraped_at'] != null ? DateTime.tryParse(json['scraped_at'].toString()) : null,
    );
  }

  @override
  String toString() {
    return "Xəbər ID: $id | Oxşar sayı: ${similarNews?.length ?? 0}";
  }

  factory News.fromTelegramJson(Map<String, dynamic> json) {
    String? getFirstValidPath(dynamic images) {
      if (images is List && images.isNotEmpty) {
        final first = images[0]?.toString();
        if (first == null || first.isEmpty || first.toLowerCase() == "null") return null;
        return first;
      }
      return null;
    }
    return News(
      id: json['message_id'] as int?,
      domain: json['channel_name'] as String?,
      url: json['link_for_post'] as String?,
      title: json['channel_username'] as String?,
      scrapedAt: json['post_scrape_date'] != null ? DateTime.tryParse(json['post_scrape_date'].toString()) : null,
      text: json['post_content'] as String?,
      channel_Id: json['channel_id'] ?? 0,
      channelImage: getFirstValidPath(json['channel_image_filenames']),
      imageUrl: getFirstValidPath(json['post_image_filenames']),
      isSaved: json['is_favourite'] as bool? ?? false,
      similarNews: [],
    );
  }


}