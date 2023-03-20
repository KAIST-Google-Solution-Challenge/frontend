import 'dart:io';
import 'package:call_log/call_log.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dio/dio.dart' as d;
import 'package:permission_handler/permission_handler.dart';
import 'package:the_voice/controller/contact_controller.dart';
import 'package:the_voice/util/constant.dart';

class CallController {
  static Future<List<CallLogEntry>> fetchCalls() async {
    final callLog = await CallLog.get();
    List<CallLogEntry> callLogEntryList = callLog.toList();

    ContactController contactController = ContactController();
    print("(getFilePath) check0");
    await contactController.init();
    print("(getFilePath) check1");

    for (CallLogEntry callLogEntry in callLogEntryList) {
      if (callLogEntry.number![0] == '+') {
        callLogEntry.number = callLogEntry.number!.substring(1);
      } else if (callLogEntry.number!.length < 4) {
        //
      } else if (callLogEntry.number![3] == '-' &&
          callLogEntry.number![8] == '-') {
        callLogEntry.number = callLogEntry.number!.substring(0, 3) +
            callLogEntry.number!.substring(4, 8) +
            callLogEntry.number!.substring(9, 13);
      }

      callLogEntry.number = contactController.getName(callLogEntry.number!);
    }

    return callLogEntryList;
  }

  static Future<CallLogEntry> fetchLastCall() async {
    var now = DateTime.now();
    int from = now.subtract(const Duration(days: 1)).millisecondsSinceEpoch;
    final lastCallLog =
        await CallLog.query(dateFrom: from, type: CallType.incoming);
    if (lastCallLog.isEmpty) {
      throw Exception('No calls found');
    }
    return lastCallLog.first;
  }

  static Future<String> getFilePath(String number, String datetime) async {
    Directory directory = Directory('/storage/emulated/0/Recordings/Call');

    String fileName = '';

    ContactController contactController = ContactController();
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
      String fileKor =
          "${directory.path}/${'통화 녹음 ${name == '' ? number : name}_${date}_$time.m4a'}";
      String fileEng =
          "${directory.path}/${'Call recording ${name == '' ? number : name}_${date}_$time.m4a'}";
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

  static Future<double> analyze(String number, String datetime) async {
    FirebaseFirestore firebaseFirestore = FirebaseFirestore.instance;
    final dio = d.Dio();
    dio.options.baseUrl = BASEURL;

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

    try {
      var storageStatus = await Permission.storage.status;
      if (!storageStatus.isGranted) {
        await Permission.storage.request();
      }

      var audioStatus = await Permission.manageExternalStorage.status;
      if (!audioStatus.isGranted) {
        await Permission.manageExternalStorage.request();
      }

      final String fileName = await getFilePath(number, datetime);

      if (fileName == '') return -1.0;

      var formData = d.FormData.fromMap(
        {
          'file': await d.MultipartFile.fromFile(
            fileName,
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
        return -response.statusCode!.toDouble();
      }
    } catch (e) {
      return -2.0;
    }
  }
}
