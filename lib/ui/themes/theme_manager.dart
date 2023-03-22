import 'package:flutter/material.dart';

import '../../businessLogic/shared_preferences/theme_mode_preference.dart';

class ThemeManager extends ChangeNotifier {
  ThemeModePreference themePref = ThemeModePreference();
  ThemeMode _themeMode = ThemeMode.light;
  ThemeMode get themeMode => _themeMode;

  toggleTheme (bool isDark) {
    _themeMode = isDark? ThemeMode.dark: ThemeMode.light;
    themePref.setTheme(isDark?0:1);
    notifyListeners();
  }
}