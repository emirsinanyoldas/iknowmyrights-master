import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class LanguageProvider extends ChangeNotifier {
  static const String _languageKey = 'selected_language';
  Locale _currentLocale = const Locale('tr');
  bool _isInitialized = false;

  Locale get currentLocale => _currentLocale;

  LanguageProvider() {
    _loadLanguage();
  }

  Future<void> _loadLanguage() async {
    if (_isInitialized) return;
    
    try {
      final prefs = await SharedPreferences.getInstance();
      final String langCode = prefs.getString(_languageKey) ?? 'tr';
      _currentLocale = Locale(langCode);
      _isInitialized = true;
      notifyListeners();
    } catch (e) {
      debugPrint('Error loading language: $e');
    }
  }

  void changeLanguage(String languageCode) {
    if (_currentLocale.languageCode != languageCode) {
      _currentLocale = Locale(languageCode);
      SharedPreferences.getInstance().then((prefs) {
        prefs.setString(_languageKey, languageCode);
      });
      notifyListeners();
    }
  }
}
