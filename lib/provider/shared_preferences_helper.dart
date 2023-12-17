import 'package:shared_preferences/shared_preferences.dart';

class SharedPreferencesHelper {
  static const String _loggedInKey = 'loggedIn';
  static const String _matkKey = 'matk';

  static Future<void> setLoggedIn(bool value) async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.setBool(_loggedInKey, value);
  }

  static Future<bool?> getLoggedIn() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    return prefs.getBool(_loggedInKey);
  }

  static Future<void> setMatk(String matk) async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.setString(_matkKey, matk);
  }

  static Future<String?> getMatk() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    return prefs.getString(_matkKey);
  }
}
