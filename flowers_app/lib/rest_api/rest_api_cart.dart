import 'dart:convert';
import 'package:flowers_app/rest_api/rest_api_product.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

import 'rest_api_constants.dart';
import 'package:flowers_app/common/utils.dart';

class CartService {
  static Future<bool> addProductToCart(productId) async {
    String url =
        "${REST_API_CONSTANTS.CART_ROOT_URL}/add-product?productId=$productId";

    String tokenType = await Utils.getSharedString("tokenType");
    String token = await Utils.getSharedString("token");

    dynamic headers = REST_API_CONSTANTS.DEFAULT_REQUEST_HEADERS;
    headers["Authorization"] = "$tokenType $token";

    final response = await http.post(
      url,
      headers: headers,
    );

    if (response.statusCode == 200) {
      return true;
    }

    return false;
  }

  static Future<bool> removeProductFromCart(productId) async {
    String url =
        "${REST_API_CONSTANTS.CART_ROOT_URL}/remove-product?productId=$productId";

    String tokenType = await Utils.getSharedString("tokenType");
    String token = await Utils.getSharedString("token");

    dynamic headers = REST_API_CONSTANTS.DEFAULT_REQUEST_HEADERS;
    headers["Authorization"] = "$tokenType $token";

    final response = await http.post(
      url,
      headers: headers,
    );

    if (response.statusCode == 200) {
      return true;
    }

    return false;
  }

  static Future<bool> isProductInCart(productId) async {
    String url =
        "${REST_API_CONSTANTS.CART_ROOT_URL}/is-product-in-cart?productId=$productId";

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

    return false;
  }

  static Future<dynamic> getAllProducts() async {
    String url = "${REST_API_CONSTANTS.CART_ROOT_URL}/all-products";
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
      dynamic productsDescr = json.decode(response.body);
      dynamic res = {};

      res["productsDescrs"] = productsDescr["products"];
      res["products"] = [];
      for (dynamic elm in productsDescr["products"]) {
        var productFullInfo =
            await ProductService.getProductFullInfo(id: elm["id"]);
        res["products"].add({"info": productFullInfo, "amount": elm["amount"]});
      }

      return res;
    }

    return null;
  }

  static Future<bool> clearCart() async {
    String url = "${REST_API_CONSTANTS.CART_ROOT_URL}/clear";

    String tokenType = await Utils.getSharedString("tokenType");
    String token = await Utils.getSharedString("token");

    dynamic headers = REST_API_CONSTANTS.DEFAULT_REQUEST_HEADERS;
    headers["Authorization"] = "$tokenType $token";

    final response = await http.post(
      url,
      headers: headers,
    );

    if (response.statusCode == 200) {
      return true;
    }

    return false;
  }

  static Future<String> getCartStatus() async {
    String url = "${REST_API_CONSTANTS.CART_ROOT_URL}/status";
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
      return response.body;
    }

    return null;
  }

  static Future<bool> increaseCartStatus() async {
    String url = "${REST_API_CONSTANTS.CART_ROOT_URL}/increase-status";
    String tokenType = await Utils.getSharedString("tokenType");
    String token = await Utils.getSharedString("token");

    dynamic headers = REST_API_CONSTANTS.DEFAULT_REQUEST_HEADERS;
    headers["Authorization"] = "$tokenType $token";

    final response = await http.post(
      url,
      headers: headers,
    );

    if (response.statusCode == 200) {
      return true;
    }

    return false;
  }

  static Future<bool> updateReceiverInfo(name, email, phone) async {
    String url = "${REST_API_CONSTANTS.CART_ROOT_URL}/formation-info";
    String tokenType = await Utils.getSharedString("tokenType");
    String token = await Utils.getSharedString("token");

    dynamic headers = REST_API_CONSTANTS.DEFAULT_REQUEST_HEADERS;
    headers["Authorization"] = "$tokenType $token";

    dynamic request = {
      "receiverName": name,
      "receiverPhone": phone,
      "receiverEmail": email
    };

    final response = await http.post(
      url,
      headers: headers,
      body: json.encode(request),
    );

    if (response.statusCode == 200) {
      return true;
    }

    return false;
  }

  static Future<bool> updateShippingInfo(
      street, houseNum, apartmentNum, comment, deliveryMethod) async {
    String url = "${REST_API_CONSTANTS.CART_ROOT_URL}/formation-info";
    String tokenType = await Utils.getSharedString("tokenType");
    String token = await Utils.getSharedString("token");

    dynamic headers = REST_API_CONSTANTS.DEFAULT_REQUEST_HEADERS;
    headers["Authorization"] = "$tokenType $token";

    dynamic request = {
      "receiverStreet": street,
      "receiverHouseNum": houseNum,
      "receiverApartmentNum": apartmentNum,
      "deliveryComment": comment,
      "deliveryMethod": deliveryMethod
    };

    final response = await http.post(
      url,
      headers: headers,
      body: json.encode(request),
    );

    if (response.statusCode == 200) {
      return true;
    }

    return false;
  }

  static Future<dynamic> getCartFullInfo() async {
    String url = "${REST_API_CONSTANTS.CART_ROOT_URL}/full-info";
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
      res["allProducts"] = await getAllProducts();
      return res;
    }

    return null;
  }

  static Future<bool> updatePaymentInfo(paymentMethod) async {
    String url = "${REST_API_CONSTANTS.CART_ROOT_URL}/formation-info";
    String tokenType = await Utils.getSharedString("tokenType");
    String token = await Utils.getSharedString("token");

    dynamic headers = REST_API_CONSTANTS.DEFAULT_REQUEST_HEADERS;
    headers["Authorization"] = "$tokenType $token";

    dynamic request = {
      "paymentMethod": paymentMethod,
    };

    final response = await http.post(
      url,
      headers: headers,
      body: json.encode(request),
    );

    return response.statusCode == 200;
  }

  static Future<bool> createOrder() async {
    String url = "${REST_API_CONSTANTS.CART_ROOT_URL}/create-order";
    String tokenType = await Utils.getSharedString("tokenType");
    String token = await Utils.getSharedString("token");

    dynamic headers = REST_API_CONSTANTS.DEFAULT_REQUEST_HEADERS;
    headers["Authorization"] = "$tokenType $token";

    final response = await http.post(
      url,
      headers: headers,
    );

    return response.statusCode == 200;
  }
}
