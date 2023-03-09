import 'package:flutter_sms_inbox/flutter_sms_inbox.dart';
import 'package:permission_handler/permission_handler.dart';

class MessageController {
  final SmsQuery query = SmsQuery();

  Future<List<SmsMessage>> fetchMessages() async {
    if (!await Permission.sms.request().isGranted) {
      return [];
    }
    final messages = await query.getAllSms;
    return messages;
  }
}
