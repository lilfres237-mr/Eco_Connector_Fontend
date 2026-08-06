import 'package:flutter/material.dart';
import '../services/storage_service.dart';

enum AppLanguage { english, french }

class SettingsProvider extends ChangeNotifier {
  AppLanguage _language = AppLanguage.english;
  bool _notificationsEnabled = true;
  bool _darkMode = false;

  AppLanguage get language => _language;
  bool get notificationsEnabled => _notificationsEnabled;
  bool get darkMode => _darkMode;

  SettingsProvider() {
    _loadSettings();
  }

  void _loadSettings() {
    final langCode = StorageService.getString('language_code') ?? 'en';
    _language = langCode == 'fr' ? AppLanguage.french : AppLanguage.english;
    _notificationsEnabled = StorageService.getBool('notifications_enabled') ?? true;
    _darkMode = StorageService.getBool('dark_mode') ?? false;
    notifyListeners();
  }

  Future<void> setLanguage(AppLanguage lang) async {
    _language = lang;
    await StorageService.setString('language_code', lang == AppLanguage.french ? 'fr' : 'en');
    notifyListeners();
  }

  Future<void> toggleNotifications(bool value) async {
    _notificationsEnabled = value;
    await StorageService.setBool('notifications_enabled', value);
    notifyListeners();
  }

  Future<void> toggleDarkMode(bool value) async {
    _darkMode = value;
    await StorageService.setBool('dark_mode', value);
    notifyListeners();
  }
  
  Locale get locale => _language == AppLanguage.english ? const Locale('en') : const Locale('fr');
}
