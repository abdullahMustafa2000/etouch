import 'package:etouch/ui/constants.dart';
import 'package:flutter/material.dart';

var _level7 = 24.0;
var _level6 = 20.0;
var _level5 = 18.0;
var _level4 = 16.0;
var _level3 = 12.0;
var _level2 = 10.0;
var _level1 = 8.0;

var primaryColor = const Color.fromRGBO(20, 39, 155, 1);
var pureWhite = const Color.fromRGBO(255, 255, 255, 1);
var secondaryColor = const Color.fromRGBO(54, 153, 255, 1);
var lighterSecondaryClr = const Color.fromRGBO(186, 224, 255, 1);
var accentColor = const Color.fromRGBO(129, 66, 231, 1);
var lightAccentColor = const Color.fromRGBO(218, 200, 248, 1);
var greenCardBGClr= const Color.fromRGBO(201, 247, 245, 1);
var greenCardProgressClr = const Color.fromRGBO(159, 235, 231, 1);
var greenCardTitleClr = const Color.fromRGBO(15, 120, 115, 1);
var greenCardDataClr = const Color.fromRGBO(63, 66, 84, 1);
var lightRedCardProgressClr = const Color.fromRGBO(255, 188, 195, 1);
var lightRedCardBGClr = const Color.fromRGBO(255, 226, 229, 1);
var lightRedCardTitleClr = const Color.fromRGBO(141, 9, 23, 1);
var purpleCardProgressClr = const Color.fromRGBO(172, 132, 253, 1);
var purpleCardBGClr = const Color.fromRGBO(137, 80, 252, 1);
var closeColor = const Color.fromRGBO(244, 67, 54, 1);
var darkRedCardBGClr = const Color.fromRGBO(246, 78, 96, 1);
var darkRedCardProgressClr = const Color.fromRGBO(249, 131, 143, 1);
var loginPlaceholderLightClr = const Color.fromRGBO(0, 0, 0, .3);
var loginPlaceholderDarkClr = const Color.fromRGBO(255, 255, 255, .4);
var switchThumbColor = const Color.fromRGBO(124, 124, 124, 1);
var darkGrayColor = const Color.fromRGBO(102, 102, 102, 1);
ThemeData lightTheme = ThemeData(
  brightness: Brightness.light,
  primaryColor: primaryColor,
  primaryColorDark: pureWhite,
  inputDecorationTheme: InputDecorationTheme(
    hintStyle: TextStyle(
      color: loginPlaceholderLightClr,
    ),
    prefixIconColor: loginPlaceholderLightClr,
    suffixIconColor: loginPlaceholderLightClr,
  ),
  textTheme: getTextTheme(),
);

ThemeData darkTheme = ThemeData(
  brightness: Brightness.dark,
  primaryColor: pureWhite,
  primaryColorDark: const Color.fromRGBO(47,49,54, 1),
  inputDecorationTheme: InputDecorationTheme(
    hintStyle: TextStyle(
      color: loginPlaceholderDarkClr,
    ),
    prefixIconColor: pureWhite,
    suffixIconColor: pureWhite,
  ),
  textTheme: getTextTheme(),
);

TextTheme getTextTheme() {
  return TextTheme(
    /// extraBold 24
    displayLarge: const TextStyle(
      fontFamily: almarai,
      fontSize: 24,
      fontWeight: FontWeight.w800,
    ),

    /// bold 24
    displayMedium: TextStyle(
      fontFamily: almarai,
      fontSize: _level7,
      fontWeight: FontWeight.bold
    ),

    /// regular 20
    displaySmall: TextStyle(
      fontFamily: almarai,
      fontSize: _level6,
      fontWeight: FontWeight.w500,
    ),

    /// bold 20
    headlineLarge: TextStyle(
      fontFamily: almarai,
      fontSize: _level6,
      fontWeight: FontWeight.bold,
    ),

    /// bold 18
    headlineMedium: TextStyle(
      fontFamily: almarai,
      fontSize: _level5,
      fontWeight: FontWeight.bold,
    ),

    /// regular 16
    headlineSmall: TextStyle(
      fontFamily: almarai,
      fontSize: _level4,
      fontWeight: FontWeight.w500,
    ),

    /// bold 16
    titleLarge: TextStyle(
      fontFamily: almarai,
      fontSize: _level4,
      fontWeight: FontWeight.bold,
    ),

    /// extraBold 16
    bodyLarge: TextStyle(
      fontFamily: almarai,
      fontSize: _level4,
      fontWeight: FontWeight.w800,
    ),

    /// regular 12
    titleMedium: TextStyle(
      fontFamily: almarai,
      fontSize: _level3,
      fontWeight: FontWeight.w500,
    ),

    /// light 12
    titleSmall: TextStyle(
      fontFamily: almarai,
      fontSize: _level3,
      fontWeight: FontWeight.w300,
    ),

    /// bold 12
    labelLarge: TextStyle(
      fontFamily: almarai,
      fontSize: _level3,
      fontWeight: FontWeight.bold,
    ),

    /// bold 10
    labelMedium: TextStyle(
      fontFamily: almarai,
      fontSize: _level2,
      fontWeight: FontWeight.bold,
    ),

    /// regular 8
    labelSmall: TextStyle(
      fontFamily: almarai,
      fontSize: _level1,
      fontWeight: FontWeight.w300,
    ),
  );
}
