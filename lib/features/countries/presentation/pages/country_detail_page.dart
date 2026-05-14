import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';
import 'package:url_launcher/url_launcher.dart';

import '../../../news/presentation/widgets/news_article_card.dart';
import '../bloc/country_detail_cubit.dart';
import '../widgets/info_chip.dart';

class CountryDetailPage extends StatefulWidget {
  const CountryDetailPage({super.key, required this.cca3});
  final String cca3;

  @override
  State<CountryDetailPage> createState() => _CountryDetailPageState();
}

class _CountryDetailPageState extends State<CountryDetailPage> {
  final _scrollController = ScrollController();

  // How many pixels to scroll before the AppBar is considered "collapsed".
  static const _collapseThreshold = 160.0;

  bool _isCollapsed = false;

  @override
  void initState() {
    super.initState();
    _scrollController.addListener(_onScroll);
  }

  void _onScroll() {
    final collapsed = _scrollController.offset > _collapseThreshold;
    if (collapsed != _isCollapsed) {
      setState(() => _isCollapsed = collapsed);
    }
  }

  @override
  void dispose() {
    _scrollController.removeListener(_onScroll);
    _scrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final nf = NumberFormat.compact();
    final cs = Theme.of(context).colorScheme;

    return BlocBuilder<CountryDetailCubit, CountryDetailState>(
      builder: (context, state) {
        if (state.status == CountryDetailStatus.failure) {
          return Scaffold(
            appBar: AppBar(title: const Text('Country')),
            body: Center(
              child: Padding(
                padding: const EdgeInsets.all(24),
                child: Text(state.errorMessage ?? 'Something went wrong.'),
              ),
            ),
          );
        }

        if (state.country == null ||
            state.status == CountryDetailStatus.loading) {
          return Scaffold(
            appBar: AppBar(title: const Text('Country')),
            body: const Center(child: CircularProgressIndicator()),
          );
        }

        final c = state.country!;
        final loadingExtras = state.status == CountryDetailStatus.loadingExtras;

        // Expanded  → white icons over photo
        // Collapsed → theme icons over surface
        final iconColor = _isCollapsed ? cs.onSurface : Colors.white;
        final titleColor = _isCollapsed ? cs.onSurface : Colors.white;
        final appBarBg = _isCollapsed ? cs.surface : Colors.transparent;

        return AnnotatedRegion<SystemUiOverlayStyle>(
          value: _isCollapsed
              ? SystemUiOverlayStyle.dark
              : SystemUiOverlayStyle.light,
          child: Scaffold(
            body: CustomScrollView(
              controller: _scrollController,
              slivers: [
                SliverAppBar(
                  pinned: true,
                  expandedHeight: 260,
                  backgroundColor: appBarBg,
                  foregroundColor: iconColor,
                  // Remove the M3 surface tint while expanded
                  surfaceTintColor: Colors.transparent,
                  elevation: _isCollapsed ? 2 : 0,
                  iconTheme: IconThemeData(color: iconColor),
                  actionsIconTheme: IconThemeData(color: iconColor),
                  title: AnimatedDefaultTextStyle(
                    duration: const Duration(milliseconds: 200),
                    style: Theme.of(context).textTheme.titleLarge!.copyWith(
                      color: titleColor,
                      fontWeight: FontWeight.bold,
                    ),
                    child: Text(c.nameCommon),
                  ),
                  actions: [
                    IconButton(
                      tooltip: state.isFavorite
                          ? 'Remove favorite'
                          : 'Add favorite',
                      icon: AnimatedSwitcher(
                        duration: const Duration(milliseconds: 250),
                        child: Icon(
                          state.isFavorite ? Icons.star : Icons.star_border,
                          key: ValueKey(state.isFavorite),
                          color: state.isFavorite ? Colors.amber : iconColor,
                          shadows: _isCollapsed
                              ? null
                              : const [
                                  Shadow(blurRadius: 4, color: Colors.black54),
                                ],
                        ),
                      ),
                      onPressed: () =>
                          context.read<CountryDetailCubit>().toggleFavorite(),
                    ),
                  ],
                  flexibleSpace: FlexibleSpaceBar(
                    // Disable built-in title so we use our own animated one
                    titlePadding: EdgeInsets.zero,
                    background: _HeroBackground(
                      heroImageUrl: state.heroImageUrl,
                      flagPng: c.flagPng,
                      countryName: c.nameCommon,
                    ),
                  ),
                ),
                SliverPadding(
                  padding: const EdgeInsets.all(16),
                  sliver: SliverList(
                    delegate: SliverChildListDelegate([
                      Text(
                        c.nameOfficial,
                        style: Theme.of(context).textTheme.titleMedium,
                      ),
                      const SizedBox(height: 12),
                      Wrap(
                        spacing: 8,
                        runSpacing: 8,
                        children: [
                          InfoChip(label: 'Region', value: c.region),
                          if (c.subregion != null)
                            InfoChip(label: 'Subregion', value: c.subregion!),
                          InfoChip(
                            label: 'Population',
                            value: c.population != null
                                ? nf.format(c.population)
                                : '—',
                          ),
                          InfoChip(
                            label: 'Area',
                            value: c.area != null
                                ? '${nf.format(c.area)} km²'
                                : '—',
                          ),
                          InfoChip(label: 'Capital', value: c.displayCapital),
                        ],
                      ),
                      if (c.mapsOpenStreetMaps != null) ...[
                        const SizedBox(height: 12),
                        FilledButton.tonalIcon(
                          onPressed: () async {
                            final u = Uri.parse(c.mapsOpenStreetMaps!);
                            if (await canLaunchUrl(u)) {
                              await launchUrl(
                                u,
                                mode: LaunchMode.externalApplication,
                              );
                            }
                          },
                          icon: const Icon(Icons.map_outlined),
                          label: const Text('Open in OpenStreetMap'),
                        ),
                      ],
                      const SizedBox(height: 24),
                      Row(
                        children: [
                          Text(
                            'Regional news',
                            style: Theme.of(context).textTheme.titleLarge,
                          ),
                          if (loadingExtras) ...[
                            const SizedBox(width: 12),
                            const SizedBox(
                              width: 18,
                              height: 18,
                              child: CircularProgressIndicator(strokeWidth: 2),
                            ),
                          ],
                        ],
                      ),
                      const SizedBox(height: 8),
                      if (state.articles.isEmpty && !loadingExtras)
                        Text(
                          'No headlines available.',
                          style: Theme.of(context).textTheme.bodyMedium,
                        ),
                      ...state.articles.map((a) => NewsArticleCard(article: a)),
                    ]),
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}

/// The photo / flag background with dual-side scrim so icons are always legible.
class _HeroBackground extends StatelessWidget {
  const _HeroBackground({
    required this.heroImageUrl,
    required this.flagPng,
    required this.countryName,
  });

  final String? heroImageUrl;
  final String? flagPng;
  final String countryName;

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;

    return Stack(
      fit: StackFit.expand,
      children: [
        // ── Photo or flag fallback ──────────────────────────────────
        if (heroImageUrl != null && heroImageUrl!.isNotEmpty)
          CachedNetworkImage(
            imageUrl: heroImageUrl!,
            fit: BoxFit.cover,
            placeholder: (context, url) =>
                ColoredBox(color: cs.surfaceContainerHighest),
            errorWidget: (context, url, error) =>
                _FlagFallback(flagPng: flagPng, cs: cs),
          )
        else
          _FlagFallback(flagPng: flagPng, cs: cs),

        // ── Dual scrim: dark top + darker bottom ────────────────────
        // Top band ensures back-button and star are always readable.
        // Bottom band adds depth and separates content below.
        DecoratedBox(
          decoration: BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
              stops: const [0.0, 0.35, 0.65, 1.0],
              colors: [
                Colors.black.withValues(alpha: 0.55), // top – protects icons
                Colors.transparent,
                Colors.transparent,
                Colors.black.withValues(alpha: 0.60), // bottom – depth
              ],
            ),
          ),
        ),
      ],
    );
  }
}

class _FlagFallback extends StatelessWidget {
  const _FlagFallback({required this.flagPng, required this.cs});

  final String? flagPng;
  final ColorScheme cs;

  @override
  Widget build(BuildContext context) {
    return ColoredBox(
      color: cs.surfaceContainerHighest,
      child: Center(
        child: flagPng != null && flagPng!.isNotEmpty
            ? CachedNetworkImage(
                imageUrl: flagPng!,
                height: 100,
                fit: BoxFit.contain,
              )
            : Icon(Icons.public, size: 80, color: cs.onSurfaceVariant),
      ),
    );
  }
}
