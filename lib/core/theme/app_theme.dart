import 'package:flutter/material.dart';
import 'package:flutter_application_1/core/theme/colors.dart';

class AppTheme {


  //Dark theme settings 

  static final ThemeData darkTheme = ThemeData(
    brightness: Brightness.dark,
    scaffoldBackgroundColor:  Bkcolors.scaffoldbackground,
    primaryColor: Bkcolors.primarycolor,
    colorScheme: const ColorScheme.dark(
      primary: Bkcolors.primarycolor,
      secondary:Bkcolors.secondarycolor,
      surface: Bkcolors.surfacecolor,
    ),
    fontFamily: 'Poppins',
    textTheme: const TextTheme(
      bodyLarge: TextStyle(color: Bkcolors.whitecolor),
      bodyMedium: TextStyle(color: Bkcolors.whitecolor),
      titleLarge: TextStyle(color: Bkcolors.whitecolor, fontWeight: FontWeight.bold),
    ),
    appBarTheme: const AppBarTheme(
      backgroundColor: Bkcolors.trasprntcolor,
      elevation: 0,
      iconTheme: IconThemeData(color: Bkcolors.whitecolor),
    ),
    iconTheme: const IconThemeData(color: Bkcolors.whitecolor),
  );
/////////////////////////////////

  //Light theme Settings

  static final ThemeData lightTheme = ThemeData(
    brightness: Brightness.light,
    scaffoldBackgroundColor:  Bkcolors.whitecolor,
    primaryColor: Bkcolors.primarycolor,
    colorScheme: const ColorScheme.light(
      primary: Bkcolors.primarycolor,
      secondary: Bkcolors.secondarycolor,
      surface: Bkcolors.whitecolor,
    ),
    fontFamily: 'Poppins',
    textTheme: const TextTheme(
      bodyLarge: TextStyle(color: Bkcolors.themetext),
      bodyMedium: TextStyle(color:  Bkcolors.themetext),
      titleLarge: TextStyle(color:  Bkcolors.themetext, fontWeight: FontWeight.bold),
    ),
    appBarTheme: const AppBarTheme(
      backgroundColor: Bkcolors.trasprntcolor,
      elevation: 0,
      iconTheme: IconThemeData(color:Bkcolors.themetext),
    ),
    iconTheme: const IconThemeData(color:Bkcolors.themetext),
  );
}