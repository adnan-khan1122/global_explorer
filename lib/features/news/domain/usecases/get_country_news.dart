import '../../../../core/errors/failuers.dart';
import '../../../../core/types/result.dart';
import '../../../../core/usecase/usecase.dart';
import '../entities/news_article.dart';
import '../repositories/news_repository.dart';

class GetCountryNews implements UseCase<List<NewsArticle>, String> {
  GetCountryNews(this._repository);

  final NewsRepository _repository;

  @override
  Future<Result<List<NewsArticle>>> call(String cca2) async {
    try {
      final articles = await _repository.topHeadlinesByCountry(cca2: cca2);
      return Success(articles);
    } catch (e) {
      return Failure(NetworkFailure(e.toString()));
    }
  }
}
