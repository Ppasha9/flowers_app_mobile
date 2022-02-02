import 'dart:async';
import 'dart:convert';

import 'package:flutter/material.dart';

import 'package:orlove_app/http/auth_controller.dart';
import 'package:orlove_app/storage/storage.dart';

class Utils {
  static String fromUTF8(String strToDecode) {
    return utf8.decode(strToDecode.toString().codeUnits);
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

  static String getMonthStringFromNumber(int monthNumber) {
    switch (monthNumber) {
      case 1:
        return "января";
      case 2:
        return "февраля";
      case 3:
        return "матра";
      case 4:
        return "апреля";
      case 5:
        return "мая";
      case 6:
        return "июня";
      case 7:
        return "июля";
      case 8:
        return "августа";
      case 9:
        return "сентября";
      case 10:
        return "октября";
      case 11:
        return "ноября";
      case 12:
        return "декабря";
    }
  }
}
