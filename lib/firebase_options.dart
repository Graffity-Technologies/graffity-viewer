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

  static const FirebaseOptions web = FirebaseOptions(
    apiKey: 'AIzaSyAwqGieA3X7-ADnNwLuSsuxwDhRe-FH9oQ',
    appId: '1:711625420808:web:37f69ddb81a86fc6b7a1bd',
    messagingSenderId: '711625420808',
    projectId: 'graffity-viewer',
    authDomain: 'graffity-viewer.firebaseapp.com',
    storageBucket: 'graffity-viewer.appspot.com',
    measurementId: 'G-Q3FX6229VX',
  );

  static const FirebaseOptions android = FirebaseOptions(
    apiKey: 'AIzaSyAk8DYLvdRIoaKFE0f_rvPoumAgcXXgPsI',
    appId: '1:711625420808:android:9ee8e3f384dddda1b7a1bd',
    messagingSenderId: '711625420808',
    projectId: 'graffity-viewer',
    storageBucket: 'graffity-viewer.appspot.com',
  );

  static const FirebaseOptions ios = FirebaseOptions(
    apiKey: 'AIzaSyCFCvi0cqU5PINt7pvt_GVd6L4dcF3tjYw',
    appId: '1:711625420808:ios:8f6c468241d3725bb7a1bd',
    messagingSenderId: '711625420808',
    projectId: 'graffity-viewer',
    storageBucket: 'graffity-viewer.appspot.com',
    iosBundleId: 'app.graffity.ar-viewer',
  );

}