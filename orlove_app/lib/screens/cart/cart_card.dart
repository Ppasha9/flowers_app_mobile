import 'package:bottom_loader/bottom_loader.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:orlove_app/constants.dart';
import 'package:orlove_app/http/cart_controller.dart';
import 'package:orlove_app/models/cart_model.dart';
import 'package:orlove_app/screens/cart/cart_card_components.dart';
import 'package:orlove_app/screens/components/bottom_loader.dart';
import 'package:orlove_app/screens/order_formation/order_formation_receiver_screen.dart';
import 'package:orlove_app/storage/storage.dart';
import 'package:orlove_app/utils/utils.dart';
import 'package:provider/provider.dart';

final String cart_icon_tag = "cart-icon-tag";

class HeroDialogRoute<T> extends PageRoute<T> {
  HeroDialogRoute({
    @required WidgetBuilder builder,
    RouteSettings settings,
    bool fullscreenDialog = false,
  })  : _builder = builder,
        super(settings: settings, fullscreenDialog: fullscreenDialog);

  final WidgetBuilder _builder;

  @override
  bool get opaque => false;

  @override
  bool get barrierDismissible => true;

  @override
  Duration get transitionDuration => const Duration(milliseconds: 300);

  @override
  bool get maintainState => true;

  @override
  Color get barrierColor => Colors.black54;

  @override
  Widget buildTransitions(BuildContext context, Animation<double> animation,
      Animation<double> secondaryAnimation, Widget child) {
    return child;
  }

  @override
  Widget buildPage(BuildContext context, Animation<double> animation,
      Animation<double> secondaryAnimation) {
    return _builder(context);
  }

  @override
  String get barrierLabel => 'Popup dialog open';
}

class CartIconWidget extends StatefulWidget {
  @override
  CartIconWidgetState createState() => CartIconWidgetState();
}

class CartIconWidgetState extends State<CartIconWidget> {
  CartFullInfoDTO curCartFullInfo = null;

  void _onPressed(BuildContext context) {
    Navigator.of(context).push(
      HeroDialogRoute(
        builder: (_) => CartCard(
          cartIconState: this,
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final mediaQuery = MediaQuery.of(context);

    var children = <Widget>[];
    children.add(
      Container(
        decoration: BoxDecoration(
          color: Colors.white,
        ),
        child: Material(
          type: MaterialType.transparency,
          child: IconButton(
            icon: Icon(
              Icons.shopping_bag_outlined,
            ),
            onPressed: () => _onPressed(context),
            color: ProjectConstants.APP_FONT_COLOR,
            iconSize: 30.0,
          ),
        ),
      ),
    );

    CartModel cartModel = context.watch<CartModel>();
    cartModel.getCartFullInfo().then((value) {
      setState(() {
        curCartFullInfo = value;
      });
    });

    if (SecureStorage.isLogged && curCartFullInfo != null) {
      int numOfProducts = 0;
      for (ProductInCartDTO productInfo in curCartFullInfo.products) {
        numOfProducts += productInfo.amount;
      }
      if (numOfProducts > 0) {
        children.add(
          Container(
            margin: const EdgeInsets.only(
              top: 32.0,
              left: 32.0,
            ),
            width: 15.0,
            height: 15.0,
            decoration: BoxDecoration(
              border: Border.all(
                color: Colors.black,
              ),
              shape: BoxShape.circle,
              color: Colors.white,
            ),
            child: Center(
              child: Text(
                "$numOfProducts",
                style: TextStyle(
                  fontSize: 11 * mediaQuery.textScaleFactor,
                  fontFamily: ProjectConstants.APP_FONT_FAMILY,
                  color: Colors.black,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ),
        );
      }
    }

    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
      ),
      child: Hero(
        tag: cart_icon_tag,
        child: Container(
          decoration: BoxDecoration(
            color: Colors.white,
          ),
          child: Stack(
            children: children,
          ),
        ),
      ),
    );
  }
}

class CartCard extends StatefulWidget {
  final CartIconWidgetState cartIconState;

  const CartCard({this.cartIconState});

  @override
  CartCardState createState() => CartCardState();
}

class CartCardState extends State<CartCard> {
  BottomLoader bottomLoader;
  CartFullInfoDTO curCartFullInfo = null;

  Widget _getProductsCardsListWidget() {
    var children = <Widget>[];

    for (int i = 0; i < curCartFullInfo.products.length; i++) {
      children.add(
        ProductCardInCartCard(
          productIndexInCartArray: i,
          parentState: this,
          cartIconState: widget.cartIconState,
        ),
      );
    }

    return SingleChildScrollView(
      child: Column(
        children: children,
      ),
    );
  }

  Future _onConfirmButtonPressed(CartModel cartModel) async {
    if (curCartFullInfo.status == "Default") {
      if (!bottomLoader.isShowing()) {
        bottomLoader.display();
      }

      await CartController.increaseCartStatus();
      await cartModel.updateCartFullInfo();

      if (bottomLoader.isShowing()) {
        bottomLoader.close();
      }
    }

    Navigator.push(
      context,
      CupertinoPageRoute(
        builder: (_) => OrderFormationReceiverScreen(),
      ),
    );
  }

  Widget _getBodyWidget(MediaQueryData mediaQuery) {
    CartModel cartModel = context.watch<CartModel>();

    cartModel.getCartFullInfo().then((value) {
      setState(() {
        curCartFullInfo = value;
      });
    });

    if (!SecureStorage.isLogged ||
        curCartFullInfo == null ||
        curCartFullInfo.products.length == 0) {
      return Container(
        child: LayoutBuilder(
          builder: (ctx, BoxConstraints constraints) {
            return Column(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                Container(
                  height: constraints.maxHeight * 0.85,
                  child: Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          "В данный момент\nваша корзина пуста",
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            fontSize: 18 * mediaQuery.textScaleFactor,
                            fontFamily: ProjectConstants.APP_FONT_FAMILY,
                            fontWeight: FontWeight.w600,
                            color: ProjectConstants.APP_FONT_COLOR,
                            decoration: TextDecoration.none,
                          ),
                        ),
                        Text(
                          "Чтобы добавить нужный Вам товар,\nнажмите на соответствующую клавишу\nна странице товара",
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            fontSize: 9 * mediaQuery.textScaleFactor,
                            fontFamily: ProjectConstants.APP_FONT_FAMILY,
                            fontWeight: FontWeight.normal,
                            color: ProjectConstants.APP_FONT_COLOR,
                            decoration: TextDecoration.none,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                Divider(
                  thickness: 2.0,
                ),
                Container(
                  height: constraints.maxHeight * 0.10,
                  padding: const EdgeInsets.symmetric(
                    horizontal: 10.0,
                  ),
                  alignment: Alignment.centerLeft,
                  child: Container(
                    width: constraints.maxWidth / 2.2,
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          "Итого:",
                          style: TextStyle(
                            fontSize: 18 * mediaQuery.textScaleFactor,
                            fontFamily: ProjectConstants.APP_FONT_FAMILY,
                            fontWeight: FontWeight.w600,
                            color: ProjectConstants.APP_FONT_COLOR,
                            decoration: TextDecoration.none,
                          ),
                        ),
                        Text(
                          "0 Руб.",
                          style: TextStyle(
                            fontSize: 14 * mediaQuery.textScaleFactor,
                            fontFamily: ProjectConstants.APP_FONT_FAMILY,
                            fontWeight: FontWeight.normal,
                            color: ProjectConstants.APP_FONT_COLOR,
                            decoration: TextDecoration.none,
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

    return Container(
      child: LayoutBuilder(
        builder: (ctx, BoxConstraints constraints) {
          return Column(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              Container(
                height: constraints.maxHeight * 0.85,
                child: _getProductsCardsListWidget(),
              ),
              Divider(
                thickness: 2.0,
                color: ProjectConstants.APP_FONT_COLOR,
              ),
              Container(
                height: constraints.maxHeight * 0.10,
                padding: const EdgeInsets.symmetric(
                  horizontal: 10.0,
                ),
                alignment: Alignment.centerLeft,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Container(
                      width: constraints.maxWidth / 2.2,
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            "Итого:",
                            style: TextStyle(
                              fontSize: 18 * mediaQuery.textScaleFactor,
                              fontFamily: ProjectConstants.APP_FONT_FAMILY,
                              fontWeight: FontWeight.w600,
                              color: ProjectConstants.APP_FONT_COLOR,
                              decoration: TextDecoration.none,
                            ),
                          ),
                          Text(
                            "${Utils.getPriceCorrectString(curCartFullInfo.price.round())} Руб.",
                            style: TextStyle(
                              fontSize: 14 * mediaQuery.textScaleFactor,
                              fontFamily: ProjectConstants.APP_FONT_FAMILY,
                              fontWeight: FontWeight.normal,
                              decoration: TextDecoration.underline,
                              decorationColor: Colors.black,
                              decorationStyle: TextDecorationStyle.solid,
                              color: ProjectConstants.APP_FONT_COLOR,
                            ),
                          )
                        ],
                      ),
                    ),
                    Container(
                      width: constraints.maxWidth / 2.2,
                      child: GestureDetector(
                        onTap: () => _onConfirmButtonPressed(cartModel),
                        child: Center(
                          child: Container(
                            width: constraints.maxWidth * 0.3,
                            height: 30,
                            decoration: BoxDecoration(
                              borderRadius:
                                  BorderRadius.all(Radius.circular(1.0)),
                              color: ProjectConstants.BUTTON_BACKGROUND_COLOR,
                            ),
                            child: Center(
                              child: Text(
                                "Купить",
                                style: TextStyle(
                                  fontSize: 14 * mediaQuery.textScaleFactor,
                                  fontFamily: ProjectConstants.APP_FONT_FAMILY,
                                  color: ProjectConstants.BUTTON_TEXT_COLOR,
                                  fontWeight: FontWeight.w600,
                                  decoration: TextDecoration.none,
                                ),
                              ),
                            ),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          );
        },
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    bottomLoader = getBottomLoader(context);
    final mediaQuery = MediaQuery.of(context);

    return Center(
      child: Padding(
        padding: EdgeInsets.only(
          top: mediaQuery.padding.top + kToolbarHeight,
          bottom: (mediaQuery.size.height -
                  mediaQuery.padding.top +
                  kToolbarHeight) *
              0.25,
          left: mediaQuery.size.width * 0.15,
        ),
        child: Hero(
          tag: cart_icon_tag,
          child: Container(
            alignment: Alignment.topRight,
            decoration: BoxDecoration(
              color: ProjectConstants.BACKGROUND_SCREEN_COLOR,
              borderRadius: BorderRadius.only(
                bottomLeft: Radius.circular(10.0),
              ),
            ),
            child: _getBodyWidget(mediaQuery),
          ),
        ),
      ),
    );
  }
}
