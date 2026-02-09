import 'package:shared_preferences/shared_preferences.dart';

class StorageService {
  static const String _authTokenKey = 'auth_token';
  static const String _userIdKey = 'user_id';

  final SharedPreferences _prefs;

  StorageService(this._prefs);

  // Auth Token
  Future<void> saveAuthToken(String token) async {
    await _prefs.setString(_authTokenKey, token);
  }

// can use flutter_secure_storage for more secure storage
  String? getAuthToken() {
    return _prefs.getString(_authTokenKey);
  }

  Future<void> removeAuthToken() async {
    await _prefs.remove(_authTokenKey);
  }

  bool isLoggedIn() {
    return _prefs.containsKey(_authTokenKey);
  }

  // User ID
  Future<void> saveUserId(int userId) async {
    await _prefs.setInt(_userIdKey, userId);
  }

  int? getUserId() {
    return _prefs.getInt(_userIdKey);
  }

  // Clear all data
  Future<void> clearAll() async {
    await _prefs.clear();
  }
}
