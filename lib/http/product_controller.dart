import 'dart:convert';
import 'package:http/http.dart' as http;

import 'package:orlove_app/http/constants.dart';
import 'package:orlove_app/storage/storage.dart';
import 'package:orlove_app/utils/utils.dart';

class ProductController {
  static String lastErrorMsg = "";

  static Future<dynamic> getProductAllPictures(id) async {
    String url = HttpConstants.SERVER_HOST +
        HttpConstants.PRODUCT_PATH +
        "/$id/all-pictures";
    final response = await http.get(url);

    if (response.statusCode == 200) {
      return json.decode(response.body)["pictures"];
    } else {
      lastErrorMsg = "Cannot retrieve pictures for product with id=$id";
      return null;
    }
  }

  static Future<List<dynamic>> getProductPerCategory() async {
    String url = HttpConstants.SERVER_HOST +
        HttpConstants.PRODUCT_PATH +
        "/one-per-category";

    var response;
    if (SecureStorage.isLogged) {
      dynamic headers = {
        "Accept": "*/*",
        "Authorization": "${SecureStorage.tokenType} ${SecureStorage.token}",
      };
      response = await http.get(
        url,
        headers: headers,
      );
    } else {
      response = await http.get(url);
    }

    if (response.statusCode == 200) {
      var responseBody = json.decode(response.body);

      for (dynamic productJson in responseBody["elems"]) {
        var productPictures =
            await getProductAllPictures(productJson["product"]["id"]);
        if (productPictures == null) {
          return null;
        }

        productJson["product"]["picture"] = productPictures[0];
      }

      return responseBody["elems"];
    } else {
      lastErrorMsg = "Cannot retrieve data for products per each category";
      return null;
    }
  }

  static Future<List<dynamic>> getProductsForCategory(
      {String category,
      int limit: 5,
      bool isAll: false,
      int groupNum: 0}) async {
    String url = isAll
        ? (HttpConstants.SERVER_HOST +
            HttpConstants.PRODUCT_PATH +
            "?category=$category")
        : (HttpConstants.SERVER_HOST +
            HttpConstants.PRODUCT_PATH +
            "?limit=$limit&category=$category");

    if (groupNum != 0) {
      url += "&group-num=$groupNum";
    }

    var response;
    if (SecureStorage.isLogged) {
      dynamic headers = {
        "Accept": "*/*",
        "Authorization": "${SecureStorage.tokenType} ${SecureStorage.token}",
      };
      response = await http.get(
        url,
        headers: headers,
      );
    } else {
      response = await http.get(url);
    }

    if (response.statusCode != 200) {
      lastErrorMsg = "Cannot get products for category $category";
      return null;
    }

    var responseBody = json.decode(response.body);
    for (dynamic productJson in responseBody["products"]) {
      final productPictures = await getProductAllPictures(productJson["id"]);
      if (productPictures == null) {
        return null;
      }

      productJson["picture"] = productPictures[0];
    }

    return responseBody["products"];
  }

  static Future<dynamic> getProductInfoById(id) async {
    String url =
        HttpConstants.SERVER_HOST + HttpConstants.PRODUCT_PATH + "/$id";

    var response;
    if (SecureStorage.isLogged) {
      dynamic headers = {
        "Accept": "*/*",
        "Authorization": "${SecureStorage.tokenType} ${SecureStorage.token}",
      };
      response = await http.get(
        url,
        headers: headers,
      );
    } else {
      response = await http.get(url);
    }

    if (response.statusCode != 200) {
      lastErrorMsg = "Cannot retrieve info for product with id=$id";
      return null;
    }

    final responseBody = json.decode(response.body);
    final pics = await getProductAllPictures(id);
    if (pics == null) {
      return null;
    }

    responseBody["pictures"] = pics;
    return responseBody;
  }

  static Future<bool> addProductToFavourite(id) async {
    String url = HttpConstants.SERVER_HOST +
        HttpConstants.PRODUCT_PATH +
        "/add-to-favourite?productId=$id";

    dynamic headers = HttpConstants.DEFAULT_REQUEST_HEADERS;
    headers["Authorization"] =
        "${SecureStorage.tokenType} ${SecureStorage.token}";

    final response = await http.post(
      url,
      headers: headers,
    );

    if (response.statusCode != 200) {
      lastErrorMsg = "Cannot add product with id=$id to favourite";
      return false;
    }

    await Utils.addProductToLocalFavourites(id);
    return true;
  }

  static Future<bool> removeProductFromFavourite(id) async {
    String url = HttpConstants.SERVER_HOST +
        HttpConstants.PRODUCT_PATH +
        "/remove-from-favourite?productId=$id";

    dynamic headers = HttpConstants.DEFAULT_REQUEST_HEADERS;
    headers["Authorization"] =
        "${SecureStorage.tokenType} ${SecureStorage.token}";

    final response = await http.post(
      url,
      headers: headers,
    );

    if (response.statusCode != 200) {
      lastErrorMsg = "Cannot remove product with id=$id from favourite";
      return false;
    }

    Utils.removeProductFromLocalFavourites(id);
    return true;
  }

  static Future<List<dynamic>> getAllFavourites() async {
    String url = HttpConstants.SERVER_HOST +
        HttpConstants.PRODUCT_PATH +
        "/all-favourite";

    var response;
    if (SecureStorage.isLogged) {
      dynamic headers = {
        "Accept": "*/*",
        "Authorization": "${SecureStorage.tokenType} ${SecureStorage.token}",
      };
      response = await http.get(
        url,
        headers: headers,
      );
    } else {
      response = await http.get(url);
    }

    if (response.statusCode != 200) {
      lastErrorMsg = "Cannot get all favourite products for current user";
      return [];
    }

    var responseBody = json.decode(response.body);
    for (dynamic prInfo in responseBody) {
      final pics = await getProductAllPictures(prInfo["id"]);
      if (pics == null) {
        lastErrorMsg =
            "Cannot get pictures for product with id=${prInfo["id"]}";
        return [];
      }

      prInfo["pictures"] = pics;
    }

    return responseBody;
  }
}