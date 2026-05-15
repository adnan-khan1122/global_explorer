import 'package:global_explorer/core/network/connectivity_service.dart';
import 'package:global_explorer/core/usecase/usecase.dart';
import 'package:global_explorer/features/countries/domain/repositories/countries_repository.dart';
import 'package:global_explorer/features/countries/domain/usecases/get_all_countries.dart';
import 'package:global_explorer/features/countries/domain/usecases/get_country_detail.dart';
import 'package:global_explorer/features/favourites/domain/repositories/favorites_repository.dart';
import 'package:global_explorer/features/favourites/domain/usecases/is_favorite.dart';
import 'package:global_explorer/features/favourites/domain/usecases/toggle_favorite.dart';
import 'package:global_explorer/features/favourites/domain/usecases/watch_favorites.dart';
import 'package:global_explorer/features/news/domain/repositories/news_repository.dart';
import 'package:global_explorer/features/news/domain/usecases/get_country_news.dart';
import 'package:global_explorer/features/photos/domain/repositories/photo_repository.dart';
import 'package:global_explorer/features/photos/domain/usecases/search_hero_photo.dart';
import 'package:mocktail/mocktail.dart';

// ── Repository mocks ────────────────────────────────────────────────────────

class MockCountriesRepository extends Mock implements CountriesRepository {}

class MockNewsRepository extends Mock implements NewsRepository {}

class MockPhotoRepository extends Mock implements PhotoRepository {}

class MockFavoritesRepository extends Mock implements FavoritesRepository {}

// ── Use-case mocks ──────────────────────────────────────────────────────────

class MockGetAllCountries extends Mock implements GetAllCountries {}

class MockGetCountryDetail extends Mock implements GetCountryDetail {}

class MockGetCountryNews extends Mock implements GetCountryNews {}

class MockSearchHeroPhoto extends Mock implements SearchHeroPhoto {}

class MockIsFavorite extends Mock implements IsFavorite {}

class MockToggleFavorite extends Mock implements ToggleFavorite {}

class MockWatchFavorites extends Mock implements WatchFavorites {}

// ── Service mocks ───────────────────────────────────────────────────────────

class MockConnectivityService extends Mock implements ConnectivityService {}

// ── Fallback registrations (required by mocktail for custom types) ──────────

void registerFallbacks() {
  registerFallbackValue(const NoParams());
}
