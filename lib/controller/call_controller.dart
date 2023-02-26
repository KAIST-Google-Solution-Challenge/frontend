import 'package:call_log/call_log.dart';
import 'package:dio/dio.dart' as DIO;
import 'package:get/get.dart';

class CallController extends GetxController {
  late DIO.Dio dio;

  final _callLogs = <CallLogEntry>[].obs;

  List<CallLogEntry> get getCallLogs => _callLogs.value;

  @override
  void onInit() {
    super.onInit();
    dio = DIO.Dio();
    dio.options.baseUrl = 'http://localhost:3000';
  }

  void fetchCallLogs() async {
    final callLogs = await CallLog.get();
    _callLogs.value = callLogs.toList();
  }

  String getFilePath(String fileName) {
    const directory = '/root/Voice Recorder';
    return "$directory/$fileName";
  }

  Future<void> uploadFile(String fileName) async {
    var formDate = DIO.FormData.fromMap({
      'file': await DIO.MultipartFile.fromFile(getFilePath(fileName)),
    });

    final response = await dio.post('/records/upload', data: formDate);
    if (response.statusCode == 200) {
      print('File uploaded successfully');
    } else {
      print('File upload failed');
    }
  }
}
