import '../../../countries/domain/entities/country.dart';
import '../entities/favorite_country_summary.dart';

abstract class FavoritesRepository {
  Stream<List<FavoriteCountrySummary>> watchFavorites();
  Future<bool> isFavorite(String cca3);
  Future<void> toggle(Country country);
}
