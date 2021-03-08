import 'dart:convert';
import 'package:flowers_app/rest_api/rest_api_product.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

import 'rest_api_constants.dart';
import 'package:flowers_app/common/utils.dart';

class OrderService {
  static Future<dynamic> getOrders() async {
    String url = "${REST_API_CONSTANTS.ORDER_ROOT_URL}";
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

  static Future<dynamic> getOrderDetails(orderId) async {
    String url = "${REST_API_CONSTANTS.ORDER_ROOT_URL}/$orderId";
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
      var res = json.decode(response.body);
      for (dynamic prInfo in res["products"]) {
        prInfo["info"] = await ProductService.getProductFullInfo(
          id: prInfo["id"],
        );
      }

      return res;
    }

    return null;
  }
}
