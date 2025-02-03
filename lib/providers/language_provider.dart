import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class LanguageProvider with ChangeNotifier {
  String _currentLanguage = 'TR';
  
  String get currentLanguage => _currentLanguage;
  Locale get currentLocale => Locale(_currentLanguage.toLowerCase(), '');

  LanguageProvider() {
    _loadLanguagePreference();
  }

  Future<void> _loadLanguagePreference() async {
    final prefs = await SharedPreferences.getInstance();
    _currentLanguage = prefs.getString('language') ?? 'TR';
    notifyListeners();
  }

  Future<void> setLanguage(String languageCode) async {
    _currentLanguage = languageCode;
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString('language', languageCode);
    notifyListeners();
  }

  Future<void> changeLanguage(String languageCode) async {
    await setLanguage(languageCode);
  }
}
