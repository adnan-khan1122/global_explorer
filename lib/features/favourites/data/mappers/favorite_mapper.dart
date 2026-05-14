import '../../../../core/database/app_database.dart';
import '../../domain/entities/favorite_country_summary.dart';

class FavoriteMapper {
  const FavoriteMapper._();

  static FavoriteCountrySummary toSummary(FavoriteCountry row) =>
      FavoriteCountrySummary(
        cca3: row.cca3,
        nameCommon: row.nameCommon,
        flagPng: row.flagPng,
        region: row.region,
      );
}
