// import 'dart:ffi';
//
// late Size mq;
//
// Future<void> main() async {
//   WidgetsFlutterBinding.ensureInitialized();
//
//   //enter full-screen
//   SystemChrome.setEnabledSystemUIMode(SystemUiMode.immersiveSticky);
//
//   await _initializeFirebase();
//
//   //for setting orientation to portrait only
//   SystemChrome.setPreferredOrientations(
//       [DeviceOrientation.portraitUp, DeviceOrientation.portraitDown])
//       .then((value) {
//     runApp(const MyApp());
//   });
// }
//
// class MyApp extends StatelessWidget {
//   const MyApp({super.key});
//
//   @override
//   Widget build(BuildContext context) {
//     return MaterialApp(
//         title: 'We Chat',
//         debugShowCheckedModeBanner: false,
//         theme: ThemeData(
//             useMaterial3: false,
//             appBarTheme: const AppBarTheme(
//               centerTitle: true,
//               elevation: 1,
//               iconTheme: IconThemeData(color: Colors.black),
//               titleTextStyle: TextStyle(
//                   color: Colors.black,
//                   fontWeight: FontWeight.normal,
//                   fontSize: 19),
//               backgroundColor: Colors.white,
//             )),
//         tutor_home: const SplashScreen());
//   }
// }
//
// Future<void> _initializeFirebase() async {
//   await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
//
//   var result = await FlutterNotificationChannel().registerNotificationChannel(
//       description: 'For Showing Message Notification',
//       id: 'chats',
//       importance: NotificationImportance.IMPORTANCE_HIGH,
//       name: 'Chats');
//
//   log('\nNotification Channel Result: $result');
// }