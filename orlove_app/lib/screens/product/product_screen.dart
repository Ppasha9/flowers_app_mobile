import 'package:bottom_loader/bottom_loader.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:orlove_app/constants.dart';
import 'package:orlove_app/http/cart_controller.dart';
import 'package:orlove_app/http/product_controller.dart';
import 'package:orlove_app/models/cart_model.dart';
import 'package:orlove_app/screens/components/app_bar.dart';
import 'package:orlove_app/screens/components/bottom_loader.dart';
import 'package:orlove_app/screens/components/bottom_navigation_bar.dart';
import 'package:orlove_app/screens/components/social_buttons.dart';
import 'package:orlove_app/screens/one_click/one_click_screen.dart';
import 'package:orlove_app/screens/product/product_screen_components.dart';
import 'package:orlove_app/screens/signin/signin_screen.dart';
import 'package:orlove_app/storage/storage.dart';
import 'package:orlove_app/utils/utils.dart';
import 'package:provider/provider.dart';

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

  dynamic parametersValues = {};
  dynamic parametersInds = {};

  @override
  void initState() {
    super.initState();
    ProductController.getProductInfoById(widget.id).then(
      (prInfo) {
        productInfo = prInfo;
        (productInfo["parameters"] as List)?.forEach((e) {
          if (parametersValues[e["name"]] == null) {
            parametersValues[e["name"]] = e["value"];
          }
          parametersInds[e["name"]] = 0;
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

  Future _addProductToCart(CartModel cartModel) async {
    bool isFailed = false;
    List<ProductParameterDTO> params = [];
    Map<String, String> parametersValuesAsJson =
        Map<String, String>.from(parametersValues);
    (parametersValuesAsJson as Map<String, String>)?.forEach((key, value) {
      if (value == "") {
        isFailed = true;
        Fluttertoast.showToast(
            msg: "Нужно выбрать параметр '${Utils.fromUTF8(key)}'");
        return;
      }

      params.add(
        ProductParameterDTO(
          parameterName: Utils.fromUTF8(key),
          parameterValue: Utils.fromUTF8(value),
          parameterPrice: _getParamPriceByNameAndValue(key, value),
        ),
      );
    });

    if (isFailed) {
      return;
    }

    if (!bottomLoader.isShowing()) {
      bottomLoader.display();
    }

    await CartController.addProductToCart(widget.id, params);
    await cartModel.updateCartFullInfo();

    if (bottomLoader.isShowing()) {
      bottomLoader.close();
    }
  }

  Widget _getAddCartButton(BuildContext context, CartModel cartModel) {
    final mediaQuery = MediaQuery.of(context);

    List<Widget> children = [];

    children.add(
      GestureDetector(
        onTap: SecureStorage.isLogged
            ? () => _addProductToCart(cartModel)
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
  }

  int _getParameterPrice(
    String paramName,
    String paramValue,
    dynamic parameters,
  ) {
    if (paramValue == "") {
      return 0;
    }

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
      List<Widget> pickerChildren = [];
      (value as List)?.forEach((el) {
        pickerChildren.add(
          Text(
            Utils.fromUTF8(el["value"]),
            style: TextStyle(
              fontSize: 16 * mediaQuery.textScaleFactor,
              fontFamily: ProjectConstants.APP_FONT_FAMILY,
              color: ProjectConstants.APP_FONT_COLOR,
              fontWeight: FontWeight.w600,
            ),
          ),
        );
      });

      children.add(
        Container(
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Center(
                child: Text(
                  "${Utils.fromUTF8(key)}:",
                  textAlign: TextAlign.justify,
                  style: TextStyle(
                    fontSize: 16 * mediaQuery.textScaleFactor,
                    fontFamily: ProjectConstants.APP_FONT_FAMILY,
                    color: ProjectConstants.APP_FONT_COLOR,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
              Row(
                children: [
                  GestureDetector(
                    onTap: () {
                      showCupertinoModalPopup(
                        context: context,
                        builder: (context) {
                          return Column(
                            mainAxisAlignment: MainAxisAlignment.end,
                            children: <Widget>[
                              Container(
                                decoration: BoxDecoration(
                                  color: Colors.white,
                                  border: Border(
                                    bottom: BorderSide(
                                      color: Color(0xff999999),
                                      width: 0.0,
                                    ),
                                  ),
                                ),
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.end,
                                  children: <Widget>[
                                    CupertinoButton(
                                      child: Text(
                                        'Выбрать',
                                        style: TextStyle(
                                          fontSize:
                                              14 * mediaQuery.textScaleFactor,
                                          fontFamily:
                                              ProjectConstants.APP_FONT_FAMILY,
                                          color: ProjectConstants
                                              .BUTTON_TEXT_COLOR,
                                          fontWeight: FontWeight.w600,
                                        ),
                                      ),
                                      onPressed: () {
                                        Navigator.pop(context);
                                      },
                                      padding: const EdgeInsets.symmetric(
                                        horizontal: 16.0,
                                        vertical: 5.0,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                              Container(
                                height: mediaQuery.size.height / 5.5,
                                width: mediaQuery.size.width,
                                child: CupertinoPicker(
                                  backgroundColor: Color(0xfff7f7f7),
                                  itemExtent: 25,
                                  diameterRatio: 1,
                                  useMagnifier: true,
                                  magnification: 1.3,
                                  scrollController: FixedExtentScrollController(
                                    initialItem: parametersInds[key],
                                  ),
                                  children: pickerChildren,
                                  onSelectedItemChanged: (idx) {
                                    setState(() {
                                      parametersValues[key] =
                                          value[idx]["value"];
                                      parametersInds[key] = idx;
                                    });
                                  },
                                ),
                              ),
                            ],
                          );
                        },
                      );
                    },
                    child: Container(
                      padding: EdgeInsets.symmetric(
                        horizontal: 15.0,
                        vertical: 5.0,
                      ),
                      decoration: BoxDecoration(
                        border: Border.all(
                          color: ProjectConstants.DEFAULT_STROKE_COLOR,
                        ),
                        borderRadius: BorderRadius.circular(
                          5.0,
                        ),
                      ),
                      child: Text(
                        parametersValues[key],
                        style: TextStyle(
                          fontSize: 16 * mediaQuery.textScaleFactor,
                          fontFamily: ProjectConstants.APP_FONT_FAMILY,
                          color: ProjectConstants.DEFAULT_STROKE_COLOR,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ),
                  SizedBox(
                    width: 10.0,
                  ),
                  Text(
                    "(+ ${_getParameterPrice(
                      key,
                      parametersValues[key],
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
        left: 20.0,
        right: 20.0,
      ),
      child: Column(
        children: children,
      ),
    );
  }

  Widget _getBodyWidget(BuildContext context, CartModel cartModel) {
    if (isLoading) {
      return Center(
        child: CircularProgressIndicator(),
      );
    }

    final mediaQuery = MediaQuery.of(context);

    print(productInfo);
    print(parametersValues);

    Widget scrollingBodyWidget = SingleChildScrollView(
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
            (productInfo["parameters"] as List).length > 0
                ? Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
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
                        mediaQuery,
                        productInfo["parameters"],
                      ),
                    ],
                  )
                : Container(),
            SizedBox(
              height: 25.0,
            ),
            Container(
              margin: const EdgeInsets.only(
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
              height: 25.0,
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

    return Container(
      height: mediaQuery.size.height,
      width: mediaQuery.size.width,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.end,
        mainAxisSize: MainAxisSize.max,
        children: [
          Expanded(
            child: scrollingBodyWidget,
          ),
          Container(
            decoration: BoxDecoration(
              color: Colors.white,
              boxShadow: [
                BoxShadow(
                  color: Colors.grey.shade400,
                  blurRadius: 8.0,
                  spreadRadius: 0.0,
                  offset: Offset(0, 1),
                ),
              ],
            ),
            padding: const EdgeInsets.only(
              top: 10,
              bottom: 10,
            ),
            child: _getAddCartButton(context, cartModel),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    bottomLoader = getBottomLoader(context);
    CartModel cartModel = context.watch<CartModel>();

    return Scaffold(
      backgroundColor: ProjectConstants.BACKGROUND_SCREEN_COLOR,
      body: _getBodyWidget(context, cartModel),
      appBar: getAppBar(context),
      bottomNavigationBar: getBottomNavigationBar(context),
    );
  }
}
