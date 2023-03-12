import 'dart:io';

import 'package:call_log/call_log.dart';
import 'package:dio/dio.dart' as d;
import 'package:permission_handler/permission_handler.dart';

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
  Future<double> analyze(String fileName) async {
    try {
      var status = await Permission.storage.status;
      if (!status.isGranted) {
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
