import '../../../../core/errors/failuers.dart';
import '../../../../core/types/result.dart';
import '../../../../core/usecase/usecase.dart';
import '../repositories/photo_repository.dart';

class SearchHeroPhoto implements UseCase<String?, String> {
  SearchHeroPhoto(this._repository);

  final PhotoRepository _repository;

  @override
  Future<Result<String?>> call(String query) async {
    try {
      final url = await _repository.searchHeroPhoto(query);
      return Success(url);
    } catch (e) {
      return Failure(NetworkFailure(e.toString()));
    }
  }
}
