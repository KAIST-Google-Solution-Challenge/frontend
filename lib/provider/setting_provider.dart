import 'package:flutter/material.dart';
import 'package:the_voice/controller/background_controller.dart';
import 'package:the_voice/controller/file_controller.dart';

enum Language { english, korean }

class SettingProvider extends ChangeNotifier {
  late String emergencyContact;
  late bool autoAnalysis;
  late bool largeFont;
  late Brightness brightness;
  late Language language;

  void init() {
    List<String> fileList = FileController.fileReadAsStringSync().split(' ');

    emergencyContact = fileList[0];
    autoAnalysis = fileList[1] == 'false' ? false : true;
    largeFont = fileList[2] == 'false' ? false : true;
    brightness = fileList[3] == 'light' ? Brightness.light : Brightness.dark;
    language = fileList[4] == 'english' ? Language.english : Language.korean;
  }

  void changeEmergencyContact(String emergencyContact) {
    this.emergencyContact = emergencyContact;

    notifyListeners();

    List<String> fileList = FileController.fileReadAsStringSync().split(' ');
    fileList[0] = emergencyContact;
    FileController.fileWriteAsStringSync(fileList.join(' '));
  }

  Future<void> changeAutoAnalysis() async {
    autoAnalysis = !autoAnalysis;

    if (autoAnalysis) {
      BackgroundController.service.startService();
    } else {
      BackgroundController.service.invoke('stopService');
    }

    notifyListeners();

    List<String> fileList = FileController.fileReadAsStringSync().split(' ');
    fileList[1] = autoAnalysis.toString();
    FileController.fileWriteAsStringSync(fileList.join(' '));
  }

  void changeLargeFont() {
    largeFont = !largeFont;
    notifyListeners();

    List<String> fileList = FileController.fileReadAsStringSync().split(' ');
    fileList[2] = largeFont.toString();
    FileController.fileWriteAsStringSync(fileList.join(' '));
  }

  void changeBrightness() {
    brightness == Brightness.light
        ? brightness = Brightness.dark
        : brightness = Brightness.light;
    notifyListeners();

    List<String> fileList = FileController.fileReadAsStringSync().split(' ');
    fileList[3] = brightness == Brightness.light ? 'light' : 'dark';
    FileController.fileWriteAsStringSync(fileList.join(' '));
  }

  void changeLanguage() {
    language == Language.english
        ? language = Language.korean
        : language = Language.english;
    notifyListeners();

    List<String> fileList = FileController.fileReadAsStringSync().split(' ');
    fileList[4] = language == Language.english ? 'english' : 'korean';
    FileController.fileWriteAsStringSync(fileList.join(' '));
  }
}
