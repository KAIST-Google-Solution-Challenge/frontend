import 'package:flutter/material.dart';

enum Language { english, korean }

class SettingModel extends ChangeNotifier {
  bool autoAnalysis = false;
  Brightness brightness = Brightness.light;
  Language language = Language.english;

  changeAutoAnalysis() {
    autoAnalysis = !autoAnalysis;
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
