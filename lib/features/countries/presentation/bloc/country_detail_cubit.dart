import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../core/types/result.dart';
import '../../../favourites/domain/usecases/is_favorite.dart';
import '../../../favourites/domain/usecases/toggle_favorite.dart';
import '../../../news/domain/entities/news_article.dart';
import '../../../news/domain/usecases/get_country_news.dart';
import '../../../photos/domain/usecases/search_hero_photo.dart';
import '../../domain/entities/country.dart';
import '../../domain/usecases/get_country_detail.dart';

class CountryDetailCubit extends Cubit<CountryDetailState> {
  CountryDetailCubit({
    required this.cca3,
    required GetCountryDetail getCountryDetail,
    required GetCountryNews getCountryNews,
    required SearchHeroPhoto searchHeroPhoto,
    required IsFavorite isFavorite,
    required ToggleFavorite toggleFavorite,
  }) : _getCountryDetail = getCountryDetail,
       _getCountryNews = getCountryNews,
       _searchHeroPhoto = searchHeroPhoto,
       _isFavorite = isFavorite,
       _toggleFavorite = toggleFavorite,
       super(const CountryDetailState());

  final String cca3;
  final GetCountryDetail _getCountryDetail;
  final GetCountryNews _getCountryNews;
  final SearchHeroPhoto _searchHeroPhoto;
  final IsFavorite _isFavorite;
  final ToggleFavorite _toggleFavorite;

  Future<void> load() async {
    emit(state.copyWith(status: CountryDetailStatus.loading, clearError: true));

    final countryResult = await _getCountryDetail(cca3);
    switch (countryResult) {
      case Failure(:final failure):
        emit(
          state.copyWith(
            status: CountryDetailStatus.failure,
            errorMessage: failure.message,
          ),
        );
        return;
      case Success(:final data):
        final country = data;
        final isFav = await _isFavorite(country.cca3);

        emit(
          state.copyWith(
            country: country,
            isFavorite: isFav,
            status: CountryDetailStatus.loadingExtras,
          ),
        );

        final photoResult = await _searchHeroPhoto(country.imageSearchQuery);
        final newsResult = await _getCountryNews(country.cca2);

        final heroUrl = switch (photoResult) {
          Success(:final data) => data,
          Failure() => null,
        };
        final articles = switch (newsResult) {
          Success(:final data) => data,
          Failure() => <NewsArticle>[],
        };

        emit(
          state.copyWith(
            status: CountryDetailStatus.success,
            heroImageUrl: heroUrl,
            articles: articles,
            isFavorite: isFav,
          ),
        );
    }
  }

  Future<void> toggleFavorite() async {
    final c = state.country;
    if (c == null) return;
    await _toggleFavorite(c);
    final now = await _isFavorite(c.cca3);
    emit(state.copyWith(isFavorite: now));
  }
}

enum CountryDetailStatus { initial, loading, loadingExtras, success, failure }

class CountryDetailState extends Equatable {
  const CountryDetailState({
    this.status = CountryDetailStatus.initial,
    this.country,
    this.heroImageUrl,
    this.articles = const [],
    this.isFavorite = false,
    this.errorMessage,
  });

  final CountryDetailStatus status;
  final Country? country;
  final String? heroImageUrl;
  final List<NewsArticle> articles;
  final bool isFavorite;
  final String? errorMessage;

  CountryDetailState copyWith({
    CountryDetailStatus? status,
    Country? country,
    String? heroImageUrl,
    List<NewsArticle>? articles,
    bool? isFavorite,
    String? errorMessage,
    bool clearError = false,
  }) {
    return CountryDetailState(
      status: status ?? this.status,
      country: country ?? this.country,
      heroImageUrl: heroImageUrl ?? this.heroImageUrl,
      articles: articles ?? this.articles,
      isFavorite: isFavorite ?? this.isFavorite,
      errorMessage: clearError ? null : (errorMessage ?? this.errorMessage),
    );
  }

  @override
  List<Object?> get props => [
    status,
    country,
    heroImageUrl,
    articles,
    isFavorite,
    errorMessage,
  ];
}
