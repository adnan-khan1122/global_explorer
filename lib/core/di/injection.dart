import 'package:flutter/widgets.dart';
import 'package:provider/provider.dart';

import '../../features/favourites/data/datasources/favorites_local_data_source.dart';
import '../../features/favourites/data/repositries/favorites_repository_impl.dart';
import '../../features/favourites/domain/repositories/favorites_repository.dart';
import '../../features/news/data/repositries/news_repository_impl.dart';
import '../../features/photos/data/repositries/photo_repository_impl.dart';
import '../config/app_env.dart';
import '../database/app_database.dart';
import '../network/connectivity_service.dart';
import '../network/dio_client.dart';
import '../../features/countries/data/datasources/countries_rest_data_source.dart';
import '../../features/countries/data/repositories/countries_repository_impl.dart';
import '../../features/countries/domain/repositories/countries_repository.dart';
import '../../features/news/data/datasources/news_remote_data_source.dart';
import '../../features/news/domain/repositories/news_repository.dart';
import '../../features/photos/data/datasources/pexels_remote_data_source.dart';
import '../../features/photos/domain/repositories/photo_repository.dart';

/// Wires every dependency and wraps the app in [MultiProvider].
Widget buildProviderTree({required Widget child}) {
  final dio = createDio();
  final db = AppDatabase();

  final CountriesRepository countriesRepository = CountriesRepositoryImpl(
    remote: CountriesRestDataSource(dio: dio),
  );
  final NewsRepository newsRepository = NewsRepositoryImpl(
    remote: NewsRemoteDataSource(dio: dio),
  );
  final PhotoRepository photoRepository = PhotoRepositoryImpl(
    remote: PexelsRemoteDataSource(dio: dio),
  );
  final FavoritesRepository favoritesRepository = FavoritesRepositoryImpl(
    local: FavoritesLocalDataSource(db),
  );

  return MultiProvider(
    providers: [
      Provider<CountriesRepository>.value(value: countriesRepository),
      Provider<NewsRepository>.value(value: newsRepository),
      Provider<PhotoRepository>.value(value: photoRepository),
      Provider<FavoritesRepository>.value(value: favoritesRepository),
    ],
    child: child,
  );
}

Future<void> initializeApp() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Future.wait([AppEnv.load(), ConnectivityService.instance.init()]);
}
