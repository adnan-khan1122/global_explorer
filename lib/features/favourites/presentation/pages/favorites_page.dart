import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';

import '../../domain/entities/favorite_country_summary.dart';
import '../../domain/usecases/watch_favorites.dart';
import '../widgets/favorite_list_tile.dart';

class FavoritesPage extends StatelessWidget {
  const FavoritesPage({super.key});

  @override
  Widget build(BuildContext context) {
    final watchFavorites = WatchFavorites(context.read());

    return Scaffold(
      appBar: AppBar(title: const Text('Favorites')),
      body: StreamBuilder<List<FavoriteCountrySummary>>(
        stream: watchFavorites(),
        builder: (context, snapshot) {
          if (snapshot.hasError) {
            return Center(child: Text('${snapshot.error}'));
          }
          final list = snapshot.data ?? [];
          if (list.isEmpty) {
            return const Center(
              child: Padding(
                padding: EdgeInsets.all(24),
                child: Text(
                  'No favorites yet. Tap a country in Explore and use the star on the detail screen.',
                  textAlign: TextAlign.center,
                ),
              ),
            );
          }
          return ListView.separated(
            padding: const EdgeInsets.only(bottom: 24),
            itemCount: list.length,
            separatorBuilder: (context, index) => const Divider(height: 1),
            itemBuilder: (context, index) {
              final row = list[index];
              return FavoriteListTile(
                summary: row,
                onTap: () => context.push('/favorites/country/${row.cca3}'),
              );
            },
          );
        },
      ),
    );
  }
}
