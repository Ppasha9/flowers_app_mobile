import 'dart:convert';
import 'package:http/http.dart' as http;

import 'package:orlove_app/http/constants.dart';
import 'package:orlove_app/storage/storage.dart';

class AuthController {
  static String lastErrorMsg = "";

  static Future _decodeAuthResponseBody(response) async {
    dynamic body = json.decode(response.body);

    SecureStorage.token = body["token"];
    SecureStorage.tokenType = body["tokenType"];
    SecureStorage.name = body["name"];
    SecureStorage.surname = body["surname"];
    SecureStorage.email = body["email"];
    SecureStorage.phone = body["phone"];
    SecureStorage.isLogged = true;
  }

  static Future<bool> performLogin(String email, String password) async {
    String url =
        HttpConstants.SERVER_HOST + HttpConstants.AUTH_PATH + "/signin";
    dynamic reqBody = {
      "email": email,
      "password": password,
    };

    final response = await http.post(
      url,
      body: json.encode(reqBody),
      headers: HttpConstants.DEFAULT_REQUEST_HEADERS,
    );

    if (response.statusCode != 200) {
      lastErrorMsg = "Cannot signin.";
      return false;
    }

    await _decodeAuthResponseBody(response);
    return true;
  }

  static Future<bool> performSignup({
    String email,
    String password,
    String phone,
    String name,
    String surname,
  }) async {
    String url =
        HttpConstants.SERVER_HOST + HttpConstants.AUTH_PATH + "/signup";
    dynamic reqBody = {
      "email": email,
      "password": password,
      "name": name,
      "phone": phone,
      "surname": surname,
    };

    final response = await http.post(
      url,
      body: json.encode(reqBody),
      headers: HttpConstants.DEFAULT_REQUEST_HEADERS,
    );

    if (response.statusCode != 200) {
      lastErrorMsg = "Cannot signup.";
      return false;
    }

    await _decodeAuthResponseBody(response);
    return true;
  }

  static Future<dynamic> getUserInfo() async {
    String url = HttpConstants.SERVER_HOST + HttpConstants.AUTH_PATH + "/me";
    String tokenType = SecureStorage.tokenType;
    String token = SecureStorage.token;

    dynamic headers = {
      "Accept": "*/*",
      "Authorization": "$tokenType $token",
    };

    final response = await http.get(
      url,
      headers: headers,
    );

    if (response.statusCode != 200) {
      lastErrorMsg = "Cannot retrieve user info.";
      return null;
    }

    return json.decode(response.body);
  }

  static Future<bool> performEdit({
    String email,
    String password,
    String phone,
    String name,
    String surname,
  }) async {
    String url = HttpConstants.SERVER_HOST + HttpConstants.AUTH_PATH + "/edit";
    String tokenType = SecureStorage.tokenType;
    String token = SecureStorage.token;

    dynamic headers = HttpConstants.DEFAULT_REQUEST_HEADERS;
    headers["Authorization"] = "$tokenType $token";

    dynamic reqBody = {
      "email": email,
      "password": password,
      "name": name,
      "surname": surname,
      "phone": phone,
    };

    final response = await http.post(
      url,
      body: json.encode(reqBody),
      headers: headers,
    );

    if (response.statusCode != 200) {
      lastErrorMsg = "Failed to perform edit.";
      return false;
    }

    return true;
  }
}
