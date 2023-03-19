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
    // dio.options.baseUrl = 'https://dccf-110-76-108-201.jp.ngrok.io/';
    dio.options.baseUrl = 'http://35.216.49.87:3000/';
  }

  Future<List<CallLogEntry>> fetchCalls() async {
    final callLogs = await CallLog.get();
    return callLogs.toList();
  }

  Future<String> _getFilePath(String number, String datetime) async {
    print("getFilePath called!");
    Directory directory = Directory('/storage/emulated/0/Recordings/Call');

    ContactController contactController = ContactController();
    print("(getFilePath) check0");
    await contactController.init();
    print("(getFilePath) check1");

    String fileName = '';
    String name = contactController.getName(number);
    print("name: $name");
    String date = datetime.substring(2, 4) +
        datetime.substring(5, 7) +
        datetime.substring(8, 10);
    print("date: $date");
    String time = datetime.substring(11, 13) +
        datetime.substring(14, 16) +
        datetime.substring(17, 19);
    print("(getFilePath) check1!");
    print("(getFilePath) initial time: $time");

    for (var i = 0; i < 1000; i++) {
      time = (int.parse(time) + 1).toString();
      String fileKor = "${directory.path}/${'통화 녹음 ${name == '' ? number : name}_${date}_$time.m4a'}";
      String fileEng = "${directory.path}/${'Call recording ${name == '' ? number : name}_${date}_$time.m4a'}";
      print("(getFilePath) file: $fileKor");
      if (File(fileKor).existsSync()) {
        print("exists!");
        fileName = fileKor;
        break;
      }
      print("(getFilePath) file: $fileEng");
      if (File(fileEng).existsSync()) {
        print("exists!");
        fileName = fileEng;
        break;
      }
    }

    print("(getFilePath) fileName : $fileName");

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

      print("(analyze) requesting...");

      final response = await dio.post(
        '/model',
        options: d.Options(
          headers: {'ContentType': 'audio/mp4'},
        ),
        data: formData,
      );

      if (response.statusCode == 200) {
        print("(analyze) good!");
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
