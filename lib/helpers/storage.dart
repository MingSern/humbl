import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';

class Storage {
  // Set
  static setString(String key, var value) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    value = json.encode(value);
    prefs.setString(key, value);
  }

  static setBoolean(String key, bool value) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.setBool(key, value);
  }

  // Get
  static getString(String key) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    var data = prefs.getString(key);

    return json.decode(data);
  }

  static getBoolean(String key) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();

    return prefs.getBool(key);
  }

  // Clear
  static clear() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.clear();
  }
}
