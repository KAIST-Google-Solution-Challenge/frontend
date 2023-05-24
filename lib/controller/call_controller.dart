import 'dart:io';
import 'package:call_log/call_log.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dio/dio.dart';
import 'package:the_voice/controller/contact_controller.dart';
import 'package:the_voice/util/constant.dart';

class CallController {
  static int _loadedIndex = 0;
  static bool _isLoading = false;

  static List<CallLogEntry> _callLogEntries = [];

  // ignore: prefer_final_fields
  static List<CallLogEntry> _calls = [];
  static List<CallLogEntry> get calls {
    if (_calls.isEmpty) loadCalls();
    return _calls;
  }

  static Future<void> fetchCalls() async {
    _callLogEntries = (await CallLog.get())
        .where(
          (call) =>
              call.callType == CallType.incoming ||
              call.callType == CallType.outgoing,
        )
        .toList()
      ..sort((a, b) => (b.timestamp!).compareTo(a.timestamp!));

    for (CallLogEntry callLogEntry in _callLogEntries) {
      callLogEntry.name = ContactController.getName(callLogEntry.number!);
    }
  }

  static void loadCalls() {
    if (!_isLoading) {
      _isLoading = true;
      if (_loadedIndex + 10 < _callLogEntries.length) {
        _calls.addAll(_callLogEntries.sublist(_loadedIndex, _loadedIndex + 10));
        _loadedIndex += 10;
      } else {
        _calls.addAll(
            _callLogEntries.sublist(_loadedIndex, _callLogEntries.length));
        _loadedIndex = _callLogEntries.length;
      }
      _isLoading = false;
    }
  }

  static Future<CallLogEntry> fetchLastCall() async {
    List<CallLogEntry> lastCallLogs = (await CallLog.query(
            dateFrom: DateTime.now()
                .subtract(const Duration(hours: 1))
                .millisecondsSinceEpoch))
        .where(
          (call) =>
              call.callType == CallType.incoming ||
              call.callType == CallType.outgoing,
        )
        .toList()
      ..sort((a, b) => (b.timestamp!).compareTo(a.timestamp!));

    CallLogEntry lastCallLog = lastCallLogs.first;
    lastCallLog.name = ContactController.getName(lastCallLog.number!);

    return lastCallLog;
  }

  static Future<String> getFilePath(CallLogEntry callLogEntry) async {
    String target =
        callLogEntry.name! != '' ? callLogEntry.name! : callLogEntry.number!;
    DateTime dateTime =
        DateTime.fromMillisecondsSinceEpoch(callLogEntry.timestamp!);
    String fileName = '';

    String dt;
    String date;
    String time;

    for (int i = 0; i < 100; i++) {
      dateTime = dateTime.add(const Duration(seconds: 1));
      dt = dateTime.toIso8601String();
      date = dt.substring(2, 4) + dt.substring(5, 7) + dt.substring(8, 10);
      time = dt.substring(11, 13) + dt.substring(14, 16) + dt.substring(17, 19);

      String fileKor =
          "${Directory(CALLDIR).path}/${'통화 녹음 ${target}_${date}_$time.m4a'}";
      String fileEng =
          "${Directory(CALLDIR).path}/${'Call recording ${target}_${date}_$time.m4a'}";
      String fileKorOld =
          "${Directory(CALLDIROLD).path}/${'통화 녹음 ${target}_${date}_$time.m4a'}";
      String fileEngOld =
          "${Directory(CALLDIROLD).path}/${'Call recording ${target}_${date}_$time.m4a'}";

      if (File(fileKor).existsSync()) {
        fileName = fileKor;
      } else if (File(fileEng).existsSync()) {
        fileName = fileEng;
      } else if (File(fileKorOld).existsSync()) {
        fileName = fileKorOld;
      } else if (File(fileEngOld).existsSync()) {
        fileName = fileEng;
      }

      if (fileName != '') {
        break;
      }
    }

    return fileName;
  }

  static Future<dynamic> analyzeCall(CallLogEntry callLogEntry) async {
    FirebaseFirestore firebaseFirestore = FirebaseFirestore.instance;
    Dio dio = Dio();
    dio.options.baseUrl = BASEURL;

    final String fileName = await getFilePath(callLogEntry);
    if (fileName == '') return {'statusCode': ERROR_NOFILE};

    try {
      final response = await dio.post(
        '/model',
        options: Options(headers: {'ContentType': 'audio/mp4'}),
        data: FormData.fromMap(
          {'file': await MultipartFile.fromFile(fileName)},
        ),
      );

      if (response.statusCode == 200) {
        firebaseFirestore.collection('phishing_probability').add(
          {
            'number': callLogEntry.number!,
            'probability': response.data['probability'],
            'timestamp':
                DateTime.fromMillisecondsSinceEpoch(callLogEntry.timestamp!)
                    .toIso8601String(),
          },
        );

        return {
          'statusCode': response.statusCode,
          'probability': double.parse(response.data['probability']),
          'tokens': response.data['tokens'],
        };
      } else {
        return {'statusCode': ERROR_SERVER};
      }
    } catch (e) {
      return {'statusCode': ERROR_CLIENT};
    }
  }
}
