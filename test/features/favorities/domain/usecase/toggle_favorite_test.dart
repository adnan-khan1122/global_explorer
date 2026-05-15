import 'package:flutter_test/flutter_test.dart';
import 'package:global_explorer/features/favourites/domain/usecases/toggle_favorite.dart';
import 'package:mocktail/mocktail.dart';

import '../../../../fixtures.dart';
import '../../../../mocks.dart';

void main() {
  late MockFavoritesRepository mockRepo;
  late ToggleFavorite useCase;

  setUp(() {
    mockRepo = MockFavoritesRepository();
    useCase = ToggleFavorite(mockRepo);
    registerFallbackValue(tCountry);
  });

  group('ToggleFavorite', () {
    test('calls repository toggle with the given country', () async {
      when(() => mockRepo.toggle(any())).thenAnswer((_) async {});

      await useCase(tCountry);

      verify(() => mockRepo.toggle(tCountry)).called(1);
    });

    test('completes without error on successful toggle', () async {
      when(() => mockRepo.toggle(any())).thenAnswer((_) async {});

      expect(() async => useCase(tCountry), returnsNormally);
    });
  });
}
