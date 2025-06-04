// import 'dart:convert';
//
// import 'package:cloud_firestore/cloud_firestore.dart';
// import 'package:firebase_messaging/firebase_messaging.dart';
// import 'package:flutter/cupertino.dart';
// import 'package:flutter_local_notifications/flutter_local_notifications.dart';
// import 'package:go_router/go_router.dart';
// import 'package:tutorconnect/presentation/navigation/route_model.dart';
// import 'package:http/http.dart' as http;
// import '../../data/manager/account.dart';
// import 'package:timezone/timezone.dart' as tz;
//
//
//
// class NotificationService {
//   static final NotificationService _instance = NotificationService._internal();
//   factory NotificationService() => _instance;
//   NotificationService._internal();
//
//   final FlutterLocalNotificationsPlugin _flutterLocalNotificationsPlugin =
//       FlutterLocalNotificationsPlugin();
//
//   final FirebaseMessaging _firebaseMessaging = FirebaseMessaging.instance;
//
//   String? currentConversationId;
//
//   void setCurrentConversationId(String? conversationId) {
//     currentConversationId = conversationId;
//   }
//
//   Future<void> initialize(BuildContext context) async {
//     await _requestPermission();
//
//     // Initialize the local notifications plugin
//     const AndroidInitializationSettings initializationSettingsAndroid =
//         AndroidInitializationSettings('@mipmap/ic_launcher');
//
//     final DarwinInitializationSettings initializationSettingsIOS =
//         DarwinInitializationSettings(
//             requestAlertPermission: false,
//             requestBadgePermission: false,
//             requestSoundPermission: false);
//
//     final InitializationSettings initializationSettings =
//         InitializationSettings(
//       android: initializationSettingsAndroid,
//       iOS: initializationSettingsIOS,
//     );
//
//     await _flutterLocalNotificationsPlugin.initialize(
//       initializationSettings,
//       onDidReceiveNotificationResponse: (details) async {
//         if (details.payload != null) {
//           // Handle the notification tap
//           _handleNotificationTap(context,jsonDecode(details.payload!));
//         }
//       },
//     );
//
//     // Set up Firebase Messaging handlers
//     FirebaseMessaging.onMessage.listen((RemoteMessage message) {
//       _handleForegroundMessage(message);
//     });
//
//     FirebaseMessaging.onMessageOpenedApp.listen((RemoteMessage message) {
//       _handleNotificationTap(
//         context,
//         jsonEncode(message.data)
//       );
//     });
//
//     //Get FCM token
//     final token = await _firebaseMessaging.getToken();
//     _saveUserFCMToken(token);
//     _firebaseMessaging.onTokenRefresh.listen(_saveUserFCMToken);
//   }
//
//
//   Future<void> _requestPermission() async {
//     final settings = await _firebaseMessaging.requestPermission(
//       alert: true,
//       badge: true,
//       sound: true,
//     );
//
//     if (settings.authorizationStatus == AuthorizationStatus.authorized) {
//       debugPrint('User granted permission');
//     } else if (settings.authorizationStatus ==
//         AuthorizationStatus.provisional) {
//       debugPrint('User granted provisional permission');
//     } else {
//       debugPrint('User declined or has not accepted permission');
//     }
//   }
//
//   Future<void> _saveUserFCMToken(String? token) async {
//     final user = Account.instance.user;
//     if (Account.instance.isLoggedIn) {
//       await FirebaseFirestore.instance.collection('users').doc(user.uid).set(
//         {'fcmToken': token}, SetOptions(merge: true),
//       );
//     }
//   }
//
//   Future<void> _handleForegroundMessage(RemoteMessage message) async {
//     //Extract data from the message
//     final data = message.data;
//     final conversationId = data['conversationId'];
//
//     // Only show notification if user is not currently viewing this conversation
//     if (currentConversationId != conversationId) {
//       // Show the notification
//       await _showLocalNotification(
//         title: message.notification?.title,
//         body: message.notification?.body,
//         payload: jsonEncode(data),
//       );
//     }
//   }
//
//   Future<void> _showLocalNotification({
//     String? title,
//     String? body,
//     String? payload,
//   }) async {
//     const AndroidNotificationDetails androidDetails = AndroidNotificationDetails(
//       'chat_channel',
//       'Chat Notifications',
//       channelDescription: 'Notifications for new chat messages',
//       importance: Importance.high,
//       priority: Priority.high,
//       showWhen: true,
//     );
//
//     const NotificationDetails platformDetails = NotificationDetails(
//       android: androidDetails,
//       // iOS: DarwinNotificationDetails(presentAlert: true, presentSound: true),
//     );
//
//     await _flutterLocalNotificationsPlugin.show(
//       DateTime.now().microsecondsSinceEpoch.remainder(100000),
//       title,
//       body,
//       platformDetails,
//       payload: payload,
//     );
//   }
//
//   void _handleNotificationTap(BuildContext context,String payload) {
//     try {
//       final data = jsonDecode(payload);
//       final conversationId = data['conversationId'];
//       final otherUserId = data['senderId'];
//
//       _fetchUserAndNavigate(context, otherUserId, conversationId);
//     } catch (e) {
//       debugPrint('Error handling notification tap: $e');
//     }
//   }
//
//   void _fetchUserAndNavigate(BuildContext context, String userId, String conversationId) async {
//     try {
//       // Fetch user data from Firestore
//       final userDoc = await FirebaseFirestore.instance
//           .collection('users')
//           .doc(userId)
//           .get();
//       if (userDoc.exists) {
//         final userData = userDoc.data();
//         if (userData != null) {
//           // Navigate to the chat screen with the user data
//           context.push(
//             Routes.chatPage,
//             extra: {
//               'user': userData,
//               'conversationId': conversationId,
//             },
//           );
//         }
//       }
//     } catch (e) {
//       debugPrint('Error fetching user data: $e');
//     }
//   }
//
//   Future<void> sendChatNotificationFromClient({
//     required String receiverId,
//     required String senderId,
//     required String conversationId,
//     required String content,
//     required String senderName,
//     required String type,
//   }) async {
//     final uri = Uri.parse('https://us-central1-tutorconnect-1afc7.cloudfunctions.net/sendChatNotification');
//
//     final response = await http.post(
//       uri,
//       headers: {'Content-Type': 'application/json'},
//       body: jsonEncode({
//         'receiverId': receiverId,
//         'senderId': senderId,
//         'conversationId': conversationId,
//         'content': content,
//         'senderName': senderName,
//         'type': type,
//       }),
//     );
//     print('Notification Response: ${response.statusCode}, ${response.body}');
//   }
//
//   Future<void> scheduleReminderNotification({
//     required String scheduleId,
//     required String body,
//     required DateTime scheduledTime,
//   }) async {
//     final notificationTime = scheduledTime.subtract(Duration(hours: 5));
//
//     await _flutterLocalNotificationsPlugin.zonedSchedule(
//       scheduleId.hashCode,
//       'Nhắc nhở lịch học',
//       body,
//       tz.TZDateTime.from(notificationTime, tz.local),
//       const NotificationDetails(
//         android: AndroidNotificationDetails(
//           'schedule_channel',
//           'Lịch học',
//           importance: Importance.max,
//           priority: Priority.high,
//         ),
//       ),
//       matchDateTimeComponents: DateTimeComponents.time,
//       androidScheduleMode: AndroidScheduleMode.inexactAllowWhileIdle,
//     );
//   }
//
// }
