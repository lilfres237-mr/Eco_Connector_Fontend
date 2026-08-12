import 'dart:convert';
import 'package:flutter/material.dart';
import '../models/user_model.dart';
import '../services/storage_service.dart';

class UserProvider extends ChangeNotifier {
  UserModel? _user;

  UserModel? get user => _user;

  UserProvider() {
    _loadUser();
  }

  void _loadUser() {
    final userJson = StorageService.getString('current_user'); 
    if (userJson != null && userJson.isNotEmpty) {
      try {
        _user = UserModel.fromJson(json.decode(userJson));
      } catch (_) {
        _user = null;
      }
    } else {
      _user = null;
    }
    notifyListeners();
  }

  Future<void> setUser(UserModel? user) async {
    _user = user;
    if (user != null) {
      await StorageService.setString('current_user', json.encode(user.toJson()));
    } else {
      await StorageService.setString('current_user', '');
    }
    notifyListeners();
  }

  Future<void> updateUser(UserModel updatedUser) async {
    _user = updatedUser;
    await StorageService.setString('current_user', json.encode(updatedUser.toJson()));
    notifyListeners();
  }

  Future<void> updatePoints(double delta) async {
    if (_user != null) {
      _user = _user!.copyWith(ecoRating: _user!.ecoRating + delta); 
      await StorageService.setString('current_user', json.encode(_user!.toJson()));
      notifyListeners();
    }
  }

  Future<void> registerAsRider({
    required String idNumber,
    required String idImageUrl,
    String? vehicleInfo,
  }) async {
    if (_user != null) {
      _user = _user!.copyWith(
        role: UserRole.rider,
        governmentIdUrl: idImageUrl,
      );
      await StorageService.setString('current_user', json.encode(_user!.toJson()));
      notifyListeners();
    }
  }

  Future<void> switchMode(AppMode mode) async {
    if (_user != null && _user!.role == UserRole.rider) {
      _user = _user!.copyWith(currentMode: mode);
      await StorageService.setString('current_user', json.encode(_user!.toJson()));
      notifyListeners();
    }
  }
}
