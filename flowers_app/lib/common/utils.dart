import 'dart:convert';

import 'package:shared_preferences/shared_preferences.dart';

class Utils {
  static Future<String> getSharedString(String key) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    return prefs.getString(key);
  }

  static Future<bool> isUserLoggedIn() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    return prefs.getBool("isLogged");
  }

  static String fromUTF8(String strToDecode) {
    return utf8.decode(strToDecode.toString().codeUnits);
  }
}
