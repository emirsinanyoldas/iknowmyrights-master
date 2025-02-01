import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'app_en.dart';
import 'app_tr.dart';

class LanguageProvider extends ChangeNotifier {
  static const String _languageKey = 'selected_language';
  String _currentLanguage = 'TR';
  late SharedPreferences _prefs;

  LanguageProvider() {
    _loadLanguage();
  }

  String get currentLanguage => _currentLanguage;

  Future<void> _loadLanguage() async {
    _prefs = await SharedPreferences.getInstance();
    _currentLanguage = _prefs.getString(_languageKey) ?? 'TR';
    notifyListeners();
  }

  Future<void> setLanguage(String languageCode) async {
    if (_currentLanguage != languageCode) {
      _currentLanguage = languageCode;
      await _prefs.setString(_languageKey, languageCode);
      notifyListeners();
    }
  }

  String translate(String key) {
    final translations = _currentLanguage == 'TR' ? AppTr.values : AppEn.values;
    return translations[key] ?? key;
  }
} 