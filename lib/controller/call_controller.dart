import 'dart:io';

import 'package:call_log/call_log.dart';
import 'package:dio/dio.dart' as d;
import 'package:get/get.dart';
import 'package:permission_handler/permission_handler.dart';

class CallController extends GetxController {
  late d.Dio dio;

  var calls = <CallLogEntry>[].obs;

  @override
  void onInit() {
    super.onInit();
    dio = d.Dio();
    dio.options.baseUrl = 'http://10.0.2.2:3000';
    // dio.options.baseUrl = 'http://localhost:3000';
  }

  void fetchCalls() async {
    calls.value = (await CallLog.get()).toList();
  }

  Future<String> getFilePath(String fileName) async {
    // const directory = '/root/Voice Recorder';
    // var directory = await getDownloadsDirectory();
    Directory directory = Directory('/storage/emulated/0/Download');
    print(directory.path);
    return "${directory.path}/$fileName";
  }

  //! Not Tested
  Future<void> convert(String fileName) async {
    try {
      var status = await Permission.storage.status;
      if (!status.isGranted) {
        await Permission.storage.request();
      }
      var formDate = d.FormData.fromMap({
        'file': await d.MultipartFile.fromFile(await getFilePath(fileName)),
      });

      final response = await dio.post('/stt',
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
