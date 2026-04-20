import 'dart:async';
import 'dart:convert';
import 'package:http/http.dart' as http;
import '../config/app_config.dart';

class SyncItem {
  final String url;
  final Map<String, dynamic> body;
  final DateTime timestamp;

  SyncItem({required this.url, required this.body, required this.timestamp});

  Map<String, dynamic> toJson() => {
    'url': url,
    'body': body,
    'timestamp': timestamp.toIso8601String(),
  };
}

class SyncManager {
  static final SyncManager _instance = SyncManager._internal();
  factory SyncManager() => _instance;
  SyncManager._internal();

  final List<SyncItem> _queue = [];
  bool _isSyncing = false;
  Timer? _syncTimer;

  // Stream to notify UI of sync status
  final _statusController = StreamController<bool>.broadcast();
  Stream<bool> get isSyncingStream => _statusController.stream;

  void start() {
    _syncTimer = Timer.periodic(const Duration(seconds: 30), (timer) {
      _processQueue();
    });
  }

  void stop() {
    _syncTimer?.cancel();
  }

  void addToQueue(String endpoint, Map<String, dynamic> body) {
    _queue.add(SyncItem(
      url: '${AppConfig.apiBaseUrl}$endpoint',
      body: body,
      timestamp: DateTime.now(),
    ));
    _processQueue(); // Try immediate sync
  }

  Future<void> _processQueue() async {
    if (_isSyncing || _queue.isEmpty) return;

    _isSyncing = true;
    _statusController.add(true);
    print('SyncManager: Processing ${_queue.length} items...');

    final List<SyncItem> successfullySynced = [];

    for (var item in _queue) {
      try {
        final response = await http.post(
          Uri.parse(item.url),
          headers: {'Content-Type': 'application/json'},
          body: jsonEncode(item.body),
        ).timeout(const Duration(seconds: 5));

        if (response.statusCode == 201 || response.statusCode == 200) {
          successfullySynced.add(item);
          print('SyncManager: Successfully synced item to ${item.url}');
        }
      } catch (e) {
        print('SyncManager: Sync failed for ${item.url} - Server might be offline.');
        break; // Stop processing queue if one fails (likely network/server issue)
      }
    }

    for (var item in successfullySynced) {
      _queue.remove(item);
    }

    _isSyncing = false;
    _statusController.add(false);
  }

  int get pendingCount => _queue.length;
}
