
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
    apiKey: 'AIzaSyC9paRqN3VpPl_31QNYs-I0cX_zIA89fGM',
    appId: '1:156883132531:web:fb00c456f3222dc5254a06',
    messagingSenderId: '156883132531',
    projectId: 'diplom-323b8',
    authDomain: 'diplom-323b8.firebaseapp.com',
    storageBucket: 'diplom-323b8.firebasestorage.app',
  );

  static const FirebaseOptions android = FirebaseOptions(
    apiKey: 'AIzaSyAPcl5HnZCIlWe2S98dU5u7Srk8C372YLA',
    appId: '1:156883132531:android:1a94ebed100f08d8254a06',
    messagingSenderId: '156883132531',
    projectId: 'diplom-323b8',
    storageBucket: 'diplom-323b8.firebasestorage.app',
  );

  static const FirebaseOptions ios = FirebaseOptions(
    apiKey: 'AIzaSyC7SE1pY9H-I871Ebd3bEM4r0QBAbv9n50',
    appId: '1:156883132531:ios:0f5043da85bc92c8254a06',
    messagingSenderId: '156883132531',
    projectId: 'diplom-323b8',
    storageBucket: 'diplom-323b8.firebasestorage.app',
    iosBundleId: 'com.example.emiinzaavar10',
  );

  static const FirebaseOptions macos = FirebaseOptions(
    apiKey: 'AIzaSyC7SE1pY9H-I871Ebd3bEM4r0QBAbv9n50',
    appId: '1:156883132531:ios:0f5043da85bc92c8254a06',
    messagingSenderId: '156883132531',
    projectId: 'diplom-323b8',
    storageBucket: 'diplom-323b8.firebasestorage.app',
    iosBundleId: 'com.example.emiinzaavar10',
  );

  static const FirebaseOptions windows = FirebaseOptions(
    apiKey: 'AIzaSyC9paRqN3VpPl_31QNYs-I0cX_zIA89fGM',
    appId: '1:156883132531:web:8b653d7a972c9b7d254a06',
    messagingSenderId: '156883132531',
    projectId: 'diplom-323b8',
    authDomain: 'diplom-323b8.firebaseapp.com',
    storageBucket: 'diplom-323b8.firebasestorage.app',
  );
}
