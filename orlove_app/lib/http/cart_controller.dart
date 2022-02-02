import 'dart:convert';
import 'package:http/http.dart' as http;

import 'package:orlove_app/http/constants.dart';
import 'package:orlove_app/http/product_controller.dart';
import 'package:orlove_app/storage/storage.dart';
import 'package:time_machine/time_machine.dart';

class CartController {
  static String lastErrorMsg = "";

  static Future<bool> addProductToCart(id, params) async {
    String url =
        HttpConstants.SERVER_HOST + HttpConstants.CART_PATH + "/add-product";
    dynamic headers = HttpConstants.DEFAULT_REQUEST_HEADERS;
    headers["Authorization"] =
        "${SecureStorage.tokenType} ${SecureStorage.token}";

    dynamic reqParams = [];
    (params as List).forEach((el) {
      reqParams.add(el.toJson());
    });

    dynamic reqBody = {
      "productId": id,
      "parameters": reqParams,
    };

    final response = await http.post(
      url,
      body: json.encode(reqBody),
      headers: headers,
    );

    if (response.statusCode != 200) {
      lastErrorMsg = "Cannot add product to cart";
      return false;
    }

    return true;
  }

  static Future<bool> removeProductFromCart(productId, params) async {
    String url =
        HttpConstants.SERVER_HOST + HttpConstants.CART_PATH + "/remove-product";

    dynamic headers = HttpConstants.DEFAULT_REQUEST_HEADERS;
    headers["Authorization"] =
        "${SecureStorage.tokenType} ${SecureStorage.token}";

    dynamic reqParams = [];
    (params as List).forEach((el) {
      reqParams.add(el.toJson());
    });

    dynamic reqBody = {
      "productId": productId,
      "parameters": reqParams,
    };

    final response = await http.post(
      url,
      body: json.encode(reqBody),
      headers: headers,
    );

    if (response.statusCode != 200) {
      lastErrorMsg = "Cannot remove product from cart";
      return false;
    }

    return true;
  }

  static Future<bool> permanentlyDeleteProductFromCart(
    productId,
    params,
  ) async {
    String url =
        HttpConstants.SERVER_HOST + HttpConstants.CART_PATH + "/remove-product";

    dynamic headers = HttpConstants.DEFAULT_REQUEST_HEADERS;
    headers["Authorization"] =
        "${SecureStorage.tokenType} ${SecureStorage.token}";

    dynamic reqParams = [];
    (params as List).forEach((el) {
      reqParams.add(el.toJson());
    });

    dynamic reqBody = {
      "productId": productId,
      "parameters": reqParams,
      "permanently": true.toString(),
    };

    final response = await http.post(
      url,
      body: json.encode(reqBody),
      headers: headers,
    );

    if (response.statusCode != 200) {
      lastErrorMsg = "Cannot permanently delete product from cart";
      return false;
    }

    return true;
  }

  static Future<bool> isProductInCart(productId) async {
    String url = HttpConstants.SERVER_HOST +
        HttpConstants.CART_PATH +
        "/is-product-in-cart?productId=$productId";

    dynamic headers = {
      "Accept": "*/*",
      "Authorization": "${SecureStorage.tokenType} ${SecureStorage.token}",
    };

    final response = await http.get(
      url,
      headers: headers,
    );

    if (response.statusCode != 200) {
      lastErrorMsg = "Cannot retrieve info about product in cart";
      return false;
    }

    return json.decode(response.body);
  }

  static Future<dynamic> getAllProducts() async {
    String url =
        HttpConstants.SERVER_HOST + HttpConstants.CART_PATH + "/all-products";

    dynamic headers = {
      "Accept": "*/*",
      "Authorization": "${SecureStorage.tokenType} ${SecureStorage.token}",
    };

    final response = await http.get(
      url,
      headers: headers,
    );

    if (response.statusCode != 200) {
      lastErrorMsg = "Cannot get all products in cart";
      return null;
    }

    dynamic productsDescr = json.decode(response.body);
    dynamic res = {};

    res["products"] = [];
    for (dynamic elm in productsDescr["products"]) {
      var productFullInfo =
          await ProductController.getProductInfoById(elm["id"]);
      res["products"].add({
        "info": productFullInfo,
        "amount": elm["amount"],
        "parameters": elm["parameters"],
      });
    }

    return res;
  }

  static Future<bool> clearCart() async {
    String url = HttpConstants.SERVER_HOST + HttpConstants.CART_PATH + "/clear";

    dynamic headers = HttpConstants.DEFAULT_REQUEST_HEADERS;
    headers["Authorization"] =
        "${SecureStorage.tokenType} ${SecureStorage.token}";

    final response = await http.post(
      url,
      headers: headers,
    );

    if (response.statusCode != 200) {
      lastErrorMsg = "Cannot clear cart";
      return false;
    }

    return true;
  }

  static Future<String> getCartStatus() async {
    String url =
        HttpConstants.SERVER_HOST + HttpConstants.CART_PATH + "/status";

    dynamic headers = {
      "Accept": "*/*",
      "Authorization": "${SecureStorage.tokenType} ${SecureStorage.token}",
    };

    final response = await http.get(
      url,
      headers: headers,
    );

    if (response.statusCode != 200) {
      lastErrorMsg = "Cannot get cart status";
      return null;
    }

    return json.decode(response.body);
  }

  static Future<bool> increaseCartStatus() async {
    String url = HttpConstants.SERVER_HOST +
        HttpConstants.CART_PATH +
        "/increase-status";

    dynamic headers = HttpConstants.DEFAULT_REQUEST_HEADERS;
    headers["Authorization"] =
        "${SecureStorage.tokenType} ${SecureStorage.token}";

    final response = await http.post(
      url,
      headers: headers,
    );

    if (response.statusCode != 200) {
      lastErrorMsg = "Cannot increase cart status";
      return false;
    }

    return true;
  }

  static Future<bool> updateReceiverInfo(name, surname, email, phone) async {
    String url =
        HttpConstants.SERVER_HOST + HttpConstants.CART_PATH + "/formation-info";

    dynamic headers = HttpConstants.DEFAULT_REQUEST_HEADERS;
    headers["Authorization"] =
        "${SecureStorage.tokenType} ${SecureStorage.token}";

    dynamic request = {
      "receiverName": name,
      "receiverPhone": phone,
      "receiverEmail": email,
      "receiverSurname": surname,
    };

    final response = await http.post(
      url,
      headers: headers,
      body: json.encode(request),
    );

    if (response.statusCode != 200) {
      lastErrorMsg = "Cannot update receiver info";
      return false;
    }

    return true;
  }

  static Future<bool> updateShippingInfo(street, houseNum, apartmentNum,
      comment, deliveryMethod, DateTime deliveryDate) async {
    String url =
        HttpConstants.SERVER_HOST + HttpConstants.CART_PATH + "/formation-info";

    dynamic headers = HttpConstants.DEFAULT_REQUEST_HEADERS;
    headers["Authorization"] =
        "${SecureStorage.tokenType} ${SecureStorage.token}";

    var localDateTime = new LocalDateTime.dateTime(deliveryDate.toLocal());
    dynamic request = {
      "receiverStreet": street,
      "receiverHouseNum": houseNum,
      "receiverApartmentNum": apartmentNum,
      "deliveryComment": comment,
      "deliveryMethod": deliveryMethod,
      "deliveryDate": OffsetDateTime(localDateTime, Offset(3)).toString(),
    };

    final response = await http.post(
      url,
      headers: headers,
      body: json.encode(request),
    );

    if (response.statusCode != 200) {
      lastErrorMsg = "Cannot update shipping info";
      return false;
    }

    return true;
  }

  static Future<dynamic> getCartFullInfo() async {
    String url =
        HttpConstants.SERVER_HOST + HttpConstants.CART_PATH + "/full-info";

    dynamic headers = {
      "Accept": "*/*",
      "Authorization": "${SecureStorage.tokenType} ${SecureStorage.token}",
    };

    final response = await http.get(
      url,
      headers: headers,
    );

    if (response.statusCode != 200) {
      lastErrorMsg = "Cannot get cart full info";
      return null;
    }

    var res = json.decode(response.body);
    res["allProducts"] = await getAllProducts();
    return res;
  }

  static Future<bool> updatePaymentInfo(paymentMethod) async {
    String url =
        HttpConstants.SERVER_HOST + HttpConstants.CART_PATH + "/formation-info";

    dynamic headers = HttpConstants.DEFAULT_REQUEST_HEADERS;
    headers["Authorization"] =
        "${SecureStorage.tokenType} ${SecureStorage.token}";

    dynamic request = {
      "paymentMethod": paymentMethod,
    };

    final response = await http.post(
      url,
      headers: headers,
      body: json.encode(request),
    );

    if (response.statusCode != 200) {
      lastErrorMsg = "Cannot update payment info";
      return false;
    }

    return true;
  }

  static Future<bool> createOrder() async {
    String url =
        HttpConstants.SERVER_HOST + HttpConstants.CART_PATH + "/create-order";

    dynamic headers = HttpConstants.DEFAULT_REQUEST_HEADERS;
    headers["Authorization"] =
        "${SecureStorage.tokenType} ${SecureStorage.token}";

    final response = await http.post(
      url,
      headers: headers,
    );

    if (response.statusCode != 200) {
      lastErrorMsg = "Cannot create order";
      return false;
    }

    return true;
  }
}
