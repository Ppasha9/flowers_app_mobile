import 'dart:async';
import 'dart:convert';

import 'package:flutter/material.dart';

import 'package:orlove_app/http/auth_controller.dart';
import 'package:orlove_app/http/cart_controller.dart';
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

  static String getPriceCorrectString(int price) {
    String res = "";

    while (price > 0) {
      int tmp = price % 1000;
      price = price ~/ 1000;

      String tmpString = "$tmp";
      if (price > 0) {
        if (tmp < 10) {
          tmpString = "00" + tmpString;
        } else if (tmp < 100) {
          tmpString = "0" + tmpString;
        }
      }

      res = tmpString + res;
      if (price > 0) {
        res = " " + res;
      }
    }

    return res;
  }
}
