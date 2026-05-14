import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../core/network/connectivity_service.dart';

// ── State ──────────────────────────────────────────────────────────────────

enum SplashStatus { loading, connected, noInternet }

class SplashState extends Equatable {
  const SplashState({this.status = SplashStatus.loading});

  final SplashStatus status;

  SplashState copyWith(SplashStatus status) => SplashState(status: status);

  @override
  List<Object> get props => [status];
}

// ── Cubit ──────────────────────────────────────────────────────────────────

class SplashCubit extends Cubit<SplashState> {
  SplashCubit({required ConnectivityService connectivityService})
    : _connectivity = connectivityService,
      super(const SplashState());

  final ConnectivityService _connectivity;

  /// Call once after the minimum splash duration has elapsed.
  Future<void> checkConnectivity() async {
    await _connectivity.init();
    final status = _connectivity.isConnected
        ? SplashStatus.connected
        : SplashStatus.noInternet;
    emit(state.copyWith(status));
  }
}
