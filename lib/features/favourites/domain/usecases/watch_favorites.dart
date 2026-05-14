import '../entities/favorite_country_summary.dart';
import '../repositories/favorites_repository.dart';

class WatchFavorites {
  WatchFavorites(this._repository);

  final FavoritesRepository _repository;

  Stream<List<FavoriteCountrySummary>> call() => _repository.watchFavorites();
}
