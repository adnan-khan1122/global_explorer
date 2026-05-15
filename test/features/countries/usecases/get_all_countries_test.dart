import 'package:flutter_test/flutter_test.dart';
import 'package:global_explorer/core/types/result.dart';
import 'package:global_explorer/core/usecase/usecase.dart';
import 'package:global_explorer/features/countries/domain/usecases/get_all_countries.dart';
import 'package:mocktail/mocktail.dart';

import '../../../fixtures.dart';
import '../../../mocks.dart';

void main() {
  late MockCountriesRepository mockRepo;
  late GetAllCountries useCase;

  setUp(() {
    registerFallbacks();
    mockRepo = MockCountriesRepository();
    useCase = GetAllCountries(mockRepo);
  });

  group('GetAllCountries', () {
    test('returns Success with sorted list when repository succeeds', () async {
      // tCountry2 (France) sorts before tCountry (Germany) alphabetically
      when(() => mockRepo.fetchAll())
          .thenAnswer((_) async => [tCountry, tCountry2]);

      final result = await useCase(const NoParams());

      expect(result, isA<Success<List>>());
      final data = (result as Success).data;
      expect(data.first.nameCommon, 'France');
      expect(data.last.nameCommon, 'Germany');
    });

    test('returns Failure when repository throws', () async {
      when(() => mockRepo.fetchAll())
          .thenThrow(Exception('connection refused'));

      final result = await useCase(const NoParams());

      expect(result, isA<Failure>());
    });

    test('calls repository fetchAll exactly once', () async {
      when(() => mockRepo.fetchAll()).thenAnswer((_) async => tCountryList);

      await useCase(const NoParams());

      verify(() => mockRepo.fetchAll()).called(1);
    });

    test('returns Success with empty list when repository returns empty', () async {
      when(() => mockRepo.fetchAll()).thenAnswer((_) async => []);

      final result = await useCase(const NoParams());

      expect(result, isA<Success<List>>());
      expect((result as Success).data, isEmpty);
    });
  });
}
