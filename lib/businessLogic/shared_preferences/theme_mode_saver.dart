import 'package:shared_preferences/shared_preferences.dart';

class ThemeModePreference {
  static const THEME_STATUS = 'THEME_STATUS';

  // 0 : dark;
  // 1 : light;
  void setTheme(int theme) async {
    SharedPreferences preferences = await SharedPreferences.getInstance();
    preferences.setInt(THEME_STATUS, theme);
  }

  Future<bool> getTheme() async {
    SharedPreferences preferences = await SharedPreferences.getInstance();
    return preferences.getInt(THEME_STATUS) == 0 ?? false;
  }
}