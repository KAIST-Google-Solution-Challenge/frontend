import 'package:flutter/material.dart';
import 'package:the_voice/controller/background_controller.dart';
import 'package:the_voice/controller/file_controller.dart';

enum Language { english, korean }

class SettingModel extends ChangeNotifier {
  final BackgroundController backgroundController;
  final FileController fileController = FileController();

  late String emergencyContact;
  late bool autoAnalysis;
  late Brightness brightness;
  late Language language;

  SettingModel({required this.backgroundController});

  init(String fileString) {
    List<String> fileList = fileString.split(' ');

    emergencyContact = fileList[0];
    autoAnalysis = fileList[1] == 'false' ? false : true;
    brightness = fileList[2] == 'light' ? Brightness.light : Brightness.dark;
    language = fileList[3] == 'english' ? Language.english : Language.korean;
  }

  changeEmergencyContact(String emergencyContact) {
    this.emergencyContact = emergencyContact;

    notifyListeners();

    List<String> fileList = fileController.fileReadAsStringSync().split(' ');
    fileList[0] = emergencyContact;
    fileController.fileWriteAsStringSync(fileList.join(' '));
  }

  changeAutoAnalysis() async {
    autoAnalysis = !autoAnalysis;

    if (autoAnalysis) {
      await backgroundController.service.startService();
    } else {
      backgroundController.service.invoke('stopService');
    }

    notifyListeners();

    List<String> fileList = fileController.fileReadAsStringSync().split(' ');
    fileList[1] = autoAnalysis.toString();
    fileController.fileWriteAsStringSync(fileList.join(' '));
  }

  changeBrightness() {
    brightness == Brightness.light
        ? brightness = Brightness.dark
        : brightness = Brightness.light;
    notifyListeners();

    List<String> fileList = fileController.fileReadAsStringSync().split(' ');
    fileList[2] = brightness == Brightness.light ? 'light' : 'dark';
    fileController.fileWriteAsStringSync(fileList.join(' '));
  }

  changeLanguage() {
    language == Language.english
        ? language = Language.korean
        : language = Language.english;
    notifyListeners();

    List<String> fileList = fileController.fileReadAsStringSync().split(' ');
    fileList[3] = language == Language.english ? 'english' : 'korean';
    fileController.fileWriteAsStringSync(fileList.join(' '));
  }
}
