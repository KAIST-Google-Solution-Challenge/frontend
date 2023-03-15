import 'dart:io';
import 'package:call_log/call_log.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dio/dio.dart' as d;
import 'package:permission_handler/permission_handler.dart';
import 'package:the_voice/controller/contact_controller.dart';

class CallController {
  FirebaseFirestore firebaseFirestore = FirebaseFirestore.instance;
  late d.Dio dio;

  void init() {
    dio = d.Dio();
    // dio.options.baseUrl = 'http://10.0.2.2:3000';
    // dio.options.baseUrl = 'http://localhost:3000';
    dio.options.baseUrl = 'https://dccf-110-76-108-201.jp.ngrok.io/';
  }

  Future<List<CallLogEntry>> fetchCalls() async {
    final callLogs = await CallLog.get();
    return callLogs.toList();
  }

  Future<String> _getFilePath(String number, String datetime) async {
    Directory directory = Directory('/storage/emulated/0/Recordings/Call');

    ContactController contactController = ContactController();
    await contactController.init();

    String fileName = '';
    String name = contactController.getName(number);
    String date = datetime.substring(2, 4) +
        datetime.substring(5, 7) +
        datetime.substring(8, 10);
    String time = datetime.substring(11, 13) +
        datetime.substring(14, 16) +
        datetime.substring(17, 19);

    for (var i = 0; i < 10; i++) {
      time = (int.parse(time) + 1).toString();
      String file =
          "${directory.path}/${'통화 녹음 ${name == '' ? number : name}_${date}_$time.m4a'}";
      if (File(file).existsSync()) {
        fileName = file;
        break;
      }
    }

    return fileName;
  }

  Future<double> analyze(String number, String datetime) async {
    try {
      var contactsStatus = await Permission.contacts.status;
      if (!contactsStatus.isGranted) {
        await Permission.contacts.request();
      }

      var storageStatus = await Permission.storage.status;
      if (!storageStatus.isGranted) {
        await Permission.storage.request();
      }

      var audioStatus = await Permission.manageExternalStorage.status;
      if (!audioStatus.isGranted) {
        await Permission.manageExternalStorage.request();
      }

      var formData = d.FormData.fromMap(
        {
          'file': await d.MultipartFile.fromFile(
            await _getFilePath(number, datetime),
          ),
        },
      );

      // var formData = d.FormData.fromMap(
      //   {
      //     'file': await d.MultipartFile.fromFile(
      //       '/storage/emulated/0/Recordings/Call/sample.m4a',
      //     )
      //   },
      // );

      final response = await dio.post(
        '/model',
        options: d.Options(
          headers: {'ContentType': 'audio/mp4'},
        ),
        data: formData,
      );

      if (response.statusCode == 200) {
        final Map<String, dynamic> document = {
          'number': number,
          'probability': response.data.toString().substring(0, 4),
          'timestamp':
              Timestamp.now().toDate().toIso8601String().substring(0, 10),
        };

        firebaseFirestore.collection('phishing_probability').add(document);

        return double.parse(
          response.data.toString().substring(0, 4),
        );
      } else {
        return 0.0;
      }
    } catch (e) {
      return 0.0;
    }
  }
}
