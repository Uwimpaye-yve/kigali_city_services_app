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
    apiKey: 'AIzaSyD4wJfbfyigi3Nh9wBf_Sk1MS6mI3lmB40',
    appId: '1:751208466456:web:421a67a7dc4f8e336a5b6d',
    messagingSenderId: '751208466456',
    projectId: 'kigali-services-aa9b0',
    authDomain: 'kigali-services-aa9b0.firebaseapp.com',
    storageBucket: 'kigali-services-aa9b0.firebasestorage.app',
    measurementId: 'G-FKY722QV3R',
  );

  static const FirebaseOptions android = FirebaseOptions(
    apiKey: 'AIzaSyB64CwV94g8XM5IaEzKlFmbOIw2rN0tXFM',
    appId: '1:751208466456:android:592bfdd97d6e53d26a5b6d',
    messagingSenderId: '751208466456',
    projectId: 'kigali-services-aa9b0',
    storageBucket: 'kigali-services-aa9b0.firebasestorage.app',
  );

  static const FirebaseOptions ios = FirebaseOptions(
    apiKey: 'AIzaSyC_AFcxm81OMjzVEad4kOn0pHjbn1o-8rg',
    appId: '1:751208466456:ios:f9f33f42406e6b446a5b6d',
    messagingSenderId: '751208466456',
    projectId: 'kigali-services-aa9b0',
    storageBucket: 'kigali-services-aa9b0.firebasestorage.app',
    iosBundleId: 'com.example.kigaliCityServicesApp',
  );

  static const FirebaseOptions macos = FirebaseOptions(
    apiKey: 'AIzaSyC_AFcxm81OMjzVEad4kOn0pHjbn1o-8rg',
    appId: '1:751208466456:ios:f9f33f42406e6b446a5b6d',
    messagingSenderId: '751208466456',
    projectId: 'kigali-services-aa9b0',
    storageBucket: 'kigali-services-aa9b0.firebasestorage.app',
    iosBundleId: 'com.example.kigaliCityServicesApp',
  );

  static const FirebaseOptions windows = FirebaseOptions(
    apiKey: 'AIzaSyD4wJfbfyigi3Nh9wBf_Sk1MS6mI3lmB40',
    appId: '1:751208466456:web:9959a437141c55a16a5b6d',
    messagingSenderId: '751208466456',
    projectId: 'kigali-services-aa9b0',
    authDomain: 'kigali-services-aa9b0.firebaseapp.com',
    storageBucket: 'kigali-services-aa9b0.firebasestorage.app',
    measurementId: 'G-CH9D1XMY9R',
  );

}