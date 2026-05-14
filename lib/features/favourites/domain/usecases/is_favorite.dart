import '../repositories/favorites_repository.dart';

class IsFavorite {
  IsFavorite(this._repository);

  final FavoritesRepository _repository;

  Future<bool> call(String cca3) => _repository.isFavorite(cca3);
}
