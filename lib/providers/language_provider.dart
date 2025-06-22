import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class LanguageProvider extends ChangeNotifier {
  static const String _languageKey = 'selected_language';
  
  Locale _currentLocale = const Locale('en', '');
  
  Locale get currentLocale => _currentLocale;
  
  String get currentLanguageCode => _currentLocale.languageCode;
  
  LanguageProvider() {
    _loadLanguage();
  }
  
  Future<void> _loadLanguage() async {
    final prefs = await SharedPreferences.getInstance();
    final languageCode = prefs.getString(_languageKey) ?? 'en';
    _currentLocale = Locale(languageCode, '');
    notifyListeners();
  }
  
  Future<void> changeLanguage(String languageCode) async {
    if (_currentLocale.languageCode != languageCode) {
      final prefs = await SharedPreferences.getInstance();
      await prefs.setString(_languageKey, languageCode);
      _currentLocale = Locale(languageCode, '');
      notifyListeners();
    }
  }
  
  String getLanguageName(String languageCode) {
    switch (languageCode) {
      case 'ar':
        return 'العربية';
      case 'de':
        return 'Deutsch';
      case 'en':
      default:
        return 'English';
    }
  }
  
  List<Map<String, String>> get supportedLanguages => [
    {'code': 'en', 'name': 'English'},
    {'code': 'ar', 'name': 'العربية'},
    {'code': 'de', 'name': 'Deutsch'},
  ];
}