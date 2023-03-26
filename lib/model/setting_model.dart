import 'package:flutter/material.dart';
import 'package:the_voice/controller/background_controller.dart';

enum Language { english, korean }

class SettingModel extends ChangeNotifier {
  final BackgroundController backgroundController;
  late String emergencyContact;
  late bool autoAnalysis;
  late Brightness brightness;
  late Language language;

  SettingModel({
    required this.backgroundController,
    required this.emergencyContact,
    required this.autoAnalysis,
    required this.brightness,
    required this.language,
  });

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
