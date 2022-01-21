import 'dart:convert';

import 'package:bottom_loader/bottom_loader.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:orlove_app/constants.dart';
import 'package:orlove_app/http/cart_controller.dart';
import 'package:orlove_app/http/product_controller.dart';
import 'package:orlove_app/screens/components/app_bar.dart';
import 'package:orlove_app/screens/components/bottom_loader.dart';
import 'package:orlove_app/screens/components/bottom_navigation_bar.dart';
import 'package:orlove_app/screens/components/social_buttons.dart';
import 'package:orlove_app/screens/one_click/one_click_screen.dart';
import 'package:orlove_app/screens/product/product_screen_components.dart';
import 'package:orlove_app/screens/signin/signin_screen.dart';
import 'package:orlove_app/storage/storage.dart';
import 'package:orlove_app/utils/utils.dart';

class ProductScreen extends StatefulWidget {
  final int id;

  const ProductScreen({this.id});

  @override
  ProductScreenState createState() => ProductScreenState();
}

class ProductScreenState extends State<ProductScreen> {
  BottomLoader bottomLoader;

  bool isLoading = true;
  dynamic productInfo;

  dynamic parametersPrices = {};

  @override
  void initState() {
    super.initState();
    ProductController.getProductInfoById(widget.id).then(
      (prInfo) {
        productInfo = prInfo;
        (productInfo["parameters"] as List)?.forEach((e) {
          parametersPrices[e["name"]] = e["value"];
        });

        setState(() {
          isLoading = false;
        });
      },
    );
  }

  num _getParamPriceByNameAndValue(String name, String value) {
    num res = 0.0;
    (productInfo["parameters"] as List)?.forEach((param) {
      if (param["name"] == name && param["value"] == value) {
        res = param["price"];
      }
    });

    return res;
  }

  Future _addProductToCart() async {
    if (!bottomLoader.isShowing()) {
      bottomLoader.display();
    }

    List<dynamic> params = [];
    Map<String, String> parametersPricesAsJson =
        Map<String, String>.from(parametersPrices);
    (parametersPricesAsJson as Map<String, String>)?.forEach((key, value) {
      params.add(
        {
          "parameterName": Utils.fromUTF8(key),
          "parameterValue": Utils.fromUTF8(value),
          "parameterPrice": _getParamPriceByNameAndValue(key, value),
        },
      );
    });

    await CartController.addProductToCart(widget.id, params);
    await Utils.getAllCartInfo();

    if (bottomLoader.isShowing()) {
      bottomLoader.close();
    }
  }

  Widget _getAddCartButton(BuildContext context) {
    final mediaQuery = MediaQuery.of(context);

    List<Widget> children = [];

    children.add(
      GestureDetector(
        onTap: SecureStorage.isLogged
            ? _addProductToCart
            : () {
                Navigator.push(
                  context,
                  CupertinoPageRoute(
                    builder: (_) => SignInScreen(),
                  ),
                );
              },
        child: Container(
          height: 50,
          width: mediaQuery.size.width / 2.3,
          margin: const EdgeInsets.symmetric(
            horizontal: 8.0,
          ),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.all(Radius.circular(1.0)),
            color: ProjectConstants.BUTTON_BACKGROUND_COLOR,
          ),
          child: Center(
            child: Text(
              SecureStorage.isLogged ? "Добавить в корзину" : "Войти",
              style: TextStyle(
                fontSize: 14 * mediaQuery.textScaleFactor,
                fontFamily: ProjectConstants.APP_FONT_FAMILY,
                color: ProjectConstants.BUTTON_TEXT_COLOR,
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
        ),
      ),
    );

    children.add(
      GestureDetector(
        onTap: () {
          Navigator.of(context).push(
            CupertinoPageRoute(
              builder: (_) => OneClickScreen(
                productId: widget.id,
              ),
            ),
          );
        },
        child: Container(
          height: 50,
          width: mediaQuery.size.width / 2.3,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.all(Radius.circular(1.0)),
            color: ProjectConstants.BUTTON_BACKGROUND_COLOR,
          ),
          child: Center(
            child: Text(
              "Купить в 1 клик",
              style: TextStyle(
                fontSize: 14 * mediaQuery.textScaleFactor,
                fontFamily: ProjectConstants.APP_FONT_FAMILY,
                color: ProjectConstants.BUTTON_TEXT_COLOR,
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
        ),
      ),
    );

    return Center(
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: children,
      ),
    );

    /*
    return GestureDetector(
      onTap: _addProductToCart,
      child: Center(
        child: Container(
          height: 50,
          width: mediaQuery.size.width / 1.3,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.all(Radius.circular(1.0)),
            color: ProjectConstants.BUTTON_BACKGROUND_COLOR,
          ),
          child: Center(
            child: Text(
              isAddedToCart ? "Уже в корзине" : "Добавить в корзину",
              style: TextStyle(
                fontSize: 18 * mediaQuery.textScaleFactor,
                fontFamily: ProjectConstants.APP_FONT_FAMILY,
                color: ProjectConstants.BUTTON_TEXT_COLOR,
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
        ),
      ),
    );
    */
  }

  int _getParameterPrice(
    String paramName,
    String paramValue,
    dynamic parameters,
  ) {
    int res = 0;
    (parameters as List)?.forEach((param) {
      if (param["name"] == paramName && param["value"] == paramValue) {
        res = param["price"].round();
      }
    });

    return res;
  }

  Widget _getParametersWidget(MediaQueryData mediaQuery, dynamic parameters) {
    if (parameters == null) {
      return Container();
    }

    Map<String, dynamic> paramsNameToValues = new Map<String, dynamic>();
    (parameters as List)?.forEach((item) {
      if (paramsNameToValues.containsKey(item["name"])) {
        paramsNameToValues[item["name"]].add(
          {
            "value": item["value"],
            "price": item["price"],
          },
        );
      } else {
        paramsNameToValues[item["name"]] = <dynamic>[
          {
            "value": item["value"],
            "price": item["price"],
          },
        ];
      }
    });

    print(paramsNameToValues);
    print(paramsNameToValues.length);

    List<Widget> children = [];
    paramsNameToValues.forEach((key, value) {
      List<DropdownMenuItem<String>> menuItems = [];
      (value as List)?.forEach((v) {
        menuItems.add(
          DropdownMenuItem<String>(
            value: Utils.fromUTF8(v["value"]),
            child: Text(
              Utils.fromUTF8(v["value"]),
              textAlign: TextAlign.justify,
              style: TextStyle(
                fontSize: 16 * mediaQuery.textScaleFactor,
                fontFamily: ProjectConstants.APP_FONT_FAMILY,
                color: ProjectConstants.APP_FONT_COLOR,
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
        );
      });

      children.add(
        Container(
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                Utils.fromUTF8(key),
                textAlign: TextAlign.justify,
                style: TextStyle(
                  fontSize: 16 * mediaQuery.textScaleFactor,
                  fontFamily: ProjectConstants.APP_FONT_FAMILY,
                  color: ProjectConstants.APP_FONT_COLOR,
                  fontWeight: FontWeight.bold,
                ),
              ),
              SizedBox(
                width: 10.0,
              ),
              Row(
                children: [
                  DropdownButtonHideUnderline(
                    child: Container(
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(5.0),
                        border: Border.all(color: Colors.black, width: 0.1),
                      ),
                      padding: EdgeInsets.symmetric(
                        vertical: 5.0,
                        horizontal: 15.0,
                      ),
                      height: 40 * mediaQuery.textScaleFactor,
                      width: mediaQuery.size.width / 3,
                      child: DropdownButton<String>(
                        value: parametersPrices[key] != null
                            ? parametersPrices[key]
                            : "",
                        items: menuItems,
                        onChanged: (v) {
                          setState(() {
                            parametersPrices[key] = v;
                          });
                        },
                      ),
                    ),
                  ),
                  SizedBox(
                    width: 5.0,
                  ),
                  Text(
                    "(+ ${_getParameterPrice(
                      key,
                      parametersPrices[key],
                      parameters,
                    )} Руб.)",
                    style: TextStyle(
                      fontSize: 16 * mediaQuery.textScaleFactor,
                      fontFamily: ProjectConstants.APP_FONT_FAMILY,
                      color: ProjectConstants.DEFAULT_STROKE_COLOR,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      );
    });

    return Container(
      margin: EdgeInsets.only(
        left: 25.0,
        right: 25.0,
      ),
      child: Column(
        children: children,
      ),
    );
  }

  Widget _getBodyWidget(BuildContext context) {
    if (isLoading) {
      return Center(
        child: CircularProgressIndicator(),
      );
    }

    final mediaQuery = MediaQuery.of(context);

    print(productInfo);
    print(parametersPrices);

    return SingleChildScrollView(
      child: Container(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            ProductPicturesCarouselWidget(
              productPics: productInfo["pictures"],
              productInfo: productInfo,
            ),
            SizedBox(
              height: 10.0,
            ),
            Center(
              child: Column(
                children: [
                  Text(
                    "${Utils.fromUTF8(productInfo["name"])}",
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontSize: 24 * mediaQuery.textScaleFactor,
                      fontFamily: ProjectConstants.APP_FONT_FAMILY,
                      color: ProjectConstants.APP_FONT_COLOR,
                    ),
                  ),
                  SizedBox(
                    height: 5.0,
                  ),
                  Text(
                    "${Utils.getPriceCorrectString(productInfo["price"].round())} ₽",
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontSize: 20 * mediaQuery.textScaleFactor,
                      fontFamily: ProjectConstants.APP_FONT_FAMILY,
                      color: ProjectConstants.APP_FONT_COLOR,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ],
              ),
            ),
            SizedBox(
              height: 10.0,
            ),
            Container(
              margin: const EdgeInsets.only(
                left: 10.0,
              ),
              child: Text(
                "Детали",
                style: TextStyle(
                  fontSize: 16 * mediaQuery.textScaleFactor,
                  fontFamily: ProjectConstants.APP_FONT_FAMILY,
                  fontWeight: FontWeight.w600,
                  color: ProjectConstants.APP_FONT_COLOR,
                ),
              ),
            ),
            Container(
              width: mediaQuery.size.width / 1.1,
              margin: const EdgeInsets.only(
                top: 10.0,
                left: 20.0,
              ),
              child: Text(
                Utils.fromUTF8(productInfo["content"]),
                textAlign: TextAlign.justify,
                style: TextStyle(
                  fontSize: 16 * mediaQuery.textScaleFactor,
                  fontFamily: ProjectConstants.APP_FONT_FAMILY,
                  color: ProjectConstants.APP_FONT_COLOR,
                ),
              ),
            ),
            Container(
              margin: const EdgeInsets.only(
                top: 10.0,
                left: 10.0,
              ),
              child: Text(
                "Параметры",
                style: TextStyle(
                  fontSize: 16 * mediaQuery.textScaleFactor,
                  fontFamily: ProjectConstants.APP_FONT_FAMILY,
                  fontWeight: FontWeight.w600,
                  color: ProjectConstants.APP_FONT_COLOR,
                ),
              ),
            ),
            (productInfo["parameters"] as List).length > 0
                ? Column(
                    children: [
                      Container(
                        width: mediaQuery.size.width / 1.1,
                        margin: const EdgeInsets.only(
                          top: 10.0,
                          left: 20.0,
                        ),
                        child: Text(
                          "Пожалуйста, выберите параметры букета перед покупкой.",
                          textAlign: TextAlign.justify,
                          style: TextStyle(
                            fontSize: 16 * mediaQuery.textScaleFactor,
                            fontFamily: ProjectConstants.APP_FONT_FAMILY,
                            color: ProjectConstants.APP_FONT_COLOR,
                          ),
                        ),
                      ),
                      SizedBox(
                        height: 5.0,
                      ),
                      _getParametersWidget(
                          mediaQuery, productInfo["parameters"]),
                    ],
                  )
                : Container(),
            Container(
              margin: const EdgeInsets.only(
                top: 10.0,
                left: 10.0,
                right: 10.0,
              ),
              child: Text(
                "Мы оставляем за собой авторское право определять конечный состав букеты, учитывая сезонность цветов, но обещаем, что букет останется таким же стильным и неповторимым.",
                textAlign: TextAlign.justify,
                style: TextStyle(
                  fontSize: 16 * mediaQuery.textScaleFactor,
                  fontFamily: ProjectConstants.APP_FONT_FAMILY,
                  color: ProjectConstants.APP_FONT_COLOR,
                ),
              ),
            ),
            SizedBox(
              height: 20.0,
            ),
            Container(
              margin: const EdgeInsets.only(
                left: 10.0,
              ),
              child: Text(
                "Есть вопросы?",
                style: TextStyle(
                  fontSize: 16 * mediaQuery.textScaleFactor,
                  fontFamily: ProjectConstants.APP_FONT_FAMILY,
                  fontWeight: FontWeight.w600,
                  color: ProjectConstants.APP_FONT_COLOR,
                ),
              ),
            ),
            SizedBox(
              height: 10.0,
            ),
            SocialButtonsWidget(),
            SizedBox(
              height: 25.0,
            ),
            GestureDetector(
              onTap: () {},
              child: Container(
                margin: const EdgeInsets.symmetric(
                  horizontal: 10.0,
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Divider(
                      height: 3.0,
                      thickness: 1.0,
                    ),
                    SizedBox(
                      height: 15.0,
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          "Подарки к каждому букету",
                          style: TextStyle(
                            color: ProjectConstants.APP_FONT_COLOR,
                            fontFamily: ProjectConstants.APP_FONT_FAMILY,
                            fontSize: 16 * mediaQuery.textScaleFactor,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                        Icon(
                          Icons.arrow_forward_ios_rounded,
                          color: ProjectConstants.APP_FONT_COLOR,
                          size: 16.0,
                        ),
                      ],
                    ),
                    SizedBox(
                      height: 15.0,
                    ),
                    const Divider(
                      height: 3.0,
                      thickness: 1.0,
                    ),
                  ],
                ),
              ),
            ),
            SizedBox(
              height: 25.0,
            ),
            Container(
              margin: const EdgeInsets.only(
                left: 10.0,
              ),
              child: Text(
                "Вам может понравится",
                style: TextStyle(
                  fontSize: 16 * mediaQuery.textScaleFactor,
                  fontFamily: ProjectConstants.APP_FONT_FAMILY,
                  fontWeight: FontWeight.w600,
                  color: ProjectConstants.APP_FONT_COLOR,
                ),
              ),
            ),
            SizedBox(
              height: 40.0,
            ),
            Container(
              margin: const EdgeInsets.only(
                left: 10.0,
              ),
              child: Text(
                "Вы уже смотрели",
                style: TextStyle(
                  fontSize: 16 * mediaQuery.textScaleFactor,
                  fontFamily: ProjectConstants.APP_FONT_FAMILY,
                  fontWeight: FontWeight.w600,
                  color: ProjectConstants.APP_FONT_COLOR,
                ),
              ),
            ),
            SizedBox(
              height: 10.0,
            ),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    bottomLoader = getBottomLoader(context);

    return Scaffold(
      backgroundColor: ProjectConstants.BACKGROUND_SCREEN_COLOR,
      body: _getBodyWidget(context),
      appBar: getAppBar(context),
      bottomNavigationBar: Container(
        height: 163.0,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.end,
          children: [
            Container(
              padding: const EdgeInsets.only(
                top: 10,
                bottom: 10,
              ),
              child: _getAddCartButton(context),
            ),
            getBottomNavigationBar(context),
          ],
        ),
      ),
    );
  }
}
