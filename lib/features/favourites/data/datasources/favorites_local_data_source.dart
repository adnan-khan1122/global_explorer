import 'package:drift/drift.dart';

import '../../../../core/database/app_database.dart';

class FavoritesLocalDataSource {
  FavoritesLocalDataSource(this._db);

  final AppDatabase _db;

  Stream<List<FavoriteCountry>> watchAllRows() {
    return (_db.select(_db.favoriteCountries)..orderBy([
          (t) => OrderingTerm(expression: t.addedAt, mode: OrderingMode.desc),
        ]))
        .watch();
  }

  Future<bool> exists(String cca3) async {
    final q = await (_db.select(
      _db.favoriteCountries,
    )..where((t) => t.cca3.equals(cca3))).getSingleOrNull();
    return q != null;
  }

  Future<void> insertFavorite({
    required String cca3,
    required String nameCommon,
    String? flagPng,
    String? region,
  }) async {
    await _db
        .into(_db.favoriteCountries)
        .insert(
          FavoriteCountriesCompanion.insert(
            cca3: cca3,
            nameCommon: nameCommon,
            flagPng: Value(flagPng),
            region: Value(region),
          ),
          mode: InsertMode.insertOrReplace,
        );
  }

  Future<void> delete(String cca3) async {
    await (_db.delete(
      _db.favoriteCountries,
    )..where((t) => t.cca3.equals(cca3))).go();
  }
}
