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

  static const FirebaseOptions android = FirebaseOptions(
    apiKey: 'AIzaSyB1-u2fVsDrEHCujXbYSXF_pKzE3ORwwr8',
    appId: '1:687029934885:android:70b154d443a3844b9f98cc',
    messagingSenderId: '687029934885',
    projectId: 'clarisco-9e5ed',
    storageBucket: 'clarisco-9e5ed.firebasestorage.app',
  );

  static const FirebaseOptions ios = FirebaseOptions(
    apiKey: 'AIzaSyAHlOWebbM80X2oK7S0kDDAhgPtCyarnbU',
    appId: '1:687029934885:ios:87aaebd9a3252a3c9f98cc',
    messagingSenderId: '687029934885',
    projectId: 'clarisco-9e5ed',
    storageBucket: 'clarisco-9e5ed.firebasestorage.app',
    iosBundleId: 'com.example.clarisco',
  );

  static const FirebaseOptions web = FirebaseOptions(
    apiKey: 'AIzaSyBgcLndFtR1S-21aFyBUMH0V_iBg1vt1FU',
    appId: '1:687029934885:web:4aa7641bee78b9249f98cc',
    messagingSenderId: '687029934885',
    projectId: 'clarisco-9e5ed',
    authDomain: 'clarisco-9e5ed.firebaseapp.com',
    storageBucket: 'clarisco-9e5ed.firebasestorage.app',
    measurementId: 'G-XQY3T45QTC',
  );

  static const FirebaseOptions macos = FirebaseOptions(
    apiKey: 'AIzaSyAHlOWebbM80X2oK7S0kDDAhgPtCyarnbU',
    appId: '1:687029934885:ios:87aaebd9a3252a3c9f98cc',
    messagingSenderId: '687029934885',
    projectId: 'clarisco-9e5ed',
    storageBucket: 'clarisco-9e5ed.firebasestorage.app',
    iosBundleId: 'com.example.clarisco',
  );

  static const FirebaseOptions windows = FirebaseOptions(
    apiKey: 'AIzaSyBgcLndFtR1S-21aFyBUMH0V_iBg1vt1FU',
    appId: '1:687029934885:web:2fcb597530dbc8d29f98cc',
    messagingSenderId: '687029934885',
    projectId: 'clarisco-9e5ed',
    authDomain: 'clarisco-9e5ed.firebaseapp.com',
    storageBucket: 'clarisco-9e5ed.firebasestorage.app',
    measurementId: 'G-2QQPQHSS8X',
  );

}