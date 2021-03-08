import 'dart:convert';
import 'package:http/http.dart' as http;

import 'rest_api_constants.dart';

class ProductService {
  static Future<dynamic> getOneProductPerEachCategory() async {
    final response = await http
        .get('${REST_API_CONSTANTS.PRODUCT_ROOT_URL}/one-per-category');
    var resJson;

    if (response.statusCode == 200) {
      resJson = json.decode(response.body);

      for (dynamic prJson in resJson["elems"]) {
        final picturesResponse = await http.get(
            '${REST_API_CONSTANTS.PRODUCT_ROOT_URL}/${prJson["product"]["id"]}/all-pictures');

        if (picturesResponse.statusCode == 200) {
          prJson["product"]["pictures"] =
              json.decode(picturesResponse.body)["pictures"];
        } else {
          return null;
        }
      }

      return resJson;
    } else {
      return null;
    }
  }

  static Future<dynamic> getProductsForCategory(
      {num limit: 5,
      bool isAll: false,
      num groupNum: 0,
      String category}) async {
    String url = isAll
        ? '${REST_API_CONSTANTS.PRODUCT_ROOT_URL}?category=$category'
        : '${REST_API_CONSTANTS.PRODUCT_ROOT_URL}?limit=$limit&category=$category';
    if (groupNum != 0) {
      url += "&group-num=$groupNum";
    }

    final response = await http.get(url);
    var resJson;

    if (response.statusCode == 200) {
      resJson = json.decode(response.body);

      for (dynamic prJson in resJson["products"]) {
        final picturesResponse = await http.get(
            '${REST_API_CONSTANTS.PRODUCT_ROOT_URL}/${prJson["id"]}/all-pictures');

        if (picturesResponse.statusCode == 200) {
          prJson["picture"] = json.decode(picturesResponse.body)["pictures"][0];
        } else {
          return null;
        }
      }

      return resJson;
    } else {
      return null;
    }
  }

  static Future<num> getProductsMaxPriceByCategory({String category}) async {
    final url =
        '${REST_API_CONSTANTS.PRODUCT_ROOT_URL}/max-price?category=$category';
    final response = await http.get(url);

    if (response.statusCode == 200) {
      return json.decode(response.body);
    } else {
      return null;
    }
  }

  static Future<dynamic> filterCategoryProductsByPrice(
      {String category, num limit, num minPrice, num maxPrice}) async {
    final url =
        '${REST_API_CONSTANTS.PRODUCT_ROOT_URL}?category=$category&min-price=$minPrice&max-price=$maxPrice&limit=$limit';
    final response = await http.get(url);
    var resJson;

    if (response.statusCode == 200) {
      resJson = json.decode(response.body);

      for (dynamic prJson in resJson["products"]) {
        final picturesResponse = await http.get(
            '${REST_API_CONSTANTS.PRODUCT_ROOT_URL}/${prJson["id"]}/all-pictures');

        if (picturesResponse.statusCode == 200) {
          prJson["picture"] = json.decode(picturesResponse.body)["pictures"][0];
        } else {
          return null;
        }
      }

      return resJson;
    } else {
      return null;
    }
  }

  static Future<dynamic> getProductFullInfo({num id}) async {
    final response =
        await http.get('${REST_API_CONSTANTS.PRODUCT_ROOT_URL}/$id');
    var resJson;

    if (response.statusCode == 200) {
      resJson = json.decode(response.body);

      final picsResponse = await http
          .get('${REST_API_CONSTANTS.PRODUCT_ROOT_URL}/$id/all-pictures');

      if (picsResponse.statusCode == 200) {
        resJson["pictures"] = json.decode(picsResponse.body)["pictures"];
      } else {
        return null;
      }

      return resJson;
    } else {
      return null;
    }
  }
}
