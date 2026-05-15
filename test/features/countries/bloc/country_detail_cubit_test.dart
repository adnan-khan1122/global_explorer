import 'package:bloc_test/bloc_test.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:global_explorer/core/errors/failuers.dart';
import 'package:global_explorer/core/types/result.dart';
import 'package:global_explorer/features/countries/presentation/bloc/country_detail_cubit.dart';
import 'package:mocktail/mocktail.dart';

import '../../../fixtures.dart';
import '../../../mocks.dart';


void main() {
  late MockGetCountryDetail mockGetCountryDetail;
  late MockGetCountryNews mockGetCountryNews;
  late MockSearchHeroPhoto mockSearchHeroPhoto;
  late MockIsFavorite mockIsFavorite;
  late MockToggleFavorite mockToggleFavorite;

  setUp(() {
    registerFallbackValue(tCountry);
    mockGetCountryDetail = MockGetCountryDetail();
    mockGetCountryNews = MockGetCountryNews();
    mockSearchHeroPhoto = MockSearchHeroPhoto();
    mockIsFavorite = MockIsFavorite();
    mockToggleFavorite = MockToggleFavorite();
  });

  CountryDetailCubit buildCubit() => CountryDetailCubit(
        cca3: 'DEU',
        getCountryDetail: mockGetCountryDetail,
        getCountryNews: mockGetCountryNews,
        searchHeroPhoto: mockSearchHeroPhoto,
        isFavorite: mockIsFavorite,
        toggleFavorite: mockToggleFavorite,
      );

  group('CountryDetailCubit initial state', () {
    test('is initial status', () {
      expect(buildCubit().state.status, CountryDetailStatus.initial);
    });
  });

  group('load()', () {
    blocTest<CountryDetailCubit, CountryDetailState>(
      'emits [loading, loadingExtras, success] on full happy path',
      setUp: () {
        when(() => mockGetCountryDetail('DEU'))
            .thenAnswer((_) async => const Success(tCountry));
        when(() => mockIsFavorite('DEU'))
            .thenAnswer((_) async => false);
        when(() => mockSearchHeroPhoto(tCountry.imageSearchQuery))
            .thenAnswer((_) async => const Success(tHeroImageUrl));
        when(() => mockGetCountryNews('DE'))
            .thenAnswer((_) async => Success(tNewsArticleList));
      },
      build: buildCubit,
      act: (cubit) => cubit.load(),
      expect: () => [
        const CountryDetailState(status: CountryDetailStatus.loading),
        const CountryDetailState(
          status: CountryDetailStatus.loadingExtras,
          country: tCountry,
          isFavorite: false,
        ),
        CountryDetailState(
          status: CountryDetailStatus.success,
          country: tCountry,
          heroImageUrl: tHeroImageUrl,
          articles: tNewsArticleList,
          isFavorite: false,
        ),
      ],
    );

    blocTest<CountryDetailCubit, CountryDetailState>(
      'emits [loading, failure] when country fetch fails',
      setUp: () {
        when(() => mockGetCountryDetail('DEU')).thenAnswer(
          (_) async => const Failure(NotFoundFailure('not found')),
        );
      },
      build: buildCubit,
      act: (cubit) => cubit.load(),
      expect: () => [
        const CountryDetailState(status: CountryDetailStatus.loading),
        const CountryDetailState(
          status: CountryDetailStatus.failure,
          errorMessage: 'not found',
        ),
      ],
    );

    blocTest<CountryDetailCubit, CountryDetailState>(
      'still reaches success even when photo and news fail',
      setUp: () {
        when(() => mockGetCountryDetail('DEU'))
            .thenAnswer((_) async => const Success(tCountry));
        when(() => mockIsFavorite('DEU'))
            .thenAnswer((_) async => false);
        when(() => mockSearchHeroPhoto(any()))
            .thenAnswer((_) async => const Failure(NetworkFailure()));
        when(() => mockGetCountryNews(any()))
            .thenAnswer((_) async => const Failure(NetworkFailure()));
      },
      build: buildCubit,
      act: (cubit) => cubit.load(),
      expect: () => [
        const CountryDetailState(status: CountryDetailStatus.loading),
        const CountryDetailState(
          status: CountryDetailStatus.loadingExtras,
          country: tCountry,
          isFavorite: false,
        ),
        CountryDetailState(
          status: CountryDetailStatus.success,
          country: tCountry,
          heroImageUrl: null,
          articles: const [],
          isFavorite: false,
        ),
      ],
    );
  });

  group('toggleFavorite()', () {
    blocTest<CountryDetailCubit, CountryDetailState>(
      'flips isFavorite from false to true',
      setUp: () {
        when(() => mockToggleFavorite(any())).thenAnswer((_) async {});
        when(() => mockIsFavorite('DEU')).thenAnswer((_) async => true);
      },
      build: buildCubit,
      seed: () => const CountryDetailState(
        status: CountryDetailStatus.success,
        country: tCountry,
        isFavorite: false,
      ),
      act: (cubit) => cubit.toggleFavorite(),
      expect: () => [
        const CountryDetailState(
          status: CountryDetailStatus.success,
          country: tCountry,
          isFavorite: true,
        ),
      ],
    );

    blocTest<CountryDetailCubit, CountryDetailState>(
      'does nothing when country is null',
      build: buildCubit,
      act: (cubit) => cubit.toggleFavorite(),
      expect: () => [],
    );
  });
}
