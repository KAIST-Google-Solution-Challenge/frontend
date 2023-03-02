import 'package:flutter_sms_inbox/flutter_sms_inbox.dart';
import 'package:get/get.dart';
import 'package:permission_handler/permission_handler.dart';

class MessageController extends GetxController {
  final SmsQuery query = SmsQuery();

  final _messageLogs = <SmsMessage>[].obs;

  List<SmsMessage> get getMessages => _messageLogs.value;

  void fetchMessages() async {
    if (await Permission.sms.request().isGranted) {
      final messages = await query.getAllSms;
      _messageLogs.value = messages;
    }
  }

  void clearMessages() {
    _messageLogs.value = [];
  }
}
