import 'dart:io';

import 'package:call_log/call_log.dart';
import 'package:dio/dio.dart' as d;
import 'package:permission_handler/permission_handler.dart';

class CallController {
  late d.Dio dio;

  void init() {
    dio = d.Dio();
    dio.options.baseUrl = 'http://10.0.2.2:3000';
    // dio.options.baseUrl = 'http://localhost:3000';
  }

  Future<List<CallLogEntry>> fetchCalls() async {
    final callLogs = await CallLog.get();
    return callLogs.toList();
  }

  String _getFilePath(String fileName) {
    // const directory = '/root/Voice Recorder';
    // var directory = await getDownloadsDirectory();
    Directory directory = Directory('/storage/emulated/0/Download');
    return "${directory.path}/$fileName";
  }

  //! Not Tested
  Future<void> analyze(String fileName) async {
    try {
      var status = await Permission.storage.status;
      if (!status.isGranted) {
        await Permission.storage.request();
      }
      var formDate = d.FormData.fromMap(
        {
          'file': await d.MultipartFile.fromFile(_getFilePath(fileName)),
        },
      );

      final response = await dio.post('/model',
          options: d.Options(headers: {'ContentType': 'audio/mp4'}),
          data: formDate);
      if (response.statusCode == 200) {
        print('File uploaded successfully');
      } else {
        print('File upload failed');
      }
    } catch (e) {
      print(e);
    }
  }
}
