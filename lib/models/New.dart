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

  News({
    this.id,
    this.domain,
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
          ? DateTime.tryParse(json['published_at'])
          : null,

      sentiment: json['sentiment'] as String?,
      category: json['category'] as String?,

      isPlagiat: json['is_plagiat'] is bool
          ? json['is_plagiat']
          : json['is_plagiat']?.toString() == 'true',

      imageUrl: json['image_url'] as String?,

      scrapedAt: json['scraped_at'] != null
          ? DateTime.tryParse(json['scraped_at'])
          : null,

      isSaved: json['is_saved'] as bool?,
      similarsCount: json['similars_count'] as int?,

      similarNews: (json['similar_news'] as List?)
          ?.map((e) => News.fromJson(e))
          .toList(),
    );
  }

  @override
  String toString() {
    return "${title} ${domain}";
  }
}
