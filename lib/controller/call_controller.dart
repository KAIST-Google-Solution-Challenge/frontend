import 'dart:io';
import 'package:call_log/call_log.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:contacts_service/contacts_service.dart';
import 'package:dio/dio.dart' as d;
import 'package:permission_handler/permission_handler.dart';
import 'package:the_voice/controller/contact_controller.dart';
import 'package:the_voice/util/constant.dart';

class CallController {
  static Future<List<CallLogEntry>> fetchCalls() async {
    var contactsStatus = await Permission.contacts.status;
    if (!contactsStatus.isGranted) {
      await Permission.contacts.request();
    }

    var phoneStatus = await Permission.phone.status;
    if (!phoneStatus.isGranted) {
      await Permission.phone.request();
    }

    if (!contactsStatus.isGranted || !phoneStatus.isGranted) {
      return [];
    }

    // Fetch call logs from device
    var callLogs = (await CallLog.get()).toList();
    callLogs = callLogs.sublist(0, 60);
    final contacts = await ContactsService.getContacts(withThumbnails: false);

    for (var callLogEntry in callLogs) {
      // number of call log is undefined
      if (callLogEntry.number == null) {
        continue;
      }

      callLogEntry.number!.replaceAll('+', '');
      callLogEntry.number!.replaceAll('-', '');

      // If number registered in contacts, fetch the display name
      callLogEntry.number =
          ContactController.getName(contacts, callLogEntry.number!);
    }
    return callLogs;
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
    Directory directory = Directory(EngDir);

    String fileName = '';

    final contacts = await ContactsService.getContacts(withThumbnails: false);
    String name = ContactController.getName(contacts, number);
    print("name: $name");
    String date = datetime.substring(2, 4) +
        datetime.substring(5, 7) +
        datetime.substring(8, 10);
    print("date: $date");
    String time = datetime.substring(11, 13) +
        datetime.substring(14, 16) +
        datetime.substring(17, 19);
    print("(getFilePath) initial time: $time");

    for (var i = 0; i < 1000; i++) {
      time = (int.parse(time) + 1).toString();
      while (time.length < 6) {
        time = '0$time';
      }
      String fileKor =
          "${directory.path}/${'통화 녹음 ${name == '' ? number : name}_${date}_$time.m4a'}";
      String fileEng =
          "${directory.path}/${'Call recording ${name == '' ? number : name}_${date}_$time.m4a'}";
      if (File(fileKor).existsSync()) {
        fileName = fileKor;
        break;
      }
      if (File(fileEng).existsSync()) {
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
      final String fileName = await getFilePath(number, datetime);
      if (fileName == '') return -1.0;

      var formData = d.FormData.fromMap(
        {
          'file': await d.MultipartFile.fromFile(
            fileName,
          ),
        },
      );

      print("(analyze) requesting...");

      final response = await dio.post(
        '/model',
        options: d.Options(
          headers: {'ContentType': 'audio/mp4'},
        ),
        data: formData,
      );

      if (response.statusCode == 200) {
        print("(analyze) success!");
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
        throw Exception('Request failed');
      }
    } catch (e) {
      return -2.0;
    }
  }
}
