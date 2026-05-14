import 'dart:async';

import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';

import '../../core/network/connectivity_service.dart';

// ── Cubit ──────────────────────────────────────────────────────────────────

enum NoInternetStatus { idle, checking, restored }

class NoInternetState extends Equatable {
  const NoInternetState({this.status = NoInternetStatus.idle});
  final NoInternetStatus status;
  @override
  List<Object> get props => [status];
}

class NoInternetCubit extends Cubit<NoInternetState> {
  NoInternetCubit({required ConnectivityService connectivityService})
    : _connectivity = connectivityService,
      super(const NoInternetState()) {
    // Auto-restore when the OS signals connectivity.
    _sub = _connectivity.onStatusChange.listen((isConnected) {
      if (isConnected)
        emit(const NoInternetState(status: NoInternetStatus.restored));
    });
  }

  final ConnectivityService _connectivity;
  StreamSubscription<bool>? _sub;

  Future<void> retry() async {
    emit(const NoInternetState(status: NoInternetStatus.checking));
    await _connectivity.init();
    final status = _connectivity.isConnected
        ? NoInternetStatus.restored
        : NoInternetStatus.idle;
    emit(NoInternetState(status: status));
  }

  @override
  Future<void> close() {
    _sub?.cancel();
    return super.close();
  }
}

// ── Page ───────────────────────────────────────────────────────────────────

class NoInternetPage extends StatelessWidget {
  const NoInternetPage({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) =>
          NoInternetCubit(connectivityService: ConnectivityService.instance),
      child: const _NoInternetView(),
    );
  }
}

class _NoInternetView extends StatelessWidget {
  const _NoInternetView();

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<NoInternetCubit, NoInternetState>(
      listener: (context, state) {
        if (state.status == NoInternetStatus.restored) {
          context.go('/explore');
        } else if (state.status == NoInternetStatus.idle) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text('Still offline. Please check your connection.'),
            ),
          );
        }
      },
      builder: (context, state) {
        final cs = Theme.of(context).colorScheme;
        final checking = state.status == NoInternetStatus.checking;
        return Scaffold(
          body: Center(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 32),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Icon(Icons.wifi_off_rounded, size: 80, color: cs.error),
                  const SizedBox(height: 24),
                  Text(
                    'No Internet Connection',
                    style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                      fontWeight: FontWeight.bold,
                    ),
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: 12),
                  Text(
                    'Global Explorer needs an internet connection to load '
                    'countries, news, and photos.\n\nPlease check your '
                    'Wi-Fi or mobile data and try again.',
                    style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                      color: cs.onSurface.withValues(alpha: 0.6),
                    ),
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: 32),
                  checking
                      ? const CircularProgressIndicator()
                      : FilledButton.icon(
                          onPressed: () =>
                              context.read<NoInternetCubit>().retry(),
                          icon: const Icon(Icons.refresh),
                          label: const Text('Try Again'),
                        ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }
}
