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
    apiKey: 'AIzaSyD-qLsnOmL4wvROIRA7a0X-NeK3Z3XKOgY',
    appId: '1:24711817018:web:56aebc1a9070153dad1203',
    messagingSenderId: '24711817018',
    projectId: 'amonguscards-8e42a',
    authDomain: 'amonguscards-8e42a.firebaseapp.com',
    storageBucket: 'amonguscards-8e42a.firebasestorage.app',
    measurementId: 'G-3VM8XR2WHH',
  );

  static const FirebaseOptions android = FirebaseOptions(
    apiKey: 'AIzaSyAOzxPsdIuSGy51iiaNQbqmD0sfOZGLj_A',
    appId: '1:24711817018:android:c2ca3af729fa7b38ad1203',
    messagingSenderId: '24711817018',
    projectId: 'amonguscards-8e42a',
    storageBucket: 'amonguscards-8e42a.firebasestorage.app',
  );

  static const FirebaseOptions ios = FirebaseOptions(
    apiKey: 'AIzaSyA5buD-hEIT0tKQ682YkANIRtfsRy-ZAHU',
    appId: '1:24711817018:ios:498311cbacaa1ca3ad1203',
    messagingSenderId: '24711817018',
    projectId: 'amonguscards-8e42a',
    storageBucket: 'amonguscards-8e42a.firebasestorage.app',
    iosBundleId: 'com.example.amongusCards',
  );

  static const FirebaseOptions macos = FirebaseOptions(
    apiKey: 'AIzaSyA5buD-hEIT0tKQ682YkANIRtfsRy-ZAHU',
    appId: '1:24711817018:ios:498311cbacaa1ca3ad1203',
    messagingSenderId: '24711817018',
    projectId: 'amonguscards-8e42a',
    storageBucket: 'amonguscards-8e42a.firebasestorage.app',
    iosBundleId: 'com.example.amongusCards',
  );

  static const FirebaseOptions windows = FirebaseOptions(
    apiKey: 'AIzaSyD-qLsnOmL4wvROIRA7a0X-NeK3Z3XKOgY',
    appId: '1:24711817018:web:dbc65b2a32da65e0ad1203',
    messagingSenderId: '24711817018',
    projectId: 'amonguscards-8e42a',
    authDomain: 'amonguscards-8e42a.firebaseapp.com',
    storageBucket: 'amonguscards-8e42a.firebasestorage.app',
    measurementId: 'G-R02NZ5YMQW',
  );
}
