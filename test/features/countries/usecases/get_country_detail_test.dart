import 'package:flutter_test/flutter_test.dart';
import 'package:global_explorer/core/errors/failuers.dart';
import 'package:global_explorer/core/types/result.dart';
import 'package:global_explorer/features/countries/domain/usecases/get_country_detail.dart';
import 'package:mocktail/mocktail.dart';

import '../../../fixtures.dart';
import '../../../mocks.dart';


void main() {
  late MockCountriesRepository mockRepo;
  late GetCountryDetail useCase;

  setUp(() {
    mockRepo = MockCountriesRepository();
    useCase = GetCountryDetail(mockRepo);
  });

  group('GetCountryDetail', () {
    test('returns Success with country when repository finds it', () async {
      when(() => mockRepo.fetchByCca3('DEU'))
          .thenAnswer((_) async => tCountry);

      final result = await useCase('DEU');

      expect(result, isA<Success>());
      expect((result as Success).data, tCountry);
    });

    test('returns NotFoundFailure when repository returns null', () async {
      when(() => mockRepo.fetchByCca3('XYZ'))
          .thenAnswer((_) async => null);

      final result = await useCase('XYZ');

      expect(result, isA<Failure>());
      expect((result as Failure).failure, isA<NotFoundFailure>());
    });

    test('returns NetworkFailure when repository throws', () async {
      when(() => mockRepo.fetchByCca3(any()))
          .thenThrow(Exception('network error'));

      final result = await useCase('DEU');

      expect(result, isA<Failure>());
      expect((result as Failure).failure, isA<NetworkFailure>());
    });

    test('passes cca3 directly to repository', () async {
      when(() => mockRepo.fetchByCca3('FRA'))
          .thenAnswer((_) async => tCountry2);

      await useCase('FRA');

      verify(() => mockRepo.fetchByCca3('FRA')).called(1);
    });
  });
}
