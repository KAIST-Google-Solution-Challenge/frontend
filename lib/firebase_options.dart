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
        return ios;
      case TargetPlatform.macOS:
        return macos;
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
    apiKey: 'AIzaSyDPbsO6kIKVF_AuD_fU1yytonybnwOUymc',
    appId: '1:28208195456:web:342e5f2473156402d24365',
    messagingSenderId: '28208195456',
    projectId: 'the-voice-0235',
    authDomain: 'the-voice-0235.firebaseapp.com',
    storageBucket: 'the-voice-0235.appspot.com',
  );

  static const FirebaseOptions android = FirebaseOptions(
    apiKey: 'AIzaSyBeWNiJ-iNVf6gScP4xPCnA07Kg3Bn5oZw',
    appId: '1:28208195456:android:4b42252cc2d309f6d24365',
    messagingSenderId: '28208195456',
    projectId: 'the-voice-0235',
    storageBucket: 'the-voice-0235.appspot.com',
  );

  static const FirebaseOptions ios = FirebaseOptions(
    apiKey: 'AIzaSyDB3PomOnUdsN940tZ5RggsYgdwzug5o_s',
    appId: '1:28208195456:ios:db59721a1988886cd24365',
    messagingSenderId: '28208195456',
    projectId: 'the-voice-0235',
    storageBucket: 'the-voice-0235.appspot.com',
    iosClientId: '28208195456-7dqr7i68s2s7hjr8ltbk2ib70fcu0a55.apps.googleusercontent.com',
    iosBundleId: 'com.example.theVoice',
  );

  static const FirebaseOptions macos = FirebaseOptions(
    apiKey: 'AIzaSyDB3PomOnUdsN940tZ5RggsYgdwzug5o_s',
    appId: '1:28208195456:ios:d8ec70e4b0f55662d24365',
    messagingSenderId: '28208195456',
    projectId: 'the-voice-0235',
    storageBucket: 'the-voice-0235.appspot.com',
    iosClientId: '28208195456-i0uocpoea8e3v118uc728acoamguofnl.apps.googleusercontent.com',
    iosBundleId: 'com.example.theVoice.RunnerTests',
  );
}
