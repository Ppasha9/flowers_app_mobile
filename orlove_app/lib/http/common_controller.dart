import 'dart:convert';
import 'package:http/http.dart' as http;

import 'package:orlove_app/http/constants.dart';

class CommonController {
  static String lastErrorMsg = "";

  static Future<List<dynamic>> getAllTagsList() async {
    String url = HttpConstants.SERVER_HOST + "/api/tag";

    final response = await http.get(url);
    if (response.statusCode == 200) {
      return json.decode(response.body);
    } else {
      lastErrorMsg = "Cannot retrieve all tags list";
      return null;
    }
  }

  static Future<List<dynamic>> getAllFlowersList() async {
    String url = HttpConstants.SERVER_HOST + "/api/flower";

    final response = await http.get(url);
    if (response.statusCode == 200) {
      return json.decode(response.body);
    } else {
      lastErrorMsg = "Cannot retrieve all flowers list";
      return null;
    }
  }
}
