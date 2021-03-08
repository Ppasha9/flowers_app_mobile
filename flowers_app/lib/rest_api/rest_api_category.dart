import 'dart:convert';
import 'package:http/http.dart' as http;

import 'rest_api_constants.dart';

class CategoryService {
  static Future<dynamic> getAllCategories() async {
    final response = await http.get('${REST_API_CONSTANTS.CATEGORY_ROOT_URL}');

    if (response.statusCode == 200) {
      return json.decode(response.body);
    } else {
      return null;
    }
  }
}
