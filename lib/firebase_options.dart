// File generated by FlutterFire CLI.
// ignore_for_file: lines_longer_than_80_chars, avoid_classes_with_only_static_members
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
        throw UnsupportedError(
          'DefaultFirebaseOptions have not been configured for ios - '
          'you can reconfigure this by running the FlutterFire CLI again.',
        );
      case TargetPlatform.macOS:
        throw UnsupportedError(
          'DefaultFirebaseOptions have not been configured for macos - '
          'you can reconfigure this by running the FlutterFire CLI again.',
        );
      default:
        throw UnsupportedError(
          'DefaultFirebaseOptions are not supported for this platform.',
        );
    }
  }

  static const FirebaseOptions web = FirebaseOptions(
    apiKey: 'AIzaSyAAJ3aSvsGB-P_HyQKzCW2zy7SbLcbS7to',
    appId: '1:728616303070:web:01b44c9f3df6606326054f',
    messagingSenderId: '728616303070',
    projectId: 'medanalysis-f7776',
    authDomain: 'medanalysis-f7776.firebaseapp.com',
    storageBucket: 'medanalysis-f7776.appspot.com',
    measurementId: 'G-T6FJTEPF6V',
  );

  static const FirebaseOptions android = FirebaseOptions(
    apiKey: 'AIzaSyCprEIjHK6lPMYHKTCedOakXRjjnyKMWl4',
    appId: '1:728616303070:android:de318d5f472251a826054f',
    messagingSenderId: '728616303070',
    projectId: 'medanalysis-f7776',
    storageBucket: 'medanalysis-f7776.appspot.com',
  );
}
