import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';

import '../bloc/countries_bloc.dart';
import '../widgets/country_list_shimmer.dart';

class ExplorePage extends StatefulWidget {
  const ExplorePage({super.key});

  @override
  State<ExplorePage> createState() => _ExplorePageState();
}

class _ExplorePageState extends State<ExplorePage> {
  final _searchController = TextEditingController();

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Explore')),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.fromLTRB(16, 8, 16, 8),
            child: SearchBar(
              controller: _searchController,
              hintText: 'Search by name, region, or capital',
              leading: const Icon(Icons.search),
              trailing: [
                if (_searchController.text.isNotEmpty)
                  IconButton(
                    icon: const Icon(Icons.clear),
                    onPressed: () {
                      _searchController.clear();
                      context.read<CountriesBloc>().add(
                        const CountriesSearchChanged(''),
                      );
                    },
                  ),
              ],
              onChanged: (value) {
                setState(() {});
                context.read<CountriesBloc>().add(
                  CountriesSearchChanged(value),
                );
              },
            ),
          ),
          Expanded(
            child: BlocBuilder<CountriesBloc, CountriesState>(
              builder: (context, state) {
                switch (state.status) {
                  case CountriesStatus.initial:
                  case CountriesStatus.loading:
                    return const CountryListShimmer();
                  case CountriesStatus.failure:
                    return Center(
                      child: Padding(
                        padding: const EdgeInsets.all(24),
                        child: Column(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            const Icon(
                              Icons.wifi_off_outlined,
                              size: 48,
                              color: Colors.grey,
                            ),
                            const SizedBox(height: 12),
                            Text(
                              'Could not load countries.\nCheck your connection and try again.',
                              textAlign: TextAlign.center,
                            ),
                            const SizedBox(height: 16),
                            FilledButton.icon(
                              onPressed: () => context
                                  .read<CountriesBloc>()
                                  .add(const CountriesRequested()),
                              icon: const Icon(Icons.refresh),
                              label: const Text('Retry'),
                            ),
                          ],
                        ),
                      ),
                    );
                  case CountriesStatus.success:
                    final list = state.filtered;
                    if (list.isEmpty) {
                      return const Center(
                        child: Text('No matching countries.'),
                      );
                    }
                    return ListView.separated(
                      padding: const EdgeInsets.only(bottom: 24),
                      itemCount: list.length,
                      separatorBuilder: (context, index) =>
                          const Divider(height: 1),
                      itemBuilder: (context, index) {
                        final c = list[index];
                        return ListTile(
                          leading: ClipRRect(
                            borderRadius: BorderRadius.circular(4),
                            child: c.flagPng != null && c.flagPng!.isNotEmpty
                                ? CachedNetworkImage(
                                    imageUrl: c.flagPng!,
                                    width: 40,
                                    height: 28,
                                    fit: BoxFit.cover,
                                    placeholder: (context, url) =>
                                        const SizedBox(
                                          width: 40,
                                          height: 28,
                                          child: DecoratedBox(
                                            decoration: BoxDecoration(
                                              color: Color(0xFFE0E0E0),
                                            ),
                                          ),
                                        ),
                                    errorWidget: (context, url, error) =>
                                        const Icon(Icons.flag_outlined),
                                  )
                                : const Icon(Icons.flag_outlined),
                          ),
                          title: Text(c.nameCommon),
                          subtitle: Text(
                            '${c.region}${c.capital.isNotEmpty ? ' · ${c.capital.join(', ')}' : ''}',
                            maxLines: 2,
                            overflow: TextOverflow.ellipsis,
                          ),
                          onTap: () =>
                              context.push('/explore/country/${c.cca3}'),
                        );
                      },
                    );
                }
              },
            ),
          ),
        ],
      ),
    );
  }
}
