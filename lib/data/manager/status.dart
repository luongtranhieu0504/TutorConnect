import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:tutorconnect/data/models/users.dart';
import '../manager/account.dart';

class StatusManager {
  static final instance = StatusManager._();
  StatusManager._();

  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  // Stream controller to broadcast status changes
  final _userStatusController = StreamController<Map<String, String>>.broadcast();
  Stream<Map<String, String>> get userStatusStream => _userStatusController.stream;

  // Cache of user statuses
  final Map<String, String> _userStatusCache = {};

  // Update status when user logs in
  Future<void> setUserOnline() async {
    if (!Account.instance.isLoggedIn) return;

    final uid = Account.instance.user.uid;
    await _firestore.collection('users').doc(uid).update({
      'status': 'online',
      'lastActive': FieldValue.serverTimestamp(),
    });

    // Update local user model
    final updatedUser = Account.instance.user.copyWith(status: 'online');
    await Account.instance.saveUser(updatedUser);
  }

  // Update status when user logs out or app closes
  Future<void> setUserOffline() async {
    if (!Account.instance.isLoggedIn) return;

    final uid = Account.instance.user.uid;
    await _firestore.collection('users').doc(uid).update({
      'status': 'offline',
      'lastActive': FieldValue.serverTimestamp(),
    });
  }

  // Listen to a specific user's status
  Future<String> getUserStatus(String userId) async {
    if (_userStatusCache.containsKey(userId)) {
      return _userStatusCache[userId]!;
    }

    try {
      final doc = await _firestore.collection('users').doc(userId).get();
      final status = doc.data()?['status'] ?? 'offline';
      _userStatusCache[userId] = status;
      return status;
    } catch (e) {
      return 'offline';
    }
  }

  // Start listening to a user's status changes
  void listenToUserStatus(String userId) {
    _firestore.collection('users').doc(userId).snapshots().listen((snapshot) {
      if (snapshot.exists) {
        final status = snapshot.data()?['status'] ?? 'offline';
        _userStatusCache[userId] = status;
        _userStatusController.add(_userStatusCache);
      }
    });
  }

  // Listen to connection state changes
  void setupPresenceSystem() {
    // Implementation would typically use Firebase Realtime Database
    // for presence system or a periodic status update
  }
}