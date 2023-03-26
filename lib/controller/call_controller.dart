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
    var callLogs = (await CallLog.get())
        .where(
          (call) =>
              call.callType == CallType.incoming ||
              call.callType == CallType.outgoing,
        )
        .toList()
      ..sort((a, b) => b.timestamp!.compareTo(a.timestamp!));

    if (callLogs.length > 60) {
      callLogs = callLogs.sublist(0, 60);
    }

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
    final callLog =
        (await CallLog.query(dateFrom: from, type: CallType.incoming)).first;

    final contacts = await ContactsService.getContacts(withThumbnails: false);
    callLog.number!.replaceAll('+', '');
    callLog.number!.replaceAll('-', '');
    callLog.number = ContactController.getName(contacts, callLog.number!);

    return callLog;
  }

  // datetime ISO8601 2023-03-26T06:49:36+00:00
  static Future<String> getFilePath(String number, String datetime) async {
    String fileName = '';

    final contacts = await ContactsService.getContacts(withThumbnails: false);
    String name = ContactController.getName(contacts, number);
    print("name: $name");
    late String date;
    late String time;

    Directory directory = Directory(CALLDIR);
    Directory oldDirectory = Directory(CALLDIROLD);

    for (var i = 0; i < 10; i++) {
      // Need to be optimized by pararmetering Datetime, not ISO8601String.
      datetime = DateTime(
        2000 + int.parse(datetime.substring(2, 4)),
        int.parse(datetime.substring(5, 7)),
        int.parse(datetime.substring(8, 10)),
        int.parse(datetime.substring(11, 13)),
        int.parse(datetime.substring(14, 16)),
        int.parse(datetime.substring(17, 19)),
      ).add(Duration(seconds: i)).toIso8601String();

      date = datetime.substring(2, 4) +
          datetime.substring(5, 7) +
          datetime.substring(8, 10);
      print("date: $date");
      time = datetime.substring(11, 13) +
          datetime.substring(14, 16) +
          datetime.substring(17, 19);
      print("time: $time");

      String fileKor =
          "${directory.path}/${'통화 녹음 ${name == '' ? number : name}_${date}_$time.m4a'}";
      String fileEng =
          "${directory.path}/${'Call recording ${name == '' ? number : name}_${date}_$time.m4a'}";
      String fileKorOld =
          "${oldDirectory.path}/${'통화 녹음 ${name == '' ? number : name}_${date}_$time.m4a'}";
      String fileEngOld =
          "${oldDirectory.path}/${'Call recording ${name == '' ? number : name}_${date}_$time.m4a'}";

      if (File(fileKor).existsSync()) {
        fileName = fileKor;
        break;
      }
      if (File(fileEng).existsSync()) {
        fileName = fileEng;
        break;
      }
      if (File(fileKorOld).existsSync()) {
        fileName = fileKorOld;
        break;
      }
      if (File(fileEngOld).existsSync()) {
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
      print('No contact permission granted');
      await Permission.contacts.request();
    }

    var storageStatus = await Permission.storage.status;
    if (!storageStatus.isGranted) {
      print('No storage permission granted');
      await Permission.storage.request();
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
