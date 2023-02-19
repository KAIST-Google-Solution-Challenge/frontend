import 'package:flutter/material.dart';

enum Language {
  english,
  korean,
}

class SettingModel extends ChangeNotifier {
  Brightness brightness = Brightness.light;
  Language language = Language.english;

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
