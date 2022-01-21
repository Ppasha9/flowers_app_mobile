import 'package:bottom_loader/bottom_loader.dart';
import 'package:flutter/material.dart';
import 'package:orlove_app/constants.dart';
import 'package:orlove_app/http/cart_controller.dart';
import 'package:orlove_app/screens/components/bottom_loader.dart';
import 'package:orlove_app/storage/storage.dart';
import 'package:orlove_app/utils/utils.dart';
import 'cart_card.dart';

class ProductCardInCartCard extends StatefulWidget {
  final int productIndexInCartArray;
  final CartCardState parentState;
  final CartIconWidgetState cartIconState;

  const ProductCardInCartCard(
      {this.productIndexInCartArray, this.parentState, this.cartIconState});

  @override
  _ProductCardInCartCardState createState() => _ProductCardInCartCardState();
}

class _ProductCardInCartCardState extends State<ProductCardInCartCard> {
  BottomLoader bottomLoader;
  dynamic productInfo;

  Future _addProductToCart() async {
    if (!bottomLoader.isShowing()) {
      bottomLoader.display();
    }

    await CartController.addProductToCart(
      productInfo["info"]["id"],
      productInfo["parameters"],
    );
    await Utils.getAllCartInfo();

    if (bottomLoader.isShowing()) {
      bottomLoader.close();
    }

    widget.parentState.setState(() {});
    widget.cartIconState.setState(() {});
  }

  Future _removeProductFromCart() async {
    if (!bottomLoader.isShowing()) {
      bottomLoader.display();
    }

    await CartController.removeProductFromCart(
      productInfo["info"]["id"],
      productInfo["parameters"],
    );
    await Utils.getAllCartInfo();

    if (bottomLoader.isShowing()) {
      bottomLoader.close();
    }

    widget.parentState.setState(() {});
    widget.cartIconState.setState(() {});
  }

  Future _deleteProductFromCart() async {
    if (!bottomLoader.isShowing()) {
      bottomLoader.display();
    }

    await CartController.permanentlyDeleteProductFromCart(
      productInfo["info"]["id"],
      productInfo["parameters"],
    );
    await Utils.getAllCartInfo();

    if (bottomLoader.isShowing()) {
      bottomLoader.close();
    }

    widget.parentState.setState(() {});
    widget.cartIconState.setState(() {});
  }

  num _getProductPriceWithParameters() {
    num res = productInfo["info"]["price"];
    var parameters = productInfo["parameters"] != null
        ? (productInfo["parameters"] as List)
        : [];
    for (dynamic param in parameters) {
      if (param["parameterPrice"] != null) {
        res += param["parameterPrice"];
      }
    }

    return res.round();
  }

  @override
  Widget build(BuildContext context) {
    bottomLoader = getBottomLoader(context);
    productInfo = SecureStorage.cartFullInfo["allProducts"]["products"]
        [widget.productIndexInCartArray];
    final mediaQuery = MediaQuery.of(context);

    return Container(
      width: mediaQuery.size.width * 0.90,
      height: mediaQuery.size.height / 6,
      margin: const EdgeInsets.symmetric(
        horizontal: 10.0,
        vertical: 5.0,
      ),
      decoration: BoxDecoration(
        border: Border.all(
          color: ProjectConstants.DEFAULT_STROKE_COLOR,
        ),
      ),
      child: LayoutBuilder(
        builder: (ctx, constraints) {
          return Row(
            children: [
              Container(
                width: constraints.maxWidth * 0.35,
                padding: const EdgeInsets.only(
                  left: 5.0,
                  top: 5.0,
                  bottom: 5.0,
                ),
                child: Container(
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.all(
                      Radius.circular(8.0),
                    ),
                    image: DecorationImage(
                      image: NetworkImage(
                        productInfo["info"]["pictures"][0]["url"],
                      ),
                      fit: BoxFit.fill,
                    ),
                  ),
                ),
              ),
              Container(
                width: constraints.maxWidth * 0.65,
                padding: const EdgeInsets.only(
                  left: 5.0,
                  top: 10.0,
                  bottom: 10.0,
                ),
                child: Material(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Container(
                        padding: const EdgeInsets.only(
                          right: 5.0,
                        ),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              "${Utils.fromUTF8(productInfo["info"]["name"])}\n${Utils.getPriceCorrectString(_getProductPriceWithParameters())} Руб.",
                              style: TextStyle(
                                fontSize: 13 * mediaQuery.textScaleFactor,
                                fontFamily: ProjectConstants.APP_FONT_FAMILY,
                                fontWeight: FontWeight.w600,
                                color: ProjectConstants.APP_FONT_COLOR,
                                decoration: TextDecoration.none,
                              ),
                            ),
                            GestureDetector(
                              onTap: _deleteProductFromCart,
                              child: Icon(
                                Icons.delete_forever,
                                color: ProjectConstants.APP_FONT_COLOR,
                              ),
                            ),
                          ],
                        ),
                      ),
                      Container(
                        padding: const EdgeInsets.only(
                          right: 5.0,
                        ),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              "Кол-во:",
                              style: TextStyle(
                                fontSize: 13 * mediaQuery.textScaleFactor,
                                fontFamily: ProjectConstants.APP_FONT_FAMILY,
                                fontWeight: FontWeight.normal,
                                color: ProjectConstants.APP_FONT_COLOR,
                                decoration: TextDecoration.none,
                              ),
                            ),
                            Container(
                              decoration: BoxDecoration(
                                border: Border.all(
                                  color: ProjectConstants.DEFAULT_STROKE_COLOR,
                                ),
                                color: Colors.grey.shade100,
                              ),
                              width: constraints.maxWidth * 0.20,
                              child: LayoutBuilder(
                                builder: (_, rowConstraints) {
                                  return Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    children: [
                                      GestureDetector(
                                        onTap: _removeProductFromCart,
                                        child: Container(
                                          width: rowConstraints.maxWidth * 0.33,
                                          decoration: BoxDecoration(
                                            border: Border.all(
                                              color: ProjectConstants
                                                  .DEFAULT_STROKE_COLOR,
                                            ),
                                            color: Colors.white,
                                          ),
                                          child: Center(
                                            child: Text(
                                              "-",
                                              style: TextStyle(
                                                fontSize: 26 *
                                                    mediaQuery.textScaleFactor,
                                                fontFamily: ProjectConstants
                                                    .APP_FONT_FAMILY,
                                                fontWeight: FontWeight.normal,
                                                color: ProjectConstants
                                                    .APP_FONT_COLOR,
                                                decoration: TextDecoration.none,
                                              ),
                                            ),
                                          ),
                                        ),
                                      ),
                                      Container(
                                        width: rowConstraints.maxWidth * 0.3,
                                        child: Center(
                                          child: Text(
                                            productInfo["amount"].toString(),
                                            style: TextStyle(
                                              fontSize: 16 *
                                                  mediaQuery.textScaleFactor,
                                              fontFamily: ProjectConstants
                                                  .APP_FONT_FAMILY,
                                              fontWeight: FontWeight.w600,
                                              color: ProjectConstants
                                                  .APP_FONT_COLOR,
                                              decoration: TextDecoration.none,
                                            ),
                                          ),
                                        ),
                                      ),
                                      GestureDetector(
                                        onTap: _addProductToCart,
                                        child: Container(
                                          width: rowConstraints.maxWidth * 0.33,
                                          decoration: BoxDecoration(
                                            border: Border.all(
                                              color: ProjectConstants
                                                  .DEFAULT_STROKE_COLOR,
                                            ),
                                            color: Colors.white,
                                          ),
                                          child: Center(
                                            child: Text(
                                              "+",
                                              style: TextStyle(
                                                fontSize: 26 *
                                                    mediaQuery.textScaleFactor,
                                                fontFamily: ProjectConstants
                                                    .APP_FONT_FAMILY,
                                                fontWeight: FontWeight.normal,
                                                color: ProjectConstants
                                                    .APP_FONT_COLOR,
                                                decoration: TextDecoration.none,
                                              ),
                                            ),
                                          ),
                                        ),
                                      ),
                                    ],
                                  );
                                },
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          );
        },
      ),
    );
  }
}
