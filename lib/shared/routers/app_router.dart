import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';

import '../../features/countries/domain/repositories/countries_repository.dart';
import '../../features/countries/domain/usecases/get_all_countries.dart';
import '../../features/countries/domain/usecases/get_country_detail.dart';
import '../../features/countries/presentation/bloc/countries_bloc.dart';
import '../../features/countries/presentation/bloc/country_detail_cubit.dart';
import '../../features/countries/presentation/pages/country_detail_page.dart';
import '../../features/countries/presentation/pages/explore_page.dart';
import '../../features/favourites/domain/repositories/favorites_repository.dart';
import '../../features/favourites/domain/usecases/is_favorite.dart';
import '../../features/favourites/domain/usecases/toggle_favorite.dart';
import '../../features/favourites/presentation/pages/favorites_page.dart';
import '../../features/news/domain/repositories/news_repository.dart';
import '../../features/news/domain/usecases/get_country_news.dart';
import '../../features/photos/domain/repositories/photo_repository.dart';
import '../../features/photos/domain/usecases/search_hero_photo.dart';
import '../../core/network/connectivity_service.dart';
import '../splash/splash_cubit.dart';
import '../splash/splash_page.dart';
import '../widgets/no_internet_page.dart';
import 'main_shell.dart';

GoRouter createAppRouter() {
  return GoRouter(
    initialLocation: '/splash',
    routes: [
      GoRoute(
        path: '/splash',
        builder: (context, state) => BlocProvider(
          create: (_) =>
              SplashCubit(connectivityService: ConnectivityService.instance),
          child: const SplashPage(),
        ),
      ),
      GoRoute(
        path: '/no-internet',
        builder: (context, state) => const NoInternetPage(),
      ),
      StatefulShellRoute.indexedStack(
        branches: [
          StatefulShellBranch(
            routes: [
              GoRoute(
                path: '/explore',
                builder: (context, state) => BlocProvider(
                  create: (_) => CountriesBloc(
                    getAllCountries: GetAllCountries(
                      context.read<CountriesRepository>(),
                    ),
                  )..add(const CountriesRequested()),
                  child: const ExplorePage(),
                ),
                routes: [
                  GoRoute(
                    path: 'country/:cca3',
                    builder: (context, state) => _detailPage(context, state),
                  ),
                ],
              ),
            ],
          ),
          StatefulShellBranch(
            routes: [
              GoRoute(
                path: '/favorites',
                builder: (context, state) => const FavoritesPage(),
                routes: [
                  GoRoute(
                    path: 'country/:cca3',
                    builder: (context, state) => _detailPage(context, state),
                  ),
                ],
              ),
            ],
          ),
        ],
        builder: (context, state, navigationShell) =>
            MainShell(navigationShell: navigationShell),
      ),
    ],
    errorBuilder: (context, state) => Scaffold(
      appBar: AppBar(title: const Text('Not found')),
      body: Center(
        child: Text(
          state.error is Exception
              ? '${state.error}'
              : 'This page could not be found.',
        ),
      ),
    ),
  );
}

Widget _detailPage(BuildContext context, GoRouterState state) {
  final cca3 = state.pathParameters['cca3']!;
  return BlocProvider(
    create: (_) => CountryDetailCubit(
      cca3: cca3,
      getCountryDetail: GetCountryDetail(context.read<CountriesRepository>()),
      getCountryNews: GetCountryNews(context.read<NewsRepository>()),
      searchHeroPhoto: SearchHeroPhoto(context.read<PhotoRepository>()),
      isFavorite: IsFavorite(context.read<FavoritesRepository>()),
      toggleFavorite: ToggleFavorite(context.read<FavoritesRepository>()),
    )..load(),
    child: CountryDetailPage(cca3: cca3),
  );
}
