import 'dart:async';
import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:flutter_background_service/flutter_background_service.dart';
import 'package:flutter_background_service_android/flutter_background_service_android.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:phone_state/phone_state.dart';
import 'package:telephony/telephony.dart';
import 'package:the_voice/controller/call_controller.dart';
import 'package:the_voice/controller/message_controller.dart';
import 'package:the_voice/util/constant.dart';

class BackgroundController {
  PhoneStateStatus status = PhoneStateStatus.NOTHING;
  bool granted = false;

  final service = FlutterBackgroundService();
  final telephony = Telephony.instance;

  static const notificationChannelId = 'the-voice';
  static const notificationId = 888;
  static const notificationTitle = 'The Voice';

  Future<void> init() async {
    var permission = await requestPermission();
    if (permission) {
      _setCallStream();
      _setSmsStream();
      await _initBackService();
    }
  }

  Future<bool> requestPermission() async {
    var status = await Permission.phone.request();

    switch (status) {
      case PermissionStatus.denied:
      case PermissionStatus.restricted:
      case PermissionStatus.limited:
      case PermissionStatus.permanentlyDenied:
        return false;
      case PermissionStatus.granted:
        return true;
    }
  }

  void _setCallStream() {
    PhoneState.phoneStateStream.listen((event) {
      if (event != null) {
        print('Call event occur: $event');
        if (event == PhoneStateStatus.CALL_ENDED) {
          Future.delayed(const Duration(seconds: 10), analyzeCall);
        }
        status = event;
      }
    });
  }

  void _setSmsStream() {
    telephony.listenIncomingSms(
        onNewMessage: (SmsMessage message) async {
          messageHandler(message);
        },
        onBackgroundMessage: messageHandler);
  }

  static void messageHandler(SmsMessage message) async {
    //Handle background message
    print('Message incoming: ${message.body}');
    if (message.body!.length > 20) {
      final response = await MessageController.analyzeSingle(message.body!);
      if (response == -1) {
        return;
      }

      if (response > THREASHOLD) {
        alertPhishing();
      }
    }
  }

  void analyzeCall() async {
    try {
      final callLog = await CallController.fetchLastCall();
      print('Incoming call from: ${callLog.number}');
      final datetime = DateTime.fromMillisecondsSinceEpoch(callLog.timestamp!)
          .toIso8601String();
      final result = await CallController.analyze(callLog.number!, datetime);
      if (result > THREASHOLD) {
        alertPhishing();
      }
    } catch (e) {
      print("Error: $e");
    }
  }

  static void alertPhishing() {
    final FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
        FlutterLocalNotificationsPlugin();
    flutterLocalNotificationsPlugin.show(
      888,
      notificationTitle,
      'Voice Phishing Detected!!!',
      const NotificationDetails(
        android: AndroidNotificationDetails(
          notificationTitle,
          'Voice Phishing Detected!!!',
          icon: 'ic_bg_service_small',
          color: Colors.red,
          ongoing: true,
        ),
      ),
    );
  }

  Future<void> _initBackService() async {
    const AndroidNotificationChannel channel = AndroidNotificationChannel(
      notificationChannelId, // id
      notificationTitle, // title
      description: 'Detecting Incoming voice phishing', // description
      importance: Importance.high, // importance must be at low or higher level
    );

    final FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
        FlutterLocalNotificationsPlugin();

    await flutterLocalNotificationsPlugin
        .resolvePlatformSpecificImplementation<
            AndroidFlutterLocalNotificationsPlugin>()
        ?.createNotificationChannel(channel);

    await service.configure(
      androidConfiguration: AndroidConfiguration(
        // this will be executed when app is in foreground or background in separated isolate
        onStart: BackgroundController.onStart,

        // auto start service
        autoStart: true,
        isForegroundMode: true,

        notificationChannelId: notificationChannelId,
        initialNotificationTitle: notificationTitle,
        initialNotificationContent: 'Detecting Incoming voice phishing',
        foregroundServiceNotificationId: notificationId,
      ),
      iosConfiguration: IosConfiguration(
        // auto start service
        autoStart: true,

        // this will be executed when app is in foreground in separated isolate
        onForeground: BackgroundController.onStart,

        // you have to enable background fetch capability on xcode project
        onBackground: onIosBackground,
      ),
    );
  }

  @pragma('vm:entry-point')
  Future<bool> onIosBackground(ServiceInstance service) async {
    return true;
  }

  @pragma('vm:entry-point')
  static void onStart(ServiceInstance service) async {
    // Only available for flutter 3.0.0 and later
    DartPluginRegistrant.ensureInitialized();

    // For flutter prior to version 3.0.0
    // We have to register the plugin manually

    /// OPTIONAL when use custom notification
    if (service is AndroidServiceInstance) {
      service.on('setAsForeground').listen((event) {
        service.setAsForegroundService();
      });

      service.on('setAsBackground').listen((event) {
        service.setAsBackgroundService();
      });
    }

    service.on('stopService').listen((event) {
      service.stopSelf();
    });
  }
}
