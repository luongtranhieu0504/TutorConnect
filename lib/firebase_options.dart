// File generated by FlutterFire CLI.
// ignore_for_file: type=lint
import 'package:firebase_core/firebase_core.dart' show FirebaseOptions;
import 'package:flutter/foundation.dart'
    show defaultTargetPlatform, kIsWeb, TargetPlatform;

/// Default [FirebaseOptions] for use with your Firebase apps.
///
/// Example:
/// ```dart
/// import 'firebase_options.dart';
/// // ...
/// await Firebase.initializeApp(
///   options: DefaultFirebaseOptions.currentPlatform,
/// );
/// ```
class DefaultFirebaseOptions {
  static FirebaseOptions get currentPlatform {
    if (kIsWeb) {
      return web;
    }
    switch (defaultTargetPlatform) {
      case TargetPlatform.android:
        return android;
      case TargetPlatform.iOS:
        return ios;
      case TargetPlatform.macOS:
        return macos;
      case TargetPlatform.windows:
        return windows;
      case TargetPlatform.linux:
        throw UnsupportedError(
          'DefaultFirebaseOptions have not been configured for linux - '
          'you can reconfigure this by running the FlutterFire CLI again.',
        );
      default:
        throw UnsupportedError(
          'DefaultFirebaseOptions are not supported for this platform.',
        );
    }
  }

  static const FirebaseOptions web = FirebaseOptions(
    apiKey: 'AIzaSyC9yVbCRjBZScHMeNmlKflR86vE6RenmUs',
    appId: '1:1038751662297:web:99bf4ffb6182312d1e7ec8',
    messagingSenderId: '1038751662297',
    projectId: 'tutorconnect-1afc7',
    authDomain: 'tutorconnect-1afc7.firebaseapp.com',
    storageBucket: 'tutorconnect-1afc7.firebasestorage.app',
    measurementId: 'G-C4PW7KQG68',
  );

  static const FirebaseOptions android = FirebaseOptions(
    apiKey: 'AIzaSyCzh8K6gZK9M0Z93Bgh-FhXncjqo2NLh-E',
    appId: '1:1038751662297:android:75a1ab2360c35c071e7ec8',
    messagingSenderId: '1038751662297',
    projectId: 'tutorconnect-1afc7',
    storageBucket: 'tutorconnect-1afc7.firebasestorage.app',
  );

  static const FirebaseOptions ios = FirebaseOptions(
    apiKey: 'AIzaSyBOPr-e2uMd5dPR0BnF4LobzqGAP_fyFRs',
    appId: '1:1038751662297:ios:df0bf87d73fd5a111e7ec8',
    messagingSenderId: '1038751662297',
    projectId: 'tutorconnect-1afc7',
    storageBucket: 'tutorconnect-1afc7.firebasestorage.app',
    iosBundleId: 'com.example.tutorconnect',
  );

  static const FirebaseOptions macos = FirebaseOptions(
    apiKey: 'AIzaSyBOPr-e2uMd5dPR0BnF4LobzqGAP_fyFRs',
    appId: '1:1038751662297:ios:df0bf87d73fd5a111e7ec8',
    messagingSenderId: '1038751662297',
    projectId: 'tutorconnect-1afc7',
    storageBucket: 'tutorconnect-1afc7.firebasestorage.app',
    iosBundleId: 'com.example.tutorconnect',
  );

  static const FirebaseOptions windows = FirebaseOptions(
    apiKey: 'AIzaSyC9yVbCRjBZScHMeNmlKflR86vE6RenmUs',
    appId: '1:1038751662297:web:4f172e4ab4652a771e7ec8',
    messagingSenderId: '1038751662297',
    projectId: 'tutorconnect-1afc7',
    authDomain: 'tutorconnect-1afc7.firebaseapp.com',
    storageBucket: 'tutorconnect-1afc7.firebasestorage.app',
    measurementId: 'G-HYMLP0KYB9',
  );
}
