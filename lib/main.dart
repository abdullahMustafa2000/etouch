import 'package:etouch/api/services.dart';
import 'package:etouch/businessLogic/providers/dashboard_manager.dart';
import 'package:etouch/ui/fake_landing.dart';
import 'package:etouch/ui/screens/home_screen.dart';
import 'package:etouch/ui/screens/login_screen.dart';
import 'package:etouch/ui/themes/theme_manager.dart';
import 'package:etouch/ui/themes/themes.dart';
import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:get_it/get_it.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'businessLogic/providers/e_invoice_doc_manager.dart';


void setupServiceLocator() {
  GetIt.instance.registerLazySingleton(() => MyApiServices());
}
void main() {
  setupServiceLocator();
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
        ChangeNotifierProvider(create: (_) => EInvoiceDocProvider()),
        ChangeNotifierProvider(create: (_) => DashboardProvider()),
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
            home: FakeLanding(),
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

String getFormattedDate(DateTime when) {
  return DateFormat('yyyy-MM-ddTHH:mm:ssZ').format(when);
}