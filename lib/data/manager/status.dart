import 'dart:async';
import 'dart:convert';
import 'package:http/http.dart' as http;
import '../manager/account.dart';

class StatusManager {
  static final instance = StatusManager._();
  StatusManager._();

  final _userStatusController = StreamController<Map<String, String>>.broadcast();
  Stream<Map<String, String>> get userStatusStream => _userStatusController.stream;

  final Map<String, String> _userStatusCache = {};

  final String _baseUrl = 'https://your-api-url.com'; // Replace with your API base URL

  // Update status when user logs in
  Future<void> setUserOnline() async {
    if (!Account.instance.isLoggedIn) return;

    final uid = Account.instance.user.id;
    final response = await http.post(
      Uri.parse('$_baseUrl/users/$uid/status'),
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode({'status': 'online'}),
    );

    if (response.statusCode == 200) {
      final updatedUser = Account.instance.user.copyWith(state: 'online');
      await Account.instance.saveUser(updatedUser);
    }
  }

  // Update status when user logs out or app closes
  Future<void> setUserOffline() async {
    if (!Account.instance.isLoggedIn) return;

    final uid = Account.instance.user.id;
    await http.post(
      Uri.parse('$_baseUrl/users/$uid/status'),
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode({'status': 'offline'}),
    );
  }

  // Fetch a specific user's status
  Future<String> getUserStatus(String userId) async {
    if (_userStatusCache.containsKey(userId)) {
      return _userStatusCache[userId]!;
    }

    try {
      final response = await http.get(Uri.parse('$_baseUrl/users/$userId/status'));
      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        final status = data['status'] ?? 'offline';
        _userStatusCache[userId] = status;
        return status;
      }
    } catch (e) {
      // Handle error
    }
    return 'offline';
  }

  // Listen to a user's status changes (polling example)
  void listenToUserStatus(String userId) {
    Timer.periodic(Duration(seconds: 10), (timer) async {
      final status = await getUserStatus(userId);
      _userStatusCache[userId] = status;
      _userStatusController.add(_userStatusCache);
    });
  }
}