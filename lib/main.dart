import 'package:etouch/businessLogic/providers/navbar-add-btn-manager.dart';
import 'package:etouch/ui/screens/home-screen.dart';
import 'package:etouch/ui/screens/splash-screen.dart';
import 'package:etouch/ui/themes/theme_manager.dart';
import 'package:etouch/ui/themes/themes.dart';
import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:provider/provider.dart';

import 'businessLogic/providers/home-screens-manager.dart';

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
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => _themeManager),
        ChangeNotifierProvider(create: (_) => NavBarBtnsProvider()),
        ChangeNotifierProvider(create: (_) => HomePagesSwitcher()),
      ],
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
            home: HomePageScreen(),
          );
        },
      ),
    );
  }
}

AppLocalizations appTxt(BuildContext context) {
  return AppLocalizations.of(context)!;
}

ThemeData appTheme(BuildContext context) {
  return Theme.of(context);
}

TextTheme txtTheme(BuildContext context) {
  return Theme.of(context).textTheme;
}

//on switch clicked: themeManager.toggleTheme(on|off)
//switch state: _themeManager.themeMode == ThemeMode.dark
