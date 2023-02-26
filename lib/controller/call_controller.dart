import 'package:call_log/call_log.dart';
import 'package:get/get.dart';

class CallController extends GetxController {
  final _callLogs = <CallLogEntry>[].obs;

  List<CallLogEntry> get getCallLogs => _callLogs.value;

  void fetchCallLogs() async {
    final callLogs = await CallLog.get();
    _callLogs.value = callLogs.toList();
  }
}
