import '../../domain/entities/news_article.dart';
import '../../domain/repositories/news_repository.dart';
import '../datasources/news_remote_data_source.dart';
import '../mappers/news_article_mapper.dart';

class NewsRepositoryImpl implements NewsRepository {
  NewsRepositoryImpl({required NewsRemoteDataSource remote}) : _remote = remote;

  final NewsRemoteDataSource _remote;

  @override
  Future<List<NewsArticle>> topHeadlinesByCountry({
    required String cca2,
    int pageSize = 10,
  }) async {
    final dtos = await _remote.fetchTopHeadlinesByCountry(
      cca2: cca2,
      pageSize: pageSize,
    );
    return dtos.map(NewsArticleMapper.toEntity).toList(growable: false);
  }
}
