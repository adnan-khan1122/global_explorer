import 'package:equatable/equatable.dart';

class NewsArticle extends Equatable {
  const NewsArticle({
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
