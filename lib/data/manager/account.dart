import 'dart:convert';

import 'package:shared_preferences/shared_preferences.dart';
import 'package:tutorconnect/data/manager/status.dart';
import 'package:tutorconnect/data/models/users.dart';

import '../../common/stream_wrapper.dart';

class Account {
  static final Account instance = Account._();
  Account._();

  static const _keyUser = 'logged_in_user';

  UserModel? _user;
  UserModel get user => _user!;

  bool _isLoggedIn = false;

  bool get isLoggedIn => _isLoggedIn;

  final userBroadcast = StreamWrapper<UserModel?>(broadcast: true);

  Future<void> initialize() async {
    _user = await _loadUserFromPrefs();
    _isLoggedIn = _user != null;
    userBroadcast.add(_user);

    // Set user online status
    if (_isLoggedIn) {
      // Assuming you have a method to set user online
      await StatusManager.instance.setUserOnline();
    }
  }

  Future<void> saveUser(UserModel? user) async {
    final prefs = await SharedPreferences.getInstance();
    if (user == null) {
      await prefs.remove(_keyUser);
    } else {
      final jsonStr = jsonEncode(user.toJson());
      await prefs.setString(_keyUser, jsonStr);
    }
    _user = user;
    _isLoggedIn = _user != null;
    userBroadcast.add(_user);
  }

  Future<UserModel?> _loadUserFromPrefs() async {
    final prefs = await SharedPreferences.getInstance();
    final jsonStr = prefs.getString(_keyUser);
    if (jsonStr == null) return null;

    try {
      final jsonMap = jsonDecode(jsonStr);
      return UserModel.fromJson(jsonMap);
    } catch (e) {
      return null;
    }
  }

  Future<void> signOut() async {
    await StatusManager.instance.setUserOffline();
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove(_keyUser);
    _user = null;
    _isLoggedIn = false;
    userBroadcast.add(null);
  }


}
