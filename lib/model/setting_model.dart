import 'package:flutter/material.dart';
import 'package:the_voice/controller/background_controller.dart';

enum Language { english, korean }

class SettingModel extends ChangeNotifier {
  final BackgroundController backgroundController;

  SettingModel({required this.backgroundController});

  bool autoAnalysis = false;
  Brightness brightness = Brightness.light;
  Language language = Language.english;

  changeAutoAnalysis() async {
    autoAnalysis = !autoAnalysis;

    print(
      'is background service running? ${await backgroundController.service.isRunning()}',
    );
    if (autoAnalysis) {
      await backgroundController.service.startService();
    } else {
      backgroundController.service.invoke('stopService');
    }
    print(
      'is background service running? ${await backgroundController.service.isRunning()}',
    );

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
