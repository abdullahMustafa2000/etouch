import 'package:etouch/businessLogic/shared_preferences/theme_mode_preference.dart';
import 'package:etouch/ui/fake_landing.dart';
import 'package:etouch/ui/screens/splashscreen.dart';
import 'package:etouch/ui/themes/theme_manager.dart';
import 'package:etouch/ui/themes/themes.dart';
import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:provider/provider.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatefulWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  late ThemeManager _themeManager;
  late bool isDarkTheme = false;
  @override
  void initState() {
    super.initState();
    _themeManager = ThemeManager();
    getCurrentTheme();
  }

  void getCurrentTheme() async {
    isDarkTheme = await _themeManager.themePref.getTheme();
    _themeManager.toggleTheme(isDarkTheme);
  }

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (context) => _themeManager,
      child: Consumer<ThemeManager>(
        builder: (BuildContext context, value, Widget? child) {
          return MaterialApp(
            debugShowCheckedModeBanner: false,
            title: 'E-Touch',
            theme: isDarkTheme ? darkTheme : lightTheme,
            darkTheme: darkTheme,
            themeMode: _themeManager.themeMode,
            localizationsDelegates: AppLocalizations.localizationsDelegates,
            supportedLocales: AppLocalizations.supportedLocales,
            home: FakeLanding(),
          );
        },
      ),
    );
  }
}

//on switch clicked: themeManager.toggleTheme(on|off)
//switch state: _themeManager.themeMode == ThemeMode.dark
