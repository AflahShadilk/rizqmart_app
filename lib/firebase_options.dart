

import 'package:firebase_core/firebase_core.dart' show FirebaseOptions;
import 'package:flutter/foundation.dart'
    show defaultTargetPlatform, kIsWeb, TargetPlatform;











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
    apiKey: 'AIzaSyCmDFLzf2pA20q8G31qvlQ5LEowlgn0n5s',
    appId: '1:570019429913:web:269440b2234eddcb623488',
    messagingSenderId: '570019429913',
    projectId: 'rizqmart-486b8',
    authDomain: 'rizqmart-486b8.firebaseapp.com',
    storageBucket: 'rizqmart-486b8.firebasestorage.app',
    measurementId: 'G-7L6Y3YRF9C',
  );

  static const FirebaseOptions android = FirebaseOptions(
    apiKey: 'AIzaSyC0AT2C41Rrd_nF1feRffyMWwCpHOgh7bI',
    appId: '1:570019429913:android:4104029167ca20c9623488',
    messagingSenderId: '570019429913',
    projectId: 'rizqmart-486b8',
    storageBucket: 'rizqmart-486b8.firebasestorage.app',
  );

  static const FirebaseOptions ios = FirebaseOptions(
    apiKey: 'AIzaSyDlffjZZPGvin3C9A3AjBKe7zkBP7wiv4g',
    appId: '1:570019429913:ios:5d9d83d5ba856f9e623488',
    messagingSenderId: '570019429913',
    projectId: 'rizqmart-486b8',
    storageBucket: 'rizqmart-486b8.firebasestorage.app',
    iosBundleId: 'com.example.rizqmart',
  );

  static const FirebaseOptions macos = FirebaseOptions(
    apiKey: 'AIzaSyDlffjZZPGvin3C9A3AjBKe7zkBP7wiv4g',
    appId: '1:570019429913:ios:5d9d83d5ba856f9e623488',
    messagingSenderId: '570019429913',
    projectId: 'rizqmart-486b8',
    storageBucket: 'rizqmart-486b8.firebasestorage.app',
    iosBundleId: 'com.example.rizqmart',
  );

  static const FirebaseOptions windows = FirebaseOptions(
    apiKey: 'AIzaSyCmDFLzf2pA20q8G31qvlQ5LEowlgn0n5s',
    appId: '1:570019429913:web:a9339031deda90dc623488',
    messagingSenderId: '570019429913',
    projectId: 'rizqmart-486b8',
    authDomain: 'rizqmart-486b8.firebaseapp.com',
    storageBucket: 'rizqmart-486b8.firebasestorage.app',
    measurementId: 'G-GD2D6DYKP4',
  );
}
