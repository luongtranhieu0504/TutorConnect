import 'dart:convert';

import 'package:shared_preferences/shared_preferences.dart';
import 'package:tutorconnect/data/manager/status.dart';
import 'package:tutorconnect/domain/model/tutor.dart';
import '../../common/stream_wrapper.dart';
import '../../domain/model/student.dart';
import '../../domain/model/user.dart';

class Account {
  static final Account instance = Account._();
  Account._();

  static const _keyUser = 'logged_in_user';

  User? _user;
  User get user => _user!;
  // Add student field
  Student? _student;
  Student? get student => _student;

  final studentBroadcast = StreamWrapper<Student?>(broadcast: true);

  Tutor? _tutor;
  Tutor? get tutor => _tutor;

  final tutorBroadcast = StreamWrapper<Tutor?>(broadcast: true);

  bool _isLoggedIn = false;

  bool get isLoggedIn => _isLoggedIn;

  static const _keyToken = 'auth_token';


  final userBroadcast = StreamWrapper<User?>(broadcast: true);

  Future<void> initialize() async {
    _user = await _loadUserFromPrefs();
    _isLoggedIn = _user != null;
    userBroadcast.add(_user);

    // Set user online status
    // if (_isLoggedIn) {
    //   // Assuming you have a method to set user online
    //   await StatusManager.instance.setUserOnline();
    // }
  }

  Future<void> saveUser(User? user, {String? token}) async {
    final prefs = await SharedPreferences.getInstance();

    if (user == null) {
      await prefs.remove(_keyUser);
      await prefs.remove(_keyToken);
    } else {
      final jsonStr = jsonEncode(user.toJson());
      await prefs.setString(_keyUser, jsonStr);

      if (token != null) {
        await prefs.setString(_keyToken, token);
      }
    }

    _user = user;
    _isLoggedIn = _user != null;
    userBroadcast.add(_user);
  }


  Future<String?> getToken() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString(_keyToken);
  }

  Future<User?> _loadUserFromPrefs() async {
    final prefs = await SharedPreferences.getInstance();
    final jsonStr = prefs.getString(_keyUser);
    if (jsonStr == null) return null;

    try {
      final jsonMap = jsonDecode(jsonStr);
      return User.fromJson(jsonMap);
    } catch (e) {
      return null;
    }
  }

  // Save student data
  void saveStudent(Student? student) {
    _student = student;
    studentBroadcast.add(_student);
  }

  // Save tutor data
  void saveTutor(Tutor? tutor) {
    _tutor = tutor;
    tutorBroadcast.add(_tutor);
  }

  Future<void> signOut() async {
    await StatusManager.instance.setUserOffline();
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove(_keyUser);
    _user = null;
    _isLoggedIn = false;
    _student = null; // Clear student data
    studentBroadcast.add(null);
    _tutor = null; // Clear tutor data
    tutorBroadcast.add(null);
    userBroadcast.add(null);
  }


}
