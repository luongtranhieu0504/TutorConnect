// lib/data/manager/status_manager.dart
import 'dart:async';
import 'dart:ui';
import 'package:flutter/services.dart';
import 'package:tutorconnect/data/manager/account.dart';
import 'package:tutorconnect/data/network/api/auth_api.dart';
import 'package:tutorconnect/di/di.dart';

class StatusManager {
  static final instance = StatusManager._();
  StatusManager._();

  final _userApi = getIt<AuthApi>();
  final _statusStreamController = StreamController<Map<int, Map<String, dynamic>>>.broadcast();
  Stream<Map<int, Map<String, dynamic>>> get userStatusStream => _statusStreamController.stream;

  Timer? _statusRefreshTimer;
  final Map<int, Map<String, dynamic>> _userStatuses = {};

  Future<void> setUserOnline(int userId) async {
    try {
      await _userApi.updateUserStatus(userId, {
        'data': {
          'state': "online",
        }
      });
    } catch (e) {
      print('Error setting user online: $e');
    }
  }

  Future<void> setUserOffline(int userId) async {
    try {
      await _userApi.updateUserStatus(userId, {
        'data': {
          'state': "offline",
        }
      });
    } catch (e) {
      print('Error setting user offline: $e');
    }
  }

  Future<void> fetchUserStatus(int userId) async {
    try {
      final response = await _userApi.getUserById(userId);
      if (response.data != null) {
        _userStatuses[userId] = {
          'isOnline': response.data!.state == "online",
        };
        _statusStreamController.add({userId: _userStatuses[userId]!});
      }
    } catch (e) {
      print('Error fetching user status: $e');
    }
  }

  void startStatusPolling() {
    _statusRefreshTimer?.cancel();
    _statusRefreshTimer = Timer.periodic(Duration(seconds: 30), (timer) {
      for (var userId in _userStatuses.keys) {
        fetchUserStatus(userId);
      }
    });
  }

  void listenToAppLifecycle() {
    SystemChannels.lifecycle.setMessageHandler((msg) async {
      if (msg == AppLifecycleState.resumed.toString()) {
        if (Account.instance.user.id != 0) {
          await setUserOnline(Account.instance.user.id);
        }
      } else if (msg == AppLifecycleState.paused.toString() ||
                msg == AppLifecycleState.detached.toString()) {
        if (Account.instance.user.id != 0) {
          await setUserOffline(Account.instance.user.id);
        }
      }
      return null;
    });
  }

  void dispose() {
    _statusRefreshTimer?.cancel();
    _statusStreamController.close();
  }
}