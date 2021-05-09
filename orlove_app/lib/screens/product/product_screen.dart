import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:orlove_app/constants.dart';
import 'package:orlove_app/http/cart_controller.dart';
import 'package:orlove_app/http/product_controller.dart';
import 'package:orlove_app/screens/components/app_bar.dart';
import 'package:orlove_app/screens/components/bottom_navigation_bar.dart';
import 'package:orlove_app/screens/components/social_buttons.dart';
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
  bool isLoading = true;
  dynamic productInfo;

  bool isAddedToCart = false;

  @override
  void initState() {
    super.initState();
    ProductController.getProductInfoById(widget.id).then(
      (prInfo) {
        productInfo = prInfo;

        CartController.isProductInCart(widget.id).then((value) {
          isAddedToCart = value;
          setState(() {
            isLoading = false;
          });
        });
      },
    );
  }

  Future _addProductToCart() async {
    if (isAddedToCart) {
      return;
    }

    await CartController.addProductToCart(widget.id);
    await Utils.getAllCartInfo();
    setState(() {
      print("Product successfully added to cart");
      isAddedToCart = true;
    });
  }

  Widget _getAddCartButton(BuildContext context) {
    final mediaQuery = MediaQuery.of(context);

    if (!SecureStorage.isLogged) {
      return GestureDetector(
        onTap: () {
          Navigator.push(
            context,
            CupertinoPageRoute(
              builder: (_) => SignInScreen(),
            ),
          );
        },
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
                "Войти/зарегистрироваться",
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
    }

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
  }

  Widget _getBodyWidget(BuildContext context) {
    if (isLoading) {
      return Center(
        child: CircularProgressIndicator(),
      );
    }

    final mediaQuery = MediaQuery.of(context);

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
              child: Text(
                "${Utils.fromUTF8(productInfo["name"])}\n${productInfo["price"]} Руб.",
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 24 * mediaQuery.textScaleFactor,
                  fontFamily: ProjectConstants.APP_FONT_FAMILY,
                  color: ProjectConstants.APP_FONT_COLOR,
                ),
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
                left: 20.0,
              ),
              child: Text(
                Utils.fromUTF8(productInfo["description"]),
                textAlign: TextAlign.justify,
                style: TextStyle(
                  fontSize: 14 * mediaQuery.textScaleFactor,
                  fontFamily: ProjectConstants.APP_FONT_FAMILY,
                  color: ProjectConstants.APP_FONT_COLOR,
                ),
              ),
            ),
            SizedBox(
              height: 10.0,
            ),
            _getAddCartButton(context),
            SizedBox(
              height: 10.0,
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
            SocialButtonsWidget(),
            SizedBox(
              height: 10.0,
            ),
            Container(
              margin: const EdgeInsets.only(
                left: 10.0,
              ),
              child: Text(
                "Уход за цветами",
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
                left: 20.0,
              ),
              child: Text(
                "Описание ухода\n\t - поливать каждый день\n\t - наслаждаться запахом",
                textAlign: TextAlign.justify,
                style: TextStyle(
                  fontSize: 14 * mediaQuery.textScaleFactor,
                  fontFamily: ProjectConstants.APP_FONT_FAMILY,
                  color: ProjectConstants.APP_FONT_COLOR,
                ),
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
    return SafeArea(
      child: Scaffold(
        backgroundColor: ProjectConstants.BACKGROUND_SCREEN_COLOR,
        body: _getBodyWidget(context),
        appBar: getAppBar(context),
        bottomNavigationBar: getBottomNavigationBar(context),
      ),
    );
  }
}
