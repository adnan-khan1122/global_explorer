import 'package:flutter_test/flutter_test.dart';
import 'package:global_explorer/core/types/result.dart';
import 'package:global_explorer/features/photos/domain/usecases/search_hero_photo.dart';
import 'package:mocktail/mocktail.dart';

import '../../../../fixtures.dart';
import '../../../../mocks.dart';

void main() {
  late MockPhotoRepository mockRepo;
  late SearchHeroPhoto useCase;

  setUp(() {
    mockRepo = MockPhotoRepository();
    useCase = SearchHeroPhoto(mockRepo);
  });

  group('SearchHeroPhoto', () {
    test('returns Success with URL when repository finds a photo', () async {
      when(() => mockRepo.searchHeroPhoto('Germany Berlin'))
          .thenAnswer((_) async => tHeroImageUrl);

      final result = await useCase('Germany Berlin');

      expect(result, isA<Success<String?>>());
      expect((result as Success).data, tHeroImageUrl);
    });

    test('returns Success with null when no photo found', () async {
      when(() => mockRepo.searchHeroPhoto(any()))
          .thenAnswer((_) async => null);

      final result = await useCase('Unknown Place');

      expect(result, isA<Success<String?>>());
      expect((result as Success).data, isNull);
    });

    test('returns Failure when repository throws', () async {
      when(() => mockRepo.searchHeroPhoto(any()))
          .thenThrow(Exception('Pexels API error'));

      final result = await useCase('Germany Berlin');

      expect(result, isA<Failure>());
    });
  });
}
