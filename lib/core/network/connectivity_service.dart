import 'package:connectivity_plus/connectivity_plus.dart';

/// Reports online/offline transitions for offline-first sync triggers
/// (Architecture §6). "Online" means at least one active transport — it does
/// not guarantee reachability, which the sync engine handles via retries.
class ConnectivityService {
  ConnectivityService([Connectivity? connectivity])
      : _connectivity = connectivity ?? Connectivity();

  final Connectivity _connectivity;

  Stream<bool> get onlineChanges {
    return _connectivity.onConnectivityChanged.map(_isOnline);
  }

  Future<bool> get isOnline async {
    return _isOnline(await _connectivity.checkConnectivity());
  }

  bool _isOnline(List<ConnectivityResult> results) {
    return results.any((r) => r != ConnectivityResult.none);
  }
}
