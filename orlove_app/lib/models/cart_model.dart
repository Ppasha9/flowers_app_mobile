import 'package:flutter/material.dart';
import 'package:orlove_app/http/cart_controller.dart';
import 'package:orlove_app/storage/storage.dart';
import 'package:orlove_app/utils/utils.dart';

class ProductParameterDTO {
  final String parameterName;
  final String parameterValue;
  final num parameterPrice;

  ProductParameterDTO({
    @required this.parameterName,
    @required this.parameterValue,
    @required this.parameterPrice,
  });

  dynamic toJson() {
    return {
      "parameterName": parameterName,
      "parameterValue": parameterValue,
      "parameterPrice": parameterPrice.toString(),
    };
  }
}

class ProductInCartDTO {
  dynamic info;
  num amount;
  List<ProductParameterDTO> parameters;

  ProductInCartDTO();
}

class CartFullInfoDTO {
  num price;
  String status;
  String receiverName;
  String receiverPhone;
  String receiverEmail;
  String receiverSurname;
  String receiverStreet;
  String receiverHouseNum;
  String receiverApartmentNum;
  String deliveryComment;
  String deliveryMethod;
  String paymentMethod;
  DateTime deliveryDate;
  List<ProductInCartDTO> products = [];

  CartFullInfoDTO();

  factory CartFullInfoDTO.fromJson(Map<String, dynamic> data) {
    CartFullInfoDTO res = new CartFullInfoDTO();

    if (data == null) {
      return res;
    }

    res.price = data["price"];
    res.status = data["status"];
    res.receiverName = Utils.fromUTF8(data["receiverName"]);
    res.receiverPhone = data["receiverPhone"];
    res.receiverEmail = data["receiverEmail"];
    res.receiverSurname = Utils.fromUTF8(data["receiverSurname"]);
    res.receiverStreet = Utils.fromUTF8(data["receiverStreet"]);
    res.receiverHouseNum = data["receiverHouseNum"];
    res.receiverApartmentNum = data["receiverApartmentNum"];
    res.deliveryComment = Utils.fromUTF8(data["deliveryComment"]);
    res.deliveryMethod = data["deliveryMethod"];
    res.paymentMethod = data["paymentMethod"];
    if (data["deliveryDate"] != null) {
      res.deliveryDate = DateTime.parse(data["deliveryDate"]);
    } else {
      res.deliveryDate = null;
    }

    if (data["allProducts"] != null) {
      if (data["allProducts"]["products"] != null) {
        (data["allProducts"]["products"] as List).forEach((el) {
          ProductInCartDTO prToAdd = ProductInCartDTO();
          prToAdd.info = el["info"];
          prToAdd.amount = el["amount"];
          prToAdd.parameters = [];

          if (el["parameters"] != null) {
            (el["parameters"] as List).forEach((prEl) {
              prToAdd.parameters.add(ProductParameterDTO(
                parameterName: Utils.fromUTF8(prEl["parameterName"]),
                parameterValue: Utils.fromUTF8(prEl["parameterValue"]),
                parameterPrice: prEl["parameterPrice"],
              ));
            });
          }

          res.products.add(prToAdd);
        });
      }
    }

    return res;
  }
}

class CartModel extends ChangeNotifier {
  bool isInited = false;
  CartFullInfoDTO cartFullInfo;

  Future init() async {
    dynamic cartFullInfoDynamic = await CartController.getCartFullInfo();
    cartFullInfo = CartFullInfoDTO.fromJson(cartFullInfoDynamic);
    isInited = true;
  }

  Future updateCartFullInfo() async {
    if (!SecureStorage.isLogged) {
      return;
    }

    if (!isInited) {
      await init();
    }

    dynamic cartFullInfoDynamic = await CartController.getCartFullInfo();
    cartFullInfo = CartFullInfoDTO.fromJson(cartFullInfoDynamic);
    notifyListeners();
  }

  Future<CartFullInfoDTO> getCartFullInfo() async {
    if (!SecureStorage.isLogged) {
      return null;
    }

    if (!isInited) {
      await init();
    }

    return cartFullInfo;
  }
}
