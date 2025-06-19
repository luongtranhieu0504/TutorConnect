import 'dart:convert';

import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:go_router/go_router.dart';
import 'package:tutorconnect/data/network/socket/socket_service.dart';
import 'package:tutorconnect/domain/model/message.dart' as message_model;
import 'package:tutorconnect/presentation/navigation/route_model.dart';
import 'package:http/http.dart' as http;
import '../../data/manager/account.dart';
import '../../config/app_config.dart';
import 'package:timezone/timezone.dart' as tz;
import '../../di/di.dart';
import '../model/conversation.dart';
import '../repository/auth_repository.dart';

class NotificationService {
  static final NotificationService _instance = NotificationService._internal(
    getIt<SocketService>(),
    getIt<AuthRepository>(),
  );
  factory NotificationService() => _instance;
  NotificationService._internal(this._socketService, this._authRepository);

  final FlutterLocalNotificationsPlugin _flutterLocalNotificationsPlugin =
      FlutterLocalNotificationsPlugin();

  final FirebaseMessaging _firebaseMessaging = FirebaseMessaging.instance;

  // Reference to socket service
  late final SocketService _socketService;

  // Track current conversation to avoid notifications
  int? currentConversationId;
  final AuthRepository _authRepository;

  void setCurrentConversationId(int? conversationId) {
    currentConversationId = conversationId;
  }

  Future<void> initialize(BuildContext context) async {
    await _requestPermission();

    // Initialize local notifications plugin
    const AndroidInitializationSettings initializationSettingsAndroid =
        AndroidInitializationSettings('@mipmap/ic_launcher');

    final DarwinInitializationSettings initializationSettingsIOS =
        DarwinInitializationSettings(
            requestAlertPermission: false,
            requestBadgePermission: false,
            requestSoundPermission: false);

    final InitializationSettings initializationSettings =
        InitializationSettings(
      android: initializationSettingsAndroid,
      iOS: initializationSettingsIOS,
    );

    await _flutterLocalNotificationsPlugin.initialize(
      initializationSettings,
      onDidReceiveNotificationResponse: (details) async {
        if (details.payload != null) {
          debugPrint('Notification tapped with payload: ${details.payload}');
          _handleNotificationTap(context, jsonDecode(details.payload!));
        }
      },
    );

    // Set up Firebase Messaging handlers
    FirebaseMessaging.onMessage.listen(_handleForegroundMessage);

    FirebaseMessaging.onMessageOpenedApp.listen((RemoteMessage message) {
      _handleNotificationTap(context, message.data);
    });

    // Get FCM token and send to Strapi backend
    final token = await _firebaseMessaging.getToken();
    _saveUserFCMToken(token);
    _firebaseMessaging.onTokenRefresh.listen(_saveUserFCMToken);

    // Listen for socket messages
    _listenToSocketMessages();
  }

  void _listenToSocketMessages() {
    _socketService.messageStream.listen((message) {
      debugPrint('Socket message received: ${message.id} in conversation ${message.conversation?.id}');

      // Don't show notifications for messages sent by the current user
      if (message.sender?.id == Account.instance.user.id) {
        debugPrint('Skipping notification for own message');
        return;
      }

      // Check if user is currently in this conversation
      if (currentConversationId != null &&
          message.conversation?.id == currentConversationId) {
        debugPrint('User is in conversation $currentConversationId, skipping notification');
        return;
      }

      // Show notification for messages from other users when not in that conversation
      _showLocalNotification(
        title: message.sender?.name ?? 'New message',
        body: _getMessagePreview(message),
        payload: jsonEncode({
          'conversation': message.conversation, // truyền object luôn
          'senderId': message.sender?.id.toString() ?? '',
        }),
      );
    });

    // Monitor socket connection status for debugging
    _socketService.connectedStream.listen((isConnected) {
      debugPrint('Socket connection status: $isConnected');

      // If reconnected, verify we're joined to relevant conversation rooms
      // if (isConnected && currentConversationId != null) {
      //   _socketService.joinConversation(currentConversationId!);
      // }
    });
  }

  String? _getMessagePreview(message_model.Message message) {
    switch (message.type) {
      case 'text':
        return message.content;
      case 'image':
        return 'Sent an image';
      case 'video':
        return 'Sent a video';
      case 'file':
        return 'Sent a file';
      default:
        return 'New message';
    }
  }

  Future<void> _requestPermission() async {
    final settings = await _firebaseMessaging.requestPermission(
      alert: true,
      badge: true,
      sound: true,
    );

    if (settings.authorizationStatus == AuthorizationStatus.authorized) {
      debugPrint('User granted permission');
    } else if (settings.authorizationStatus == AuthorizationStatus.provisional) {
      debugPrint('User granted provisional permission');
    } else {
      debugPrint('User declined or has not accepted permission');
    }
  }

  Future<void> _saveUserFCMToken(String? token) async {
    if (token == null || !Account.instance.isLoggedIn) return;
    await _authRepository.saveFcmToken(token);
  }

  Future<void> _handleForegroundMessage(RemoteMessage message) async {
    final data = message.data;
    final type = data['type'];

    if (type == 'chat') {
      // Xử lý chat như cũ
      final conversationJson = data['conversation'];
      final conversation = conversationJson is String
          ? Conversation.fromJson(jsonDecode(conversationJson))
          : Conversation.fromJson(conversationJson);

      if (currentConversationId != conversation.id) {
        await _showLocalNotification(
          title: message.notification?.title ?? 'Tin nhắn mới',
          body: message.notification?.body ?? '',
          payload: jsonEncode(data),
        );
      }
    } else {
      // Xử lý các loại notify khác (reminder, schedule, ...)
      String title = message.notification?.title ?? data['title'] ?? 'Thông báo';
      String body = message.notification?.body ?? data['body'] ?? data['content'] ?? '';
      await _showLocalNotification(
        title: title,
        body: body,
        payload: jsonEncode(data),
      );
    }
  }

  Future<void> _showLocalNotification({
    String? title,
    String? body,
    String? payload,
  }) async {
    const AndroidNotificationDetails androidDetails = AndroidNotificationDetails(
      'chat_channel',
      'Chat Notifications',
      channelDescription: 'Notifications for new chat messages',
      importance: Importance.high,
      priority: Priority.high,
      showWhen: true,
    );

    const NotificationDetails platformDetails = NotificationDetails(
      android: androidDetails,
      iOS: DarwinNotificationDetails(presentAlert: true, presentSound: true),
    );

    await _flutterLocalNotificationsPlugin.show(
      DateTime.now().microsecondsSinceEpoch.remainder(100000),
      title,
      body,
      platformDetails,
      payload: payload,
    );
  }

  void _handleNotificationTap(BuildContext context, Map<String, dynamic> data) {
    try {
      debugPrint('Notification payload: $data');
      final type = data['type'];
      if (type == 'chat') {
        final conversationJson = data['conversation'];
        final conversation = conversationJson is String
            ? Conversation.fromJson(jsonDecode(conversationJson))
            : Conversation.fromJson(conversationJson);
        final otherUserId = int.tryParse(data['senderId'].toString());
        _fetchUserAndNavigate(context, otherUserId!, conversation);
      } else if (type == 'reminder' || type == 'schedule') {
        // Ví dụ: điều hướng đến trang lịch học
        context.push(
          Routes.schedulePage
        );
      } else {
        // Các loại notify khác
        // Có thể show dialog hoặc điều hướng tùy ý
        debugPrint('Unhandled notification type: $type');
      }
    } catch (e) {
      debugPrint('Error handling notification tap: $e');
    }
  }

  Future<void> _fetchUserAndNavigate(BuildContext context, int id, Conversation conversation) async {
    try {
      // Fetch user data using AuthRepository
      final result = await _authRepository.getUserById(id);

      result.when(
        success: (user) {
          if (user != null) {
            // Navigate to the chat screen
            context.push(
              Routes.chatPage,
              extra: {
                'user': user,
                'conversation': conversation,
              },
            );
          }
        },
        failure: (error) {
          debugPrint('Error fetching user data: $error');
        },
      );
    } catch (e) {
      debugPrint('Error in _fetchUserAndNavigate: $e');
    }
  }

}