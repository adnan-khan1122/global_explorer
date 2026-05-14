import '../../../countries/domain/entities/country.dart';
import '../../domain/entities/favorite_country_summary.dart';
import '../../domain/repositories/favorites_repository.dart';
import '../datasources/favorites_local_data_source.dart';
import '../mappers/favorite_mapper.dart';

class FavoritesRepositoryImpl implements FavoritesRepository {
  FavoritesRepositoryImpl({required FavoritesLocalDataSource local})
    : _local = local;

  final FavoritesLocalDataSource _local;

  @override
  Stream<List<FavoriteCountrySummary>> watchFavorites() {
    return _local.watchAllRows().map(
      (rows) => rows.map(FavoriteMapper.toSummary).toList(growable: false),
    );
  }

  @override
  Future<bool> isFavorite(String cca3) => _local.exists(cca3);

  @override
  Future<void> toggle(Country country) async {
    if (await _local.exists(country.cca3)) {
      await _local.delete(country.cca3);
    } else {
      await _local.insertFavorite(
        cca3: country.cca3,
        nameCommon: country.nameCommon,
        flagPng: country.flagPng,
        region: country.region.isEmpty ? null : country.region,
      );
    }
  }
}
