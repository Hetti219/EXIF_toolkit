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
        throw UnsupportedError(
          'DefaultFirebaseOptions have not been configured for macos - '
          'you can reconfigure this by running the FlutterFire CLI again.',
        );
      case TargetPlatform.windows:
        throw UnsupportedError(
          'DefaultFirebaseOptions have not been configured for windows - '
          'you can reconfigure this by running the FlutterFire CLI again.',
        );
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
    apiKey: 'AIzaSyD8a81dpF2R5q6Yq9_vLqM8mitSsR3J2kk',
    appId: '1:183825030045:android:6a7a23608fd521009d6d74',
    messagingSenderId: '183825030045',
    projectId: 'exif-toolkit',
    storageBucket: 'exif-toolkit.appspot.com',
  );

  static const FirebaseOptions ios = FirebaseOptions(
    apiKey: 'AIzaSyDQ2d_qb558VYAAlGQEgt5_vjI76Rk4gJ4',
    appId: '1:183825030045:ios:07f069658f3401a29d6d74',
    messagingSenderId: '183825030045',
    projectId: 'exif-toolkit',
    storageBucket: 'exif-toolkit.appspot.com',
    iosBundleId: 'io.github.hetti219.exifToolkit',
  );

  static const FirebaseOptions web = FirebaseOptions(
    apiKey: 'AIzaSyAf0TLt2F4NbqBiduf5P5WcwQ989spO8-g',
    appId: '1:183825030045:web:2e9a9c42ae9ca6e59d6d74',
    messagingSenderId: '183825030045',
    projectId: 'exif-toolkit',
    authDomain: 'exif-toolkit.firebaseapp.com',
    storageBucket: 'exif-toolkit.appspot.com',
    measurementId: 'G-9CLVH5855W',
  );
}
