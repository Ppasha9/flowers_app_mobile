import 'dart:async';
import 'dart:convert';

import 'package:flutter/material.dart';

import 'package:orlove_app/http/auth_controller.dart';
import 'package:orlove_app/http/cart_controller.dart';
import 'package:orlove_app/http/product_controller.dart';
import 'package:orlove_app/storage/storage.dart';

class Utils {
  static String fromUTF8(String strToDecode) {
    return utf8.decode(strToDecode.toString().codeUnits);
  }

  static Future getAllCartInfo() async {
    if (!SecureStorage.isLogged) {
      return;
    }

    SecureStorage.cartFullInfo = await CartController.getCartFullInfo();
  }

  static Future updateUserInfo() async {
    dynamic userInfo = await AuthController.getUserInfo();
    SecureStorage.email = userInfo["email"];
    SecureStorage.name = userInfo["name"];
    SecureStorage.surname = userInfo["surname"];
    SecureStorage.phone = userInfo["phone"];
  }

  static Future getAllFavourites() async {
    if (!SecureStorage.isLogged) {
      return;
    }

    SecureStorage.listOfFavourites = await ProductController.getAllFavourites();
  }

  static void removeProductFromLocalFavourites(id) {
    if (!isProductFavouriteById(id)) {
      return;
    }

    int idxToRemove = -1;

    for (int i = 0; i < SecureStorage.listOfFavourites.length; i++) {
      dynamic prInfo = SecureStorage.listOfFavourites[i];
      if (prInfo["id"] == id) {
        idxToRemove = i;
        break;
      }
    }

    if (idxToRemove != -1) {
      SecureStorage.listOfFavourites.removeAt(idxToRemove);
    }
  }

  static Future addProductToLocalFavourites(id) async {
    if (isProductFavouriteById(id)) {
      return;
    }

    dynamic prInfo = await ProductController.getProductInfoById(id);
    if (prInfo == null) {
      return;
    }

    SecureStorage.listOfFavourites.add(prInfo);
  }

  static bool isProductFavouriteById(id) {
    if (!SecureStorage.isLogged) {
      return false;
    }

    for (dynamic prInfo in SecureStorage.listOfFavourites) {
      if (prInfo["id"] == id) {
        return true;
      }
    }

    return false;
  }

  static Color getStatusColor(String status) {
    if (status == "Forming") {
      return Colors.blueAccent;
    }
  }

  static String getStatusText(String status) {
    if (status == "Forming") {
      return "Формируется";
    }
  }
}
