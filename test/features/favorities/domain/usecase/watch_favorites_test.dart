import 'package:flutter_test/flutter_test.dart';
import 'package:global_explorer/features/favourites/domain/usecases/watch_favorites.dart';
import 'package:mocktail/mocktail.dart';

import '../../../../fixtures.dart';
import '../../../../mocks.dart';

void main() {
  late MockFavoritesRepository mockRepo;
  late WatchFavorites useCase;

  setUp(() {
    mockRepo = MockFavoritesRepository();
    useCase = WatchFavorites(mockRepo);
  });

  group('WatchFavorites', () {
    test('emits list of favorites from repository stream', () async {
      when(() => mockRepo.watchFavorites())
          .thenAnswer((_) => Stream.value(tFavoriteList));

      final stream = useCase();

      await expectLater(stream, emits(tFavoriteList));
    });

    test('emits empty list when no favorites exist', () async {
      when(() => mockRepo.watchFavorites())
          .thenAnswer((_) => Stream.value([]));

      final stream = useCase();

      await expectLater(stream, emits(isEmpty));
    });

    test('emits multiple updates as favorites change', () async {
      when(() => mockRepo.watchFavorites()).thenAnswer(
        (_) => Stream.fromIterable([
          [],
          tFavoriteList,
        ]),
      );

      final stream = useCase();

      await expectLater(
        stream,
        emitsInOrder([isEmpty, tFavoriteList]),
      );
    });
  });
}
