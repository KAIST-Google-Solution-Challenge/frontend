import 'dart:io';
import 'package:the_voice/util/constant.dart';

class FileController {
  final String filepath =
      '${Directory(DOCUMENTSDIR).path}/theVoice/settingModel.txt';

  Future<bool> fileExists() async {
    return await File(filepath).exists();
  }

  Future<void> fileInit() async {
    await File(filepath).create(recursive: true);
    await File(filepath).writeAsString(' false light english');
  }

  String fileReadAsStringSync() {
    return File(filepath).readAsStringSync();
  }

  void fileWriteAsStringSync(String fileString) {
    File(filepath).writeAsStringSync(fileString);
  }
}
