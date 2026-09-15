import 'package:flutter/material.dart';
import '../services/api_service.dart';

enum AuthStatus { unknown, guest, loggedIn }

class AuthProvider extends ChangeNotifier {
  final ApiService _api = ApiService();

  AuthStatus _status = AuthStatus.unknown;
  int? _userId;
  String? _phone;
  String? _fullName;
  bool _loading = false;
  String? _error;

  AuthStatus get status => _status;
  int? get userId => _userId;
  String? get phone => _phone;
  String? get fullName => _fullName;
  bool get loading => _loading;
  String? get error => _error;
  bool get isLoggedIn => _status == AuthStatus.loggedIn;

  Future<void> init() async {
    await _api.init();
    final loggedIn = await _api.isLoggedIn();
    if (loggedIn) {
      _userId = await _api.getUserId();
      _phone = await _api.getUserPhone();
      _fullName = await _api.getUserName();
      _status = AuthStatus.loggedIn;
    } else {
      _status = AuthStatus.guest;
    }
    notifyListeners();
  }

  Future<bool> loginOrRegister({
    required String phone,
    required String password,
    String? fullName,
  }) async {
    _loading = true;
    _error = null;
    notifyListeners();

    final cleanPhone = _normalizePhone(phone);

    try {
      try {
        final data = await _api.login(phone: cleanPhone, password: password);
        await _setUserFromResponse(data);
        return true;
      } on Exception catch (e) {
        final msg = e.toString();
        if (msg.contains('شماره یا رمز اشتباه')) {
          try {
            final data = await _api.register(
              phone: cleanPhone,
              password: password,
              fullName: fullName,
            );
            await _setUserFromResponse(data);
            return true;
          } on Exception catch (regErr) {
            final regMsg = regErr.toString();
            if (regMsg.contains('قبلاً ثبت‌نام')) {
              _error = 'رمز عبور اشتباه است';
            } else {
              _error = regMsg;
            }
            return false;
          }
        }
        _error = msg;
        return false;
      }
    } finally {
      _loading = false;
      notifyListeners();
    }
  }

  Future<void> _setUserFromResponse(Map<String, dynamic> data) async {
    final user = data['user'] as Map<String, dynamic>;
    _userId = user['id'] as int;
    _phone = user['phone'] as String;
    _fullName = user['full_name'] as String?;
    _status = AuthStatus.loggedIn;
  }

  Future<void> logout() async {
    await _api.logout();
    _userId = null;
    _phone = null;
    _fullName = null;
    _status = AuthStatus.guest;
    notifyListeners();
  }

  void clearError() {
    _error = null;
    notifyListeners();
  }

  String _normalizePhone(String phone) {
    return phone
        .trim()
        .replaceAll(' ', '')
        .replaceAll('-', '')
        .replaceAll('۰', '0')
        .replaceAll('۱', '1')
        .replaceAll('۲', '2')
        .replaceAll('۳', '3')
        .replaceAll('۴', '4')
        .replaceAll('۵', '5')
        .replaceAll('۶', '6')
        .replaceAll('۷', '7')
        .replaceAll('۸', '8')
        .replaceAll('۹', '9');
  }
}
