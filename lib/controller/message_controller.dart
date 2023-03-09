import 'package:flutter_sms_inbox/flutter_sms_inbox.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:dio/dio.dart' as d;

class MessageController {
  late d.Dio dio;

  final SmsQuery query = SmsQuery();

  @override
  void init() {
    dio = d.Dio();
    dio.options.baseUrl = 'http://10.0.2.2:3000';
    // dio.options.baseUrl = 'http://localhost:3000';
  }

  Future<List<SmsMessage>> fetchMessages() async {
    if (!await Permission.sms.request().isGranted) {
      return [];
    }
    final messages = await query.getAllSms;
    return messages;
  }

  Future<void> analyze(List<String> messages) async {
    try {
      final response = await dio.post('/model/messages/', data: {
        messages: messages,
      });
      if (response.statusCode == 200) {
        print('Messages analyzed successfully');
      } else {
        print('Messages not analyzed');
      }
    } catch (e) {}
  }
}
