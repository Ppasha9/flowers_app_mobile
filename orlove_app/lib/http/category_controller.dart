import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:orlove_app/http/constants.dart';

class CategoryController {
  static String lastErrorMsg = "";

  static Future<List<dynamic>> getAllCategories() async {
    String url = HttpConstants.SERVER_HOST + HttpConstants.CATEGORY_PATH;
    final response = await http.get(url);

    if (response.statusCode != 200) {
      lastErrorMsg = "Cannot retrieve list of all categories";
      return null;
    }

    return json.decode(response.body);
  }
}
