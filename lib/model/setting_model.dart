import 'package:flutter/material.dart';
import 'package:the_voice/controller/background_controller.dart';

enum Language { english, korean }

class SettingModel extends ChangeNotifier {
  final BackgroundController backgroundController;

  SettingModel({required this.backgroundController});

  String emergencyContact = '';
  bool autoAnalysis = false;
  Brightness brightness = Brightness.light;
  Language language = Language.english;

  changeEmergencyContact(String emergencyContact) async {
    this.emergencyContact = emergencyContact;

    notifyListeners();
  }

  changeAutoAnalysis() async {
    autoAnalysis = !autoAnalysis;

    if (autoAnalysis) {
      await backgroundController.service.startService();
    } else {
      backgroundController.service.invoke('stopService');
    }

    notifyListeners();
  }

  changeBrightness() {
    brightness == Brightness.light
        ? brightness = Brightness.dark
        : brightness = Brightness.light;
    notifyListeners();
  }

  changeLanguage() {
    language == Language.english
        ? language = Language.korean
        : language = Language.english;
    notifyListeners();
  }
}
