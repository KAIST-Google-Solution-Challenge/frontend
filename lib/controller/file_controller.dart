import 'dart:io';
import 'package:the_voice/util/constant.dart';

class FileController {
  static String filepath =
      '${Directory(DOCUMENTSDIR).path}/theVoice/settingModel.txt';

  static Future<void> init() async {
    if (!await fileExists()) {
      await fileInit();
    } else if (fileReadAsStringSync().split(' ').length != 5) {
      await fileDelete();
      await fileInit();
    }
  }

  static Future<bool> fileExists() async {
    return await File(filepath).exists();
  }

  static Future<void> fileDelete() async {
    await File(filepath).delete();
  }

  static Future<void> fileInit() async {
    await File(filepath).create(recursive: true);
    await File(filepath).writeAsString(' false false light english');
  }

  static String fileReadAsStringSync() {
    return File(filepath).readAsStringSync();
  }

  static void fileWriteAsStringSync(String fileString) {
    File(filepath).writeAsStringSync(fileString);
  }
}
