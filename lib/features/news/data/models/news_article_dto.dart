import 'package:equatable/equatable.dart';

class NewsArticleDto extends Equatable {
  const NewsArticleDto({
    required this.title,
    required this.url,
    this.description,
    this.urlToImage,
    this.publishedAt,
    this.sourceName,
  });

  final String title;
  final String url;
  final String? description;
  final String? urlToImage;
  final String? publishedAt;
  final String? sourceName;

  static NewsArticleDto? fromNewsApiJson(Map<String, dynamic> json) {
    final title = json['title'] as String?;
    final url = json['url'] as String?;
    if (title == null || title.isEmpty || url == null || url.isEmpty) {
      return null;
    }
    final source = json['source'] as Map<String, dynamic>?;
    return NewsArticleDto(
      title: title,
      url: url,
      description: json['description'] as String?,
      urlToImage: json['urlToImage'] as String?,
      publishedAt: json['publishedAt'] as String?,
      sourceName: source?['name'] as String?,
    );
  }

  @override
  List<Object?> get props => [
    title,
    url,
    description,
    urlToImage,
    publishedAt,
    sourceName,
  ];
}
