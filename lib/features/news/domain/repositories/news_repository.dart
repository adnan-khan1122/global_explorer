import '../entities/news_article.dart';

abstract class NewsRepository {
  Future<List<NewsArticle>> topHeadlinesByCountry({
    required String cca2,
    int pageSize = 10,
  });
}
