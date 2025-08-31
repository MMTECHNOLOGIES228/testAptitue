import 'package:flutter/material.dart';
import 'package:hive/hive.dart';

class ThemeProvider with ChangeNotifier {
  bool _isDark = false;
  bool get isDark => _isDark;

  ThemeProvider() {
    // Charger le thème sauvegardé dans Hive
    _loadTheme();
  }

  void toggleTheme() async {
    _isDark = !_isDark;
    notifyListeners();

    var box = await Hive.openBox('settings');
    box.put('isDark', _isDark);
  }

  void _loadTheme() async {
    var box = await Hive.openBox('settings');
    _isDark = box.get('isDark', defaultValue: false);
    notifyListeners();
  }
}
