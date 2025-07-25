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
    apiKey: 'AIzaSyDXcmBde2mOrvn-3Pu2scpqeBOnLeWTNm4',
    appId: '1:133383948016:web:1a12019e5aece49e172435',
    messagingSenderId: '133383948016',
    projectId: 'miecal-7190e',
    authDomain: 'miecal-7190e.firebaseapp.com',
    storageBucket: 'miecal-7190e.firebasestorage.app',
  );

  static const FirebaseOptions android = FirebaseOptions(
    apiKey: 'AIzaSyBMzW4oPet2-YyQpufeX4kdcOyBZmFKpMg',
    appId: '1:133383948016:android:c4a58557b5967b37172435',
    messagingSenderId: '133383948016',
    projectId: 'miecal-7190e',
    storageBucket: 'miecal-7190e.firebasestorage.app',
  );

  static const FirebaseOptions ios = FirebaseOptions(
    apiKey: 'AIzaSyCk_WzUbZlvLow1_2tHVJfIg3BOR8qcBfw',
    appId: '1:133383948016:ios:4f65d56016322cc4172435',
    messagingSenderId: '133383948016',
    projectId: 'miecal-7190e',
    storageBucket: 'miecal-7190e.firebasestorage.app',
    iosBundleId: 'com.example.miecal',
  );

  static const FirebaseOptions macos = FirebaseOptions(
    apiKey: 'AIzaSyCk_WzUbZlvLow1_2tHVJfIg3BOR8qcBfw',
    appId: '1:133383948016:ios:4f65d56016322cc4172435',
    messagingSenderId: '133383948016',
    projectId: 'miecal-7190e',
    storageBucket: 'miecal-7190e.firebasestorage.app',
    iosBundleId: 'com.example.miecal',
  );

  static const FirebaseOptions windows = FirebaseOptions(
    apiKey: 'AIzaSyDXcmBde2mOrvn-3Pu2scpqeBOnLeWTNm4',
    appId: '1:133383948016:web:0dced09408bdaa45172435',
    messagingSenderId: '133383948016',
    projectId: 'miecal-7190e',
    authDomain: 'miecal-7190e.firebaseapp.com',
    storageBucket: 'miecal-7190e.firebasestorage.app',
  );
}
