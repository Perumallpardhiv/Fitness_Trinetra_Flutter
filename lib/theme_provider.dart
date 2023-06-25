import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ThemeProvider extends ChangeNotifier {
  ThemeMode themeMode = ThemeMode.light;

  ThemeProvider({String? theme}) {
    themeMode = theme == "ThemeMode.light" ? ThemeMode.light : ThemeMode.dark;
  }

  Future<void> toggleTheme(bool isOn) async {
    SharedPreferences shares = await SharedPreferences.getInstance();
    themeMode = isOn ? ThemeMode.dark : ThemeMode.light;
    shares.setString('themeMode', themeMode.toString());
    notifyListeners();
  }
}
