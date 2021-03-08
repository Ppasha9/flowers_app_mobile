import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

import 'rest_api_constants.dart';
import 'package:flowers_app/common/utils.dart';

class AuthService {
  static Future<void> _decodeAuthResponseBody(response) async {
    dynamic body = json.decode(response.body);
    SharedPreferences prefs = await SharedPreferences.getInstance();

    await prefs.setString("token", body["token"]);
    await prefs.setString("tokenType", body["tokenType"]);
    await prefs.setString("email", body["email"]);
    await prefs.setString("name", body["name"]);
    await prefs.setString("phone", body["phone"]);
    await prefs.setBool("isLogged", true);
  }

  static Future<dynamic> performLogin({String email, String password}) async {
    String url = "${REST_API_CONSTANTS.AUTH_ROOT_URL}/signin";
    dynamic requestBody = {
      "email": email,
      "password": password,
    };

    final response = await http.post(
      url,
      body: json.encode(requestBody),
      headers: REST_API_CONSTANTS.DEFAULT_REQUEST_HEADERS,
    );

    if (response.statusCode == 200) {
      await _decodeAuthResponseBody(response);
      return true;
    }
  }

  static Future<bool> performSignup(
      {String email, String password, String phone, String name}) async {
    String url = "${REST_API_CONSTANTS.AUTH_ROOT_URL}/signup";
    dynamic requestBody = {
      "email": email,
      "password": password,
      "name": name,
      "phone": phone,
    };

    final response = await http.post(
      url,
      body: json.encode(requestBody),
      headers: REST_API_CONSTANTS.DEFAULT_REQUEST_HEADERS,
    );

    if (response.statusCode == 200) {
      await _decodeAuthResponseBody(response);
      return true;
    }

    return false;
  }

  static Future<dynamic> getUserInfo() async {
    String url = "${REST_API_CONSTANTS.AUTH_ROOT_URL}/me";
    String tokenType = await Utils.getSharedString("tokenType");
    String token = await Utils.getSharedString("token");

    dynamic headers = {
      "Accept": "*/*",
      "Authorization": "$tokenType $token",
    };

    final response = await http.get(
      url,
      headers: headers,
    );

    if (response.statusCode == 200) {
      return json.decode(response.body);
    }

    return null;
  }

  static Future<bool> performEdit(
      {String name, String password, String email, String phone}) async {
    String url = "${REST_API_CONSTANTS.AUTH_ROOT_URL}/edit";
    String tokenType = await Utils.getSharedString("tokenType");
    String token = await Utils.getSharedString("token");

    dynamic headers = REST_API_CONSTANTS.DEFAULT_REQUEST_HEADERS;
    headers["Authorization"] = "$tokenType $token";

    dynamic requestBody = {
      "email": email,
      "password": password,
      "name": name,
      "phone": phone,
    };

    final response = await http.post(
      url,
      body: json.encode(requestBody),
      headers: headers,
    );

    return response.statusCode == 200;
  }
}
