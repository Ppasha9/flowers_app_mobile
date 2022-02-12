import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

import 'package:orlove_app/http/constants.dart';
import 'package:orlove_app/utils/utils.dart';

class CompilationCuttedFormDRO {
  final int id;
  final String name;
  final String picFilename;
  final String picUrl;

  const CompilationCuttedFormDRO({
    @required this.id,
    @required this.name,
    @required this.picFilename,
    @required this.picUrl,
  });

  factory CompilationCuttedFormDRO.fromJson(Map<String, dynamic> jsonData) {
    return CompilationCuttedFormDRO(
      id: jsonData["id"],
      name: Utils.fromUTF8(jsonData["name"]),
      picFilename: Utils.fromUTF8(jsonData["picFilename"]),
      picUrl: Utils.fromUTF8(jsonData["picUrl"]),
    );
  }
}

class CompilationController {
  static String lastErrorMsg = "";

  static Future<List<CompilationCuttedFormDRO>>
      getAllCompilationsCuttedForms() async {
    String url =
        HttpConstants.SERVER_HOST + HttpConstants.COMPILATION_PATH + "/all";
    final response = await http.get(url);

    if (response.statusCode != 200) {
      lastErrorMsg = "Cannot get all compilation info in cutted forms";
      return null;
    }

    List<CompilationCuttedFormDRO> res = [];
    List<dynamic> resBody = json.decode(response.body);
    resBody.forEach((el) {
      res.add(CompilationCuttedFormDRO.fromJson(el));
    });

    return res;
  }
}
