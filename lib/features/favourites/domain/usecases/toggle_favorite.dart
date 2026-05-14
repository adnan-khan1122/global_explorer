import '../../../countries/domain/entities/country.dart';
import '../repositories/favorites_repository.dart';

class ToggleFavorite {
  ToggleFavorite(this._repository);

  final FavoritesRepository _repository;

  Future<void> call(Country country) => _repository.toggle(country);
}
