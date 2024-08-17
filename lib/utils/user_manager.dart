import 'package:shared_preferences/shared_preferences.dart';

import 'app_constant.dart';

class LocalStorageManager {
  LocalStorageManager();
  static Future<String> getAccessToken() async {
    final Future<SharedPreferences> preference =
        SharedPreferences.getInstance();

    final SharedPreferences prefs = await preference;

    var accessToken = prefs.getString(AppConstant.accessToken);

    return accessToken ?? '';
  }

  static Future<int> getLastTokenTime() async {
    final Future<SharedPreferences> preference =
        SharedPreferences.getInstance();

    final SharedPreferences prefs = await preference;

    var lastTokenTimeString = prefs.getString(AppConstant.lastTokenTime);
    int lastTokenTime = 0;
    if (lastTokenTimeString != null && lastTokenTimeString.isNotEmpty) {
      lastTokenTime = int.parse(lastTokenTimeString);
    }
    return lastTokenTime;
  }

  static Future<int> getExpireTokenTime() async {
    final Future<SharedPreferences> preference =
        SharedPreferences.getInstance();

    final SharedPreferences prefs = await preference;

    var expTokenTimeString = prefs.getString(AppConstant.expireIn);
    int expTokenTime = 0;
    if (expTokenTimeString != null && expTokenTimeString.isNotEmpty) {
      expTokenTime = int.parse(expTokenTimeString);
    }
    return expTokenTime;
  }

  static Future<void> savePreferenceData(String key, String value) async {
    final Future<SharedPreferences> preference =
        SharedPreferences.getInstance();

    final SharedPreferences prefs = await preference;

    prefs.setString(key, value);
  }

  static Future<String?> getPreferenceData(String key) async {
    final Future<SharedPreferences> preference =
        SharedPreferences.getInstance();

    final SharedPreferences prefs = await preference;

    var value = prefs.getString(key);
    return value;
  }

  static Future<void> clearTokens() async {
    final Future<SharedPreferences> preference =
        SharedPreferences.getInstance();

    final SharedPreferences prefs = await preference;

    prefs.setString(AppConstant.accessToken, '');
    prefs.setString(AppConstant.refreshToken, '');
    prefs.setString(AppConstant.expireIn, '');
    prefs.setString(AppConstant.lastTokenTime, '');
  }
}
