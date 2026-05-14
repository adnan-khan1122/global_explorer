import '../../domain/entities/news_article.dart';
import '../models/news_article_dto.dart';

class NewsArticleMapper {
  const NewsArticleMapper._();

  static NewsArticle toEntity(NewsArticleDto dto) => NewsArticle(
    title: dto.title,
    url: dto.url,
    description: dto.description,
    urlToImage: dto.urlToImage,
    publishedAt: dto.publishedAt,
    sourceName: dto.sourceName,
  );
}
