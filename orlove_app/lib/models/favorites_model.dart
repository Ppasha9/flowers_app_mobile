import 'package:flutter/material.dart';
import 'package:orlove_app/http/product_controller.dart';
import 'package:orlove_app/storage/storage.dart';

class FavoritesModel extends ChangeNotifier {
  bool isInited = false;
  List<dynamic> _favProducts = [];
  List<num> _indices = [];

  Future init() async {
    _favProducts = await ProductController.getAllFavourites();
    for (dynamic pr in _favProducts) {
      _indices.add(pr["id"]);
    }
    isInited = true;
  }

  Future<bool> isFavorite(num productId) async {
    if (!SecureStorage.isLogged) {
      return false;
    }

    if (!isInited) {
      await init();
    }

    return _indices.contains(productId);
  }

  Future addNewFavorite(num productId) async {
    if (!SecureStorage.isLogged) {
      return;
    }

    if (!isInited) {
      await init();
    }

    bool isFavoriteProduct = await isFavorite(productId);
    if (!isFavoriteProduct) {
      await ProductController.addProductToFavourite(productId);
      dynamic prInfo = await ProductController.getProductInfoById(productId);
      _favProducts.add(prInfo);
      _indices.add(productId);
      notifyListeners();
    }
  }

  Future removeFavorite(num productId) async {
    if (!SecureStorage.isLogged) {
      return;
    }

    if (!isInited) {
      await init();
    }

    bool isFavoriteProduct = await isFavorite(productId);
    if (isFavoriteProduct) {
      int indToRemove = 0;
      for (int i = 0; i < _favProducts.length; i++) {
        if (_favProducts[i]["id"] == productId) {
          indToRemove = i;
          break;
        }
      }

      await ProductController.removeProductFromFavourite(productId);
      _indices.remove(productId);
      _favProducts.removeAt(indToRemove);
      notifyListeners();
    }
  }

  Future<List<dynamic>> getProducts() async {
    if (!SecureStorage.isLogged) {
      return [];
    }

    if (!isInited) {
      await init();
    }

    return _favProducts;
  }
}
