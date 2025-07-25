import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class LanguageProvider extends ChangeNotifier {
  final SharedPreferences _prefs;
  Locale _locale = const Locale('en');
  String _currentLanguage = 'en';

  LanguageProvider(this._prefs) {
    _loadLanguage();
  }

  Locale get locale => _locale;
  String get currentLanguage => _currentLanguage;

  Future<void> _loadLanguage() async {
    final languageCode = _prefs.getString('language_code') ?? 'en';
    _currentLanguage = languageCode;
    _locale = Locale(languageCode);
    notifyListeners();
  }

  Future<void> changeLanguage(String languageCode) async {
    _currentLanguage = languageCode;
    _locale = Locale(languageCode);
    await _prefs.setString('language_code', languageCode);
    notifyListeners();
  }

  bool get isRTL => _currentLanguage == 'ar' || _currentLanguage == 'ku';
}
