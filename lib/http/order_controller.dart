import 'dart:convert';
import 'package:http/http.dart' as http;

import 'package:orlove_app/http/constants.dart';
import 'package:orlove_app/http/product_controller.dart';
import 'package:orlove_app/storage/storage.dart';

class OrderController {
  static String lastErrorMsg = "";

  static Future<dynamic> getOrders() async {
    String url = HttpConstants.SERVER_HOST + HttpConstants.ORDER_PATH;

    dynamic headers = {
      "Accept": "*/*",
      "Authorization": "${SecureStorage.tokenType} ${SecureStorage.token}",
    };

    final response = await http.get(
      url,
      headers: headers,
    );

    if (response.statusCode != 200) {
      lastErrorMsg = "Cannot get all orders list";
      return null;
    }

    return json.decode(response.body);
  }

  static Future<dynamic> getOrderDetails(orderId) async {
    String url =
        HttpConstants.SERVER_HOST + HttpConstants.ORDER_PATH + "/$orderId";

    dynamic headers = {
      "Accept": "*/*",
      "Authorization": "${SecureStorage.tokenType} ${SecureStorage.token}",
    };

    final response = await http.get(
      url,
      headers: headers,
    );

    if (response.statusCode != 200) {
      lastErrorMsg = "Cannot get all orders list";
      return null;
    }

    var responseBody = json.decode(response.body);
    for (dynamic prInfo in responseBody["products"]) {
      prInfo["info"] = await ProductController.getProductInfoById(
        prInfo["id"],
      );
    }

    return responseBody;
  }
}
