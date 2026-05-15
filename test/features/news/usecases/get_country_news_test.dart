import 'package:flutter_test/flutter_test.dart';
import 'package:global_explorer/core/types/result.dart';
import 'package:global_explorer/features/news/domain/usecases/get_country_news.dart';
import 'package:mocktail/mocktail.dart';

import '../../../fixtures.dart';
import '../../../mocks.dart';

void main() {
  late MockNewsRepository mockRepo;
  late GetCountryNews useCase;

  setUp(() {
    mockRepo = MockNewsRepository();
    useCase = GetCountryNews(mockRepo);
  });

  group('GetCountryNews', () {
    test('returns Success with article list when repository succeeds',
        () async {
      when(() => mockRepo.topHeadlinesByCountry(cca2: 'DE'))
          .thenAnswer((_) async => tNewsArticleList);

      final result = await useCase('DE');

      expect(result, isA<Success<List>>());
      expect((result as Success).data, tNewsArticleList);
    });

    test('returns Failure when repository throws', () async {
      when(() => mockRepo.topHeadlinesByCountry(cca2: any(named: 'cca2')))
          .thenThrow(Exception('api error'));

      final result = await useCase('DE');

      expect(result, isA<Failure>());
    });

    test('returns Success with empty list when no articles available',
        () async {
      when(() => mockRepo.topHeadlinesByCountry(cca2: 'ZZ'))
          .thenAnswer((_) async => []);

      final result = await useCase('ZZ');

      expect(result, isA<Success<List>>());
      expect((result as Success).data, isEmpty);
    });

    test('passes cca2 code to repository', () async {
      when(() => mockRepo.topHeadlinesByCountry(cca2: 'FR'))
          .thenAnswer((_) async => []);

      await useCase('FR');

      verify(() => mockRepo.topHeadlinesByCountry(cca2: 'FR')).called(1);
    });
  });
}
