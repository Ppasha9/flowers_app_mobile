import 'package:flutter/material.dart';
import 'package:orlove_app/constants.dart';
import 'package:orlove_app/models/favorites_model.dart';
import 'package:orlove_app/screens/components/app_bar.dart';
import 'package:orlove_app/screens/components/bottom_navigation_bar.dart';
import 'package:orlove_app/screens/products_by_category/products_by_category_screen_components.dart';
import 'package:orlove_app/storage/storage.dart';
import 'package:provider/provider.dart';

class FavouriteScreen extends StatefulWidget {
  @override
  _FavouriteScreenState createState() => _FavouriteScreenState();
}

class _FavouriteScreenState extends State<FavouriteScreen> {
  List<dynamic> products = null;

  Widget _getBodyWidget(BuildContext context) {
    MediaQueryData mediaQuery = MediaQuery.of(context);

    if (!SecureStorage.isLogged) {
      return Center(
        child: Text(
          "Сначала войдите в аккаунт или зарегистрируйтесь",
          textAlign: TextAlign.center,
          style: TextStyle(
            fontSize: 16 * mediaQuery.textScaleFactor,
            fontFamily: ProjectConstants.APP_FONT_FAMILY,
            fontWeight: FontWeight.w600,
            color: ProjectConstants.APP_FONT_COLOR,
            decoration: TextDecoration.none,
          ),
        ),
      );
    }

    FavoritesModel favoritesModel = context.watch<FavoritesModel>();
    if (products == null) {
      favoritesModel.getProducts().then((value) {
        setState(() {
          products = value;
        });
      });
      return Center(
        child: CircularProgressIndicator(),
      );
    }

    if (products.isEmpty) {
      return Center(
        child: Text(
          "Здесь пока пусто",
          textAlign: TextAlign.center,
          style: TextStyle(
            fontSize: 16 * mediaQuery.textScaleFactor,
            fontFamily: ProjectConstants.APP_FONT_FAMILY,
            fontWeight: FontWeight.w600,
            color: ProjectConstants.APP_FONT_COLOR,
            decoration: TextDecoration.none,
          ),
        ),
      );
    }

    return Container(
      margin: const EdgeInsets.only(
        top: 20.0,
      ),
      height: mediaQuery.size.height,
      width: mediaQuery.size.width,
      child: ListView.builder(
        scrollDirection: Axis.vertical,
        itemCount: (products.length / 2).round(),
        itemBuilder: (_, index) => ProductsRowInGridComponent(
          leftPrJson: products[2 * index],
          rightPrJson: (2 * index + 1 < products.length)
              ? products[2 * index + 1]
              : null,
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: ProjectConstants.BACKGROUND_SCREEN_COLOR,
      body: _getBodyWidget(context),
      appBar: getAppBar(context),
      bottomNavigationBar: getBottomNavigationBar(
        context,
        isFavourite: true,
      ),
    );
  }
}
