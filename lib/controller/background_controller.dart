import 'dart:async';
import 'dart:ui';
import 'package:call_log/call_log.dart';
import 'package:flutter/material.dart';
import 'package:flutter_background_service/flutter_background_service.dart';
import 'package:flutter_background_service_android/flutter_background_service_android.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:phone_state/phone_state.dart';
import 'package:telephony/telephony.dart';
import 'package:the_voice/controller/call_controller.dart';
import 'package:the_voice/controller/file_controller.dart';
import 'package:the_voice/controller/message_controller.dart';
import 'package:the_voice/util/constant.dart';

class BackgroundController {
  static PhoneStateStatus status = PhoneStateStatus.NOTHING;
  static bool granted = false;

  static FlutterBackgroundService service = FlutterBackgroundService();
  static FlutterLocalNotificationsPlugin notification =
      FlutterLocalNotificationsPlugin();
  static Telephony telephony = Telephony.instance;

  static int id = 888;
  static String channelId = 'the-voice';
  static String channelName = 'The Voice';

  static void _setCallStream() {
    PhoneState.phoneStateStream.listen(
      (event) {
        if (event != null) {
          if (event == PhoneStateStatus.CALL_ENDED) {
            // Future.delayed(const Duration(seconds: 10), analyzeCall);
            analyzeCall();
          }
          status = event;
        }
      },
    );
  }

  static void _setSmsStream() {
    telephony.listenIncomingSms(
      onNewMessage: (SmsMessage message) async {
        analyzeMessage(message);
      },
      onBackgroundMessage: analyzeMessage,
    );
  }

  static Future<void> init() async {
    await _initBackService();
  }

  static Future<void> _initBackService() async {
    await notification
        .resolvePlatformSpecificImplementation<
            AndroidFlutterLocalNotificationsPlugin>()
        ?.createNotificationChannel(
          AndroidNotificationChannel(channelId, channelName),
        );

    await service.configure(
      androidConfiguration: AndroidConfiguration(
        onStart: onStart,
        autoStart: false,
        autoStartOnBoot: false,
        isForegroundMode: true,
        foregroundServiceNotificationId: id,
        notificationChannelId: channelId,
        initialNotificationTitle: 'The Voice',
        initialNotificationContent: 'Auto Analysis',
      ),
      iosConfiguration: IosConfiguration(),
    );
  }

  @pragma('vm:entry-point')
  static void onStart(ServiceInstance service) async {
    DartPluginRegistrant.ensureInitialized();

    _setCallStream();
    _setSmsStream();

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

  static void analyzeCall() async {
    CallLogEntry lastCall = await CallController.fetchLastCall();
    dynamic response = await CallController.analyzeCall(lastCall);
    if (response['statusCode'] == 200) {
      if (response['probability'] > THRESHOLD3) {
        alertPhishing(lastCall.number!, response['probability']);
      }
    }
  }

  static void analyzeMessage(SmsMessage message) async {
    if (message.body!.length > 16) {
      dynamic response = await MessageController.analyzeMessage(message);
      if (response['statusCode'] == 200) {
        if (response['probability'] > THRESHOLD3) {
          alertPhishing(message.address!, response['probability']);
        }
      }
    }
  }

  static void alertPhishing(String number, double probability) {
    notification.show(
      id,
      'The Voice',
      'Phone Scam by $number is Detected (${probability.toInt()}%)',
      NotificationDetails(
        android: AndroidNotificationDetails(
          channelId,
          channelName,
          icon: 'ic_bg_service_small',
          color: Colors.red,
        ),
      ),
    );

    telephony.sendSms(
      to: FileController.fileReadAsStringSync().split(' ')[0],
      message:
          '[The Voice] Phone Scam by $number is Detected (${probability.toInt()}%)',
    );
  }
}
