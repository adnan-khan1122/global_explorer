import 'dart:async';
import 'dart:io';

import 'package:connectivity_plus/connectivity_plus.dart';

class ConnectivityService {
  ConnectivityService._();

  static final instance = ConnectivityService._();

  final _connectivity = Connectivity();
  final _controller = StreamController<bool>.broadcast();

  StreamSubscription<List<ConnectivityResult>>? _sub;
  bool _isConnected = true;

  bool get isConnected => _isConnected;

  Future<void> init() async {
    _isConnected = await _hasInternet();
    _sub = _connectivity.onConnectivityChanged.listen((results) async {
      final reachable = await _hasInternet();
      if (reachable != _isConnected) {
        _isConnected = reachable;
        _controller.add(_isConnected);
      }
    });
  }

  Stream<bool> get onStatusChange => _controller.stream;

  /// Sends a quick DNS lookup to verify real internet access.
  Future<bool> _hasInternet() async {
    try {
      final result = await InternetAddress.lookup(
        'restcountries.com',
      ).timeout(const Duration(seconds: 5));
      return result.isNotEmpty && result.first.rawAddress.isNotEmpty;
    } catch (_) {
      return false;
    }
  }

  void dispose() {
    _sub?.cancel();
    _controller.close();
  }
}
