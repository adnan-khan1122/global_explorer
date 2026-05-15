import 'package:bloc_test/bloc_test.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:global_explorer/shared/splash/splash_cubit.dart';
import 'package:mocktail/mocktail.dart';

import '../../mocks.dart';

void main() {
  late MockConnectivityService mockConnectivity;

  setUp(() {
    mockConnectivity = MockConnectivityService();
  });

  SplashCubit buildCubit() =>
      SplashCubit(connectivityService: mockConnectivity);

  group('SplashCubit initial state', () {
    test('status is loading', () {
      expect(buildCubit().state.status, SplashStatus.loading);
    });
  });

  group('checkConnectivity()', () {
    blocTest<SplashCubit, SplashState>(
      'emits connected when internet is reachable',
      setUp: () {
        when(() => mockConnectivity.init()).thenAnswer((_) async {});
        when(() => mockConnectivity.isConnected).thenReturn(true);
      },
      build: buildCubit,
      act: (cubit) => cubit.checkConnectivity(),
      expect: () => [
        const SplashState(status: SplashStatus.connected),
      ],
    );

    blocTest<SplashCubit, SplashState>(
      'emits noInternet when internet is not reachable',
      setUp: () {
        when(() => mockConnectivity.init()).thenAnswer((_) async {});
        when(() => mockConnectivity.isConnected).thenReturn(false);
      },
      build: buildCubit,
      act: (cubit) => cubit.checkConnectivity(),
      expect: () => [
        const SplashState(status: SplashStatus.noInternet),
      ],
    );

    blocTest<SplashCubit, SplashState>(
      'calls init() before reading isConnected',
      setUp: () {
        when(() => mockConnectivity.init()).thenAnswer((_) async {});
        when(() => mockConnectivity.isConnected).thenReturn(true);
      },
      build: buildCubit,
      act: (cubit) => cubit.checkConnectivity(),
      verify: (_) {
        verifyInOrder([
          () => mockConnectivity.init(),
          () => mockConnectivity.isConnected,
        ]);
      },
    );
  });
}
