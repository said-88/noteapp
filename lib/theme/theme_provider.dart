import 'package:flutter/material.dart';
import 'package:myapp/theme/theme.dart';

class ThemeProvider with ChangeNotifier {
  ThemeData _themeData = lightMode;

  // getter method to access the theme from other parts of the app
  ThemeData get themeData => _themeData;

  // getter method to check if the theme is dark or not
  bool get isDarkMode => _themeData == darkMode;

  // setter method to change the theme
  set themeData(ThemeData themeData) {
    _themeData = themeData;
    notifyListeners();
  }

  void toggleTheme() {
    _themeData = _themeData == lightMode ? darkMode : lightMode;
    notifyListeners();
  }
}
