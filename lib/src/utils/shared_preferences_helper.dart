import 'dart:convert';

import 'package:shared_preferences/shared_preferences.dart';

class SharedPreferencesHelper {
  Future<void> saveSessionToken(String key, value) async {
    final preferences = await SharedPreferences.getInstance();
    preferences.setString(key, json.encode(value));
  }

  Future<dynamic> readSessionToken(String key) async {
    final preferences = await SharedPreferences.getInstance();
    final storedValue = preferences.getString(key);
    if (storedValue == null) return null;
    return json.decode(storedValue);
  }

  Future<bool> containsSessionToken(String key) async {
    final preferences = await SharedPreferences.getInstance();
    return preferences.containsKey(key);
  }

  Future<bool> clearSession(String key) async {
    final preferences = await SharedPreferences.getInstance();
    return preferences.remove(key);
  }
}
