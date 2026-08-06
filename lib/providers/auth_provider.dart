import 'package:flutter/material.dart';
import '../services/storage_service.dart';
import '../models/user_model.dart';

class AuthProvider extends ChangeNotifier {
  bool _isAuthenticated = false;
  UserModel? _currentUser;
  bool _rememberMe = false;

  bool get isAuthenticated => _isAuthenticated;
  UserModel? get currentUser => _currentUser;
  bool get rememberMe => _rememberMe;

  AuthProvider() {
    _loadSession();
  }

  void _loadSession() {
    _isAuthenticated = StorageService.getBool('is_authenticated') ?? false;
    _rememberMe = StorageService.getBool('remember_me') ?? false;
    
    // We don't load user here anymore, UserProvider handles it
    if (!_rememberMe) {
      _isAuthenticated = false;
    }
    notifyListeners();
  }

  Future<void> login(UserModel user, bool rememberMe) async {
    _isAuthenticated = true;
    _rememberMe = rememberMe;
    
    await StorageService.setBool('is_authenticated', true);
    await StorageService.setBool('remember_me', rememberMe);
    
    notifyListeners();
  }

  Future<void> logout() async {
    _isAuthenticated = false;
    await StorageService.setBool('is_authenticated', false);
    notifyListeners();
  }

  // Helper to check if user needs to be cleared
  bool shouldClearUser() => !_isAuthenticated;

  Future<bool> changePassword(String oldPassword, String newPassword) async {
    // Mock password change logic
    await Future.delayed(const Duration(seconds: 1));
    return true;
  }
}
