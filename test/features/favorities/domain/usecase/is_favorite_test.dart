import 'package:flutter_test/flutter_test.dart';
import 'package:global_explorer/features/favourites/domain/usecases/is_favorite.dart';
import 'package:mocktail/mocktail.dart';

import '../../../../mocks.dart';

void main() {
  late MockFavoritesRepository mockRepo;
  late IsFavorite useCase;

  setUp(() {
    mockRepo = MockFavoritesRepository();
    useCase = IsFavorite(mockRepo);
  });

  group('IsFavorite', () {
    test('returns true when country is in favorites', () async {
      when(() => mockRepo.isFavorite('DEU')).thenAnswer((_) async => true);

      expect(await useCase('DEU'), isTrue);
    });

    test('returns false when country is not in favorites', () async {
      when(() => mockRepo.isFavorite('XYZ')).thenAnswer((_) async => false);

      expect(await useCase('XYZ'), isFalse);
    });

    test('delegates to repository with the correct cca3', () async {
      when(() => mockRepo.isFavorite('FRA')).thenAnswer((_) async => false);

      await useCase('FRA');

      verify(() => mockRepo.isFavorite('FRA')).called(1);
    });
  });
}
