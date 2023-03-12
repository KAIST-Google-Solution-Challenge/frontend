import 'dart:io';

import 'package:call_log/call_log.dart';
import 'package:dio/dio.dart' as d;
import 'package:permission_handler/permission_handler.dart';
import 'package:the_voice/controller/contact_controller.dart';

class CallController {
  late d.Dio dio;

  void init() {
    dio = d.Dio();
    // dio.options.baseUrl = 'http://10.0.2.2:3000';
    // dio.options.baseUrl = 'http://localhost:3000';
    dio.options.baseUrl = 'http://143.248.77.70:3000';
  }

  Future<List<CallLogEntry>> fetchCalls() async {
    final callLogs = await CallLog.get();
    return callLogs.toList();
  }

  Future<String> _getFilePath(String fileName) async {
    Directory directory = Directory('/storage/emulated/0/Recordings/Call');
    return "${directory.path}/$fileName";
  }

  //! Not Tested
  Future<double> analyze(String number, String datetime) async {
    try {
      var contactsStatus = await Permission.contacts.status.isGranted;
      if (!contactsStatus) {
        await Permission.contacts.request();
      }

      ContactController contactController = ContactController();
      await contactController.init();

      String name = contactController.getName(number);
      String date = datetime.substring(2, 4) +
          datetime.substring(5, 7) +
          datetime.substring(8, 10);
      String time = datetime.substring(11, 13) +
          datetime.substring(14, 16) +
          datetime.substring(17, 19);
      String fileName =
          '통화 녹음 ${name == '' ? number : name}_${date}_${time}.m4a';

      print('[log] $fileName');

      var storageStatus = await Permission.storage.status;
      if (!storageStatus.isGranted) {
        await Permission.storage.request();
      }
      var formDate = d.FormData.fromMap(
        {
          'file': await d.MultipartFile.fromFile(await _getFilePath(fileName)),
        },
      );

      final response = await dio.post('/model',
          options: d.Options(headers: {'ContentType': 'audio/mp4'}),
          data: formDate);
      if (response.statusCode == 200) {
        print('File uploaded successfully');
        return double.parse(response.data);
      } else {
        print('File upload failed');
        return 50;
      }
    } catch (e) {
      print(e);
      return 50;
    }
  }
}
