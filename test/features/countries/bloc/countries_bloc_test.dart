import 'package:bloc_test/bloc_test.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:global_explorer/core/errors/failuers.dart';
import 'package:global_explorer/core/types/result.dart';
import 'package:global_explorer/core/usecase/usecase.dart';
import 'package:global_explorer/features/countries/presentation/bloc/countries_bloc.dart';
import 'package:mocktail/mocktail.dart';

import '../../../fixtures.dart';
import '../../../mocks.dart';

void main() {
  late MockGetAllCountries mockGetAllCountries;

  setUp(() {
    registerFallbacks();
    mockGetAllCountries = MockGetAllCountries();
  });

  CountriesBloc buildBloc() =>
      CountriesBloc(getAllCountries: mockGetAllCountries);

  group('CountriesBloc initial state', () {
    test('is CountriesState with status initial', () {
      expect(buildBloc().state, const CountriesState());
      expect(buildBloc().state.status, CountriesStatus.initial);
    });
  });

  group('CountriesRequested', () {
    blocTest<CountriesBloc, CountriesState>(
      'emits [loading, success] when use case returns Success',
      setUp: () {
        when(() => mockGetAllCountries(const NoParams()))
            .thenAnswer((_) async => Success(tCountryList));
      },
      build: buildBloc,
      act: (bloc) => bloc.add(const CountriesRequested()),
      expect: () => [
        const CountriesState(status: CountriesStatus.loading),
        CountriesState(
          status: CountriesStatus.success,
          allCountries: tCountryList,
        ),
      ],
    );

    blocTest<CountriesBloc, CountriesState>(
      'emits [loading, failure] when use case returns Failure',
      setUp: () {
        when(() => mockGetAllCountries(const NoParams())).thenAnswer(
          (_) async => const Failure(NetworkFailure('timeout')),
        );
      },
      build: buildBloc,
      act: (bloc) => bloc.add(const CountriesRequested()),
      expect: () => [
        const CountriesState(status: CountriesStatus.loading),
        const CountriesState(
          status: CountriesStatus.failure,
          errorMessage: 'timeout',
        ),
      ],
    );
  });

  group('CountriesSearchChanged', () {
    blocTest<CountriesBloc, CountriesState>(
      'updates searchQuery after debounce',
      setUp: () {
        when(() => mockGetAllCountries(const NoParams()))
            .thenAnswer((_) async => Success(tCountryList));
      },
      build: buildBloc,
      seed: () => CountriesState(
        status: CountriesStatus.success,
        allCountries: tCountryList,
      ),
      act: (bloc) =>
          bloc.add(const CountriesSearchChanged('Ger')),
      wait: const Duration(milliseconds: 400),
      expect: () => [
        CountriesState(
          status: CountriesStatus.success,
          allCountries: tCountryList,
          searchQuery: 'Ger',
        ),
      ],
    );

    blocTest<CountriesBloc, CountriesState>(
      'filtered getter returns matching countries',
      build: buildBloc,
      seed: () => CountriesState(
        status: CountriesStatus.success,
        allCountries: tCountryList,
        searchQuery: 'France',
      ),
      act: (_) {},
      verify: (bloc) {
        final filtered = bloc.state.filtered;
        expect(filtered.length, 1);
        expect(filtered.first.nameCommon, 'France');
      },
    );

    blocTest<CountriesBloc, CountriesState>(
      'filtered getter returns all countries when search is empty',
      build: buildBloc,
      seed: () => CountriesState(
        status: CountriesStatus.success,
        allCountries: tCountryList,
        searchQuery: '',
      ),
      act: (_) {},
      verify: (bloc) {
        expect(bloc.state.filtered.length, tCountryList.length);
      },
    );

    blocTest<CountriesBloc, CountriesState>(
      'filtered getter returns empty when no country matches',
      build: buildBloc,
      seed: () => CountriesState(
        status: CountriesStatus.success,
        allCountries: tCountryList,
        searchQuery: 'zzzzz',
      ),
      act: (_) {},
      verify: (bloc) {
        expect(bloc.state.filtered, isEmpty);
      },
    );
  });
}
