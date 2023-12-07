import 'package:etouch/api/services.dart';
import 'package:etouch/businessLogic/providers/navigation_bottom_manager.dart';
import 'package:etouch/ui/screens/login_screen.dart';
import 'package:etouch/ui/screens/splash_screen.dart';
import 'package:etouch/ui/themes/theme_manager.dart';
import 'package:etouch/ui/themes/themes.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:get_it/get_it.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'businessLogic/providers/create_doc_manager.dart';

//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
void setupServiceLocator() {
  GetIt.instance.registerLazySingleton(() => MyApiServices());
}

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  setupServiceLocator();
  await Firebase.initializeApp();
  FirebaseDatabase.instance
      .ref()
      .child('base_url')
      .get()
      .then((data) => MyApiServices.baseUrl = data.value as String);
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
        ChangeNotifierProvider(create: (_) => BottomNavigationProvider()),
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
            home: const SplashScreen(),
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

String getZFormattedDate(DateTime when) {
  return DateFormat("yyyy-MM-ddTHH:mm:ss'Z'").format(when);
}

String getSpacedFormattedDate(DateTime when) {
  return DateFormat("yyyy-MM-dd hh:mm:ss").format(when);
}

void logoutUser(BuildContext context, {bool why = true}) {
  if (why) {
    Navigator.of(context).pushAndRemoveUntil(
        MaterialPageRoute(builder: (ctx) => const LoginScreen()),
        (route) => false);
  }
}
