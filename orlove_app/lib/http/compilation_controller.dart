import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

import 'package:orlove_app/http/constants.dart';
import 'package:orlove_app/utils/utils.dart';

class CompilationCuttedFormDTO {
  final int id;
  final String name;
  final String picFilename;
  final String picUrl;

  const CompilationCuttedFormDTO({
    @required this.id,
    @required this.name,
    @required this.picFilename,
    @required this.picUrl,
  });

  factory CompilationCuttedFormDTO.fromJson(Map<String, dynamic> jsonData) {
    return CompilationCuttedFormDTO(
      id: jsonData["id"],
      name: Utils.fromUTF8(jsonData["name"]),
      picFilename: Utils.fromUTF8(jsonData["picFilename"]),
      picUrl: Utils.fromUTF8(jsonData["picUrl"]),
    );
  }
}

class ProductInCompilationCuttedFormDTO {
  final int id;
  final String name;
  final num price;
  final String picUrl;

  const ProductInCompilationCuttedFormDTO({
    @required this.id,
    @required this.name,
    @required this.price,
    @required this.picUrl,
  });
}

class CompilationFullInfoFormDTO {
  final int id;
  final String name;
  final String picFilename;
  final String picUrl;
  final List<ProductInCompilationCuttedFormDTO> products;

  const CompilationFullInfoFormDTO({
    @required this.id,
    @required this.name,
    @required this.picFilename,
    @required this.picUrl,
    @required this.products,
  });

  factory CompilationFullInfoFormDTO.fromJson(Map<String, dynamic> jsonData) {
    List<ProductInCompilationCuttedFormDTO> products = [];
    List<dynamic> jsonProducts =
        jsonData["products"] != null ? (jsonData["products"] as List) : [];
    jsonProducts.forEach((jsonPr) {
      products.add(ProductInCompilationCuttedFormDTO(
        id: jsonPr["id"],
        name: jsonPr["name"],
        price: jsonPr["price"],
        picUrl: jsonPr["picUrl"],
      ));
    });

    return CompilationFullInfoFormDTO(
      id: jsonData["id"],
      name: Utils.fromUTF8(jsonData["name"]),
      picFilename: Utils.fromUTF8(jsonData["picFilename"]),
      picUrl: Utils.fromUTF8(jsonData["picUrl"]),
      products: products,
    );
  }
}

class CompilationController {
  static String lastErrorMsg = "";

  static Future<List<CompilationCuttedFormDTO>>
      getAllCompilationsCuttedForms() async {
    String url =
        HttpConstants.SERVER_HOST + HttpConstants.COMPILATION_PATH + "/all";
    final response = await http.get(url);

    if (response.statusCode != 200) {
      lastErrorMsg = "Cannot get all compilation info in cutted forms";
      return null;
    }

    List<CompilationCuttedFormDTO> res = [];
    List<dynamic> resBody = json.decode(response.body);
    resBody.forEach((el) {
      res.add(CompilationCuttedFormDTO.fromJson(el));
    });

    return res;
  }

  static Future<CompilationFullInfoFormDTO> getCompilationFullInfo(
      compilationId) async {
    String url = HttpConstants.SERVER_HOST +
        HttpConstants.COMPILATION_PATH +
        "/full-info/${compilationId}";
    final response = await http.get(url);

    if (response.statusCode != 200) {
      lastErrorMsg =
          "Cannot get compilation full info with id ${compilationId}";
      return null;
    }

    return CompilationFullInfoFormDTO.fromJson(json.decode(response.body));
  }
}
